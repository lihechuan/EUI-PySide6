param(
    [string]$QtBin,
    [string]$EuiImportDir,
    [switch]$Gallery,
    [switch]$Verify
)

$ErrorActionPreference = 'Stop'
$repository = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '../../..'))
if (-not $QtBin) {
    $QtBin = Join-Path $repository 'build/qt-sdk/6.8.3/msvc2022_64/bin'
}
$runner = Join-Path $QtBin 'qml.exe'
if (-not (Test-Path -LiteralPath $runner)) {
    throw '找不到 Qt 6 的 qml.exe。请指定 -QtBin，例如 C:\Qt\6.8.3\msvc2022_64\bin。'
}
$version = [version](Get-Item -LiteralPath $runner).VersionInfo.ProductVersion
if ($version.Major -ne 6 -or $version -lt [version]'6.8') {
    throw "此示例需要 Qt 6.8 或更高版本，当前为 $version。"
}
$previousBackend = $env:QT_QUICK_BACKEND
$previousStyle = $env:QT_QUICK_CONTROLS_STYLE
$previousPath = $env:PATH
if (-not $EuiImportDir) {
    $EuiImportDir = @('build/quick3d-gallery-runtime/bin', 'bin/Qt6-Quick3D', 'build/quick3d-runtime') |
        ForEach-Object { Join-Path $repository $_ } |
        Where-Object { Test-Path -LiteralPath (Join-Path $_ 'EUI/euiplugin.dll') } |
        Select-Object -First 1
}
if (-not $EuiImportDir -or -not (Test-Path -LiteralPath (Join-Path $EuiImportDir 'EUI/qmldir'))) {
    throw '找不到 Qt 6 EUI 模块。请先构建 Qt 6 Gallery，或通过 -EuiImportDir 指定包含 EUI/ 的目录。'
}
$galleryDirectory = $EuiImportDir
if ($Gallery) {
    $runner = Join-Path $galleryDirectory 'example.exe'
    if (-not (Test-Path -LiteralPath $runner)) {
        throw '找不到 Qt 6 Gallery。请按 README 使用 Qt 6.8+ 编译至 bin/Qt6-Quick3D。'
    }
}
try {
    $env:PATH = $QtBin + [System.IO.Path]::PathSeparator + $env:PATH
    $env:QT_QUICK_BACKEND = ''
    $env:QT_QUICK_CONTROLS_STYLE = 'Basic'
    if ($Verify) {
        New-Item -ItemType Directory -Path (Join-Path $repository 'build/littlest-tokyo') -Force | Out-Null
        $testRunner = Join-Path $QtBin 'qmltestrunner.exe'
        $suite = Join-Path $PSScriptRoot 'tests/tst_tokyo.qml'
        $imports = $EuiImportDir
        if ($Gallery) {
            $testRunner = Join-Path $galleryDirectory 'eui_gallery_tests.exe'
            $suite = Join-Path $repository 'tests/qml/tst_quick3d_gallery.qml'
            $imports = $galleryDirectory
        }
        & python (Join-Path $repository 'tests/run_isolated_qml.py') $testRunner `
            $suite $imports
    } elseif ($Gallery) {
        & $runner
    } else {
        & $runner -I $EuiImportDir (Join-Path $PSScriptRoot 'Main.qml')
    }
    if ($LASTEXITCODE -ne 0) {
        throw "示例运行失败，退出码：$LASTEXITCODE"
    }
} finally {
    $env:QT_QUICK_BACKEND = $previousBackend
    $env:QT_QUICK_CONTROLS_STYLE = $previousStyle
    $env:PATH = $previousPath
}
