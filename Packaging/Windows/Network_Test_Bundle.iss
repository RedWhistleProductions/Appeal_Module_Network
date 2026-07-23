#define ModuleName "Network"
#define ModuleVersion "1.0.0-beta.2"

#ifndef PluginRepo
  #define PluginRepo "..\..\..\..\Plugins\Appeal_SDL2_Network"
#endif

[Setup]
AppId={{AD854E25-04BB-45EB-84C6-FED711CBAC72}
AppName=Appeal Network Test Bundle
AppVersion={#ModuleVersion}
AppPublisher=Red Whistle
DefaultDirName={localappdata}\Programs\Appeal Network Test Bundle
DefaultGroupName=Appeal Network
DisableProgramGroupPage=yes
OutputDir=..\..\Dist
OutputBaseFilename=Appeal-Network-Test-Bundle-{#ModuleVersion}-windows-x64-installer
Compression=lzma
SolidCompression=yes
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
PrivilegesRequired=lowest
UninstallDisplayName=Appeal Network Test Bundle
LicenseFile=..\..\LICENSE

[Files]
Source: "..\..\Network.dll"; DestDir: "{code:GetAppealResources}\Modules\Network"; Flags: ignoreversion
Source: "..\..\Resources\Network\*"; DestDir: "{code:GetAppealResources}\Appeal\Network"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "{#PluginRepo}\Appeal_SDL2_Network.dll"; DestDir: "{code:GetAppealResources}\Modules\Network\Appeal_SDL2_Network"; Flags: ignoreversion
Source: "{#PluginRepo}\plugin.json"; DestDir: "{code:GetAppealResources}\Modules\Network\Appeal_SDL2_Network"; Flags: ignoreversion
Source: "{#PluginRepo}\.deps\windows-x64\bin\SDL2.dll"; DestDir: "{code:GetAppealResources}\Modules\Network\Appeal_SDL2_Network"; Flags: ignoreversion
Source: "{#PluginRepo}\.deps\windows-x64\bin\SDL2_net.dll"; DestDir: "{code:GetAppealResources}\Modules\Network\Appeal_SDL2_Network"; Flags: ignoreversion

[Dirs]
Name: "{code:GetAppealResources}\Modules\Network"
Name: "{code:GetAppealResources}\Modules\Network\Appeal_SDL2_Network"
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
      'For your portable installation, select the Resources folder beside Appeal.exe.',
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
