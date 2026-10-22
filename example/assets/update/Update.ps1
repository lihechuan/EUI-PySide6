param(
    [Parameter(Mandatory)][ValidateSet('prepare', 'apply')][string]$Mode,
    [Parameter(Mandatory)][string]$Job
)

$ErrorActionPreference = 'Stop'
$workspace = [IO.Path]::GetFullPath((Split-Path -LiteralPath $Job))
$jobPath = Join-Path $workspace 'job.json'
if ([IO.Path]::GetFullPath($Job) -ne $jobPath -or
    (Split-Path -Leaf $workspace) -notlike '.eui-update-*' -or
    (Get-Item -LiteralPath $workspace).Attributes -band [IO.FileAttributes]::ReparsePoint) {
    throw 'Invalid update workspace.'
}
$metadata = Get-Content -LiteralPath $jobPath -Raw -Encoding UTF8 | ConvertFrom-Json
$target = [IO.Path]::GetFullPath($metadata.target).TrimEnd('\')
$parentDirectory = Split-Path -LiteralPath $workspace
if ((Split-Path -LiteralPath $target) -ne $parentDirectory -or
    -not (Test-Path -LiteralPath (Join-Path $target 'EUI-PySide6-Gallery.exe')) -or
    (Get-Item -LiteralPath $target).Attributes -band [IO.FileAttributes]::ReparsePoint -or
    $metadata.version -notmatch '^\d+(\.\d+){1,3}$' -or
    $metadata.sha256 -notmatch '^[0-9a-f]{64}$') {
    throw 'Invalid update target.'
}
$package = Join-Path $workspace 'package.zip'
$staged = Join-Path $workspace 'EUI-PySide6-Gallery'
$backup = Join-Path $parentDirectory ((Split-Path -Leaf $target) + '.before-' + (Split-Path -Leaf $workspace))
if (Test-Path -LiteralPath $backup) {
    throw 'Backup already exists.'
}

if ($Mode -eq 'prepare') {
    $stream = [IO.File]::OpenRead($package)
    $hasher = [Security.Cryptography.SHA256]::Create()
    try {
        $checksum = [BitConverter]::ToString($hasher.ComputeHash($stream)).Replace('-', '').ToLowerInvariant()
    } finally {
        $hasher.Dispose()
        $stream.Dispose()
    }
    if ($checksum -ne $metadata.sha256) {
        throw 'Package checksum mismatch.'
    }
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    $archive = [IO.Compression.ZipFile]::OpenRead($package)
    try {
        $seen = [Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
        $totalSize = 0L
        foreach ($entry in $archive.Entries) {
            $path = $entry.FullName.Replace('\', '/')
            $parts = $path.TrimEnd('/').Split('/')
            if (-not $path.StartsWith('EUI-PySide6-Gallery/') -or $path.Contains('//') -or
                ($parts | Where-Object { $_ -in '.', '..' -or $_ -match '[:<>"|?*\x00-\x1f]' -or
                    $_.EndsWith('.') -or $_.EndsWith(' ') -or
                    $_ -match '^(?i:CON|PRN|AUX|NUL|COM[1-9]|LPT[1-9])(?:\.|$)' })) {
                throw 'Unsafe archive path.'
            }
            if (-not $seen.Add($path.TrimEnd('/')) -or
                (($entry.ExternalAttributes -shr 16) -band 0xF000) -eq 0xA000) {
                throw 'Duplicate archive path or symbolic link.'
            }
            $totalSize += $entry.Length
            if ($archive.Entries.Count -gt 100000 -or $totalSize -gt 12GB) {
                throw 'Archive is too large.'
            }
        }
        $index = 0
        foreach ($entry in $archive.Entries) {
            $destination = [IO.Path]::GetFullPath((Join-Path $workspace $entry.FullName))
            if (-not $destination.StartsWith($workspace + '\', [StringComparison]::OrdinalIgnoreCase)) {
                throw 'Archive escaped workspace.'
            }
            if ($entry.FullName.EndsWith('/')) {
                [IO.Directory]::CreateDirectory($destination) | Out-Null
            } else {
                [IO.Directory]::CreateDirectory([IO.Path]::GetDirectoryName($destination)) | Out-Null
                [IO.Compression.ZipFileExtensions]::ExtractToFile($entry, $destination, $false)
            }
            $index++
            Write-Output ([int](100 * $index / $archive.Entries.Count))
        }
    } finally {
        $archive.Dispose()
    }
    foreach ($name in 'EUI-PySide6-Gallery.exe', '_internal\PySide6\Qt6Core.dll', '_internal\eui\resources.rcc', '_internal\eui_gallery\example.rcc') {
        if (-not (Test-Path -LiteralPath (Join-Path $staged $name) -PathType Leaf)) {
            throw 'Incomplete update package.'
        }
    }
    $core = [Diagnostics.FileVersionInfo]::GetVersionInfo((Join-Path $staged '_internal\PySide6\Qt6Core.dll'))
    if ($core.FileMajorPart -ne 6) { throw 'Invalid Qt runtime.' }
    exit 0
}

$moved = $false
$installed = $false
$successor = $null

function Start-Gallery([string]$Arguments) {
    $start = [Diagnostics.ProcessStartInfo]::new()
    $start.FileName = Join-Path $target 'EUI-PySide6-Gallery.exe'
    $start.WorkingDirectory = $target
    $start.Arguments = $Arguments
    $start.UseShellExecute = $false
    $start.CreateNoWindow = $true
    $start.WindowStyle = [Diagnostics.ProcessWindowStyle]::Hidden
    return [Diagnostics.Process]::Start($start)
}

try {
    Wait-Process -Id $metadata.pid -Timeout 60 -ErrorAction SilentlyContinue
    if (Get-Process -Id $metadata.pid -ErrorAction SilentlyContinue) {
        throw 'The application did not exit.'
    }
    Move-Item -LiteralPath $target -Destination $backup
    $moved = $true
    Move-Item -LiteralPath $staged -Destination $target
    $installed = $true
    foreach ($file in Get-ChildItem -LiteralPath $backup -Filter 'unins*' -File) {
        Copy-Item -LiteralPath $file.FullName -Destination $target
    }
    Set-Content -LiteralPath (Join-Path $workspace 'installed') -Value $metadata.version -Encoding ASCII
    $restartArguments = @($metadata.arguments | ForEach-Object {
        '"' + ([string]$_).Replace('"', '\"') + '"'
    }) -join ' '
    $successor = Start-Gallery $restartArguments
    $deadline = [DateTime]::UtcNow.AddSeconds(60)
    while (-not (Test-Path -LiteralPath ($jobPath + '.ready'))) {
        Start-Sleep -Milliseconds 200
        if (-not (Test-Path -LiteralPath ($jobPath + '.ready')) -and
            ($successor.HasExited -or [DateTime]::UtcNow -ge $deadline)) {
            throw 'The new application did not become ready.'
        }
    }
} catch {
    $_ | Out-String | Set-Content -LiteralPath (Join-Path $workspace 'error.txt')
    if ($null -ne $successor -and -not $successor.HasExited) {
        Stop-Process -Id $successor.Id
        $successor.WaitForExit(10000) | Out-Null
    }
    if ($installed) { Move-Item -LiteralPath $target -Destination $staged }
    if ($moved) { Move-Item -LiteralPath $backup -Destination $target }
    Start-Gallery '--update-failed' | Out-Null
    exit 1
}

# Keep the previous directory as a backup, including files added by the user.
$resolvedWorkspace = (Resolve-Path -LiteralPath $workspace).Path
if ((Split-Path -LiteralPath $resolvedWorkspace) -eq $parentDirectory -and
    (Split-Path -Leaf $resolvedWorkspace) -like '.eui-update-*') {
    Remove-Item -LiteralPath $resolvedWorkspace -Recurse -Force
}
