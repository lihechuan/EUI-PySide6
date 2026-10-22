#ifndef AppVersion
    #error AppVersion must be supplied by package.py
#endif
#ifndef PackageDir
    #error PackageDir must be supplied by package.py
#endif
#ifndef OutputDir
    #error OutputDir must be supplied by package.py
#endif
#ifndef AppArchitecture
    #error AppArchitecture must be supplied by package.py
#endif

[Setup]
AppId={{4EEA921E-0305-44FB-8C11-43CDACD4B39B}
AppName=EUI PySide6 Gallery
AppVersion={#AppVersion}
AppPublisher=EUI
DefaultDirName={localappdata}\Programs\EUI PySide6 Gallery
DefaultGroupName=EUI PySide6 Gallery
PrivilegesRequired=lowest
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
MinVersion=10.0
DisableProgramGroupPage=yes
OutputDir={#OutputDir}
OutputBaseFilename=EUI-PySide6-Gallery-{#AppVersion}-windows-{#AppArchitecture}-setup
SetupIconFile=..\assets\eui-icon.ico
UninstallDisplayIcon={app}\EUI-PySide6-Gallery.exe
Compression=lzma2
SolidCompression=yes
WizardStyle=modern

[Languages]
Name: "chinesesimplified"; MessagesFile: "ChineseSimplified.isl"
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: "{#PackageDir}\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{group}\EUI PySide6 Gallery"; Filename: "{app}\EUI-PySide6-Gallery.exe"; WorkingDir: "{app}"
Name: "{autodesktop}\EUI PySide6 Gallery"; Filename: "{app}\EUI-PySide6-Gallery.exe"; WorkingDir: "{app}"; Tasks: desktopicon

[Run]
Filename: "{app}\EUI-PySide6-Gallery.exe"; Description: "{cm:LaunchProgram,EUI PySide6 Gallery}"; Flags: nowait postinstall skipifsilent
