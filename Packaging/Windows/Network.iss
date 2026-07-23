#define ModuleName "Network"
#define ModuleVersion "1.0.0-beta.2"

[Setup]
AppId={{1CDA6F01-47AC-4F75-A460-BA673068F007}
AppName=Appeal {#ModuleName} Module
AppVersion={#ModuleVersion}
AppPublisher=Red Whistle
DefaultDirName={localappdata}\Programs\Appeal Modules\{#ModuleName}
DefaultGroupName=Appeal Modules
DisableProgramGroupPage=yes
OutputDir=..\..\Dist
OutputBaseFilename=Appeal-{#ModuleName}-Module-{#ModuleVersion}-windows-x64-installer
Compression=lzma
SolidCompression=yes
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
PrivilegesRequired=lowest
UninstallDisplayName=Appeal {#ModuleName} Module
LicenseFile=..\..\LICENSE

[Files]
Source: "..\..\{#ModuleName}.dll"; DestDir: "{code:GetAppealResources}\Modules\{#ModuleName}"; Flags: ignoreversion
Source: "..\..\Resources\Network\*"; DestDir: "{code:GetAppealResources}\Appeal\Network"; Flags: ignoreversion recursesubdirs createallsubdirs

[Dirs]
Name: "{code:GetAppealResources}\Modules\{#ModuleName}"
Name: "{code:GetAppealResources}\Appeal\Network"

[Code]
var
  AppealResourcesPage: TInputDirWizardPage;

procedure InitializeWizard;
begin
  AppealResourcesPage :=
    CreateInputDirPage(
      wpSelectDir,
      'Appeal Resources Folder',
      'Select the Resources folder used by Appeal.',
      'For a portable installation, select the Resources folder beside Appeal.exe.',
      False,
      '');
  AppealResourcesPage.Add('');
  AppealResourcesPage.Values[0] := ExpandConstant('{userdocs}\Appeal\Resources');
end;

function GetAppealResources(Param: String): String;
var
  OverridePath: String;
begin
  OverridePath := ExpandConstant('{param:APPEALRESOURCES|}');
  if OverridePath <> '' then
    Result := OverridePath
  else
    Result := AppealResourcesPage.Values[0];
end;
