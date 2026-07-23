param(
    [string]$PluginRepo,
    [string]$ISCC,
    [switch]$SkipBuild
)

$ErrorActionPreference = 'Stop'
$ModuleRepo = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
if([string]::IsNullOrWhiteSpace($PluginRepo)) {
    $PluginRepo = Join-Path (Split-Path (Split-Path $ModuleRepo -Parent) -Parent) 'Plugins\Appeal_SDL2_Network'
}
$PluginRepo = (Resolve-Path $PluginRepo).Path

$ModuleVersion = (Get-Content (Join-Path $ModuleRepo 'VERSION') -Raw).Trim()
$PluginVersion = (Get-Content (Join-Path $PluginRepo 'VERSION') -Raw).Trim()
if($ModuleVersion -ne $PluginVersion) {
    throw "Module version $ModuleVersion does not match plugin version $PluginVersion"
}

if(-not $SkipBuild) {
    & (Join-Path $ModuleRepo 'Packaging\Windows\Build-Release.ps1')
    & (Join-Path $PluginRepo 'Packaging\Windows\Build-Release.ps1')
}

$ModuleStage = Join-Path $ModuleRepo "Dist\Appeal-Network-Module-$ModuleVersion-windows-x64"
$PluginStage = Join-Path $PluginRepo "Release\Appeal_SDL2_Network-$PluginVersion-windows-x64"
foreach($Required in $ModuleStage,$PluginStage) {
    if(-not (Test-Path -LiteralPath $Required)) {
        throw "Missing release stage: $Required"
    }
}

$Dist = Join-Path $ModuleRepo 'Dist'
$Stage = Join-Path $Dist "Appeal-Network-Test-Bundle-$ModuleVersion-windows-x64"
$Archive = Join-Path $Dist "Appeal-Network-Test-Bundle-$ModuleVersion-windows-x64.zip"
if(Test-Path -LiteralPath $Stage) {
    Remove-Item -LiteralPath $Stage -Recurse -Force
}
if(Test-Path -LiteralPath $Archive) {
    Remove-Item -LiteralPath $Archive -Force
}

New-Item -ItemType Directory -Path $Stage -Force | Out-Null
Copy-Item -Path (Join-Path $ModuleStage 'Resources') -Destination $Stage -Recurse -Force
Copy-Item -Path (Join-Path $PluginStage 'Resources') -Destination $Stage -Recurse -Force
Copy-Item -LiteralPath (Join-Path $PSScriptRoot 'BUNDLE_INSTALL.txt') -Destination $Stage
Copy-Item -LiteralPath (Join-Path $ModuleRepo 'LICENSE') -Destination (Join-Path $Stage 'MODULE_LICENSE')
Copy-Item -LiteralPath (Join-Path $PluginRepo 'LICENSE') -Destination (Join-Path $Stage 'PLUGIN_LICENSE')

Compress-Archive -Path (Join-Path $Stage '*') -DestinationPath $Archive -CompressionLevel Optimal
$Hash = Get-FileHash -Algorithm SHA256 -LiteralPath $Archive
$Hash.Hash + '  ' + (Split-Path $Archive -Leaf) |
    Set-Content -LiteralPath ($Archive + '.sha256') -Encoding ascii

Write-Host "Created $Archive"
Write-Host "SHA256 $($Hash.Hash)"

if([string]::IsNullOrWhiteSpace($ISCC)) {
    $Compiler = Get-Command ISCC.exe -ErrorAction SilentlyContinue
    if($null -ne $Compiler) {
        $ISCC = $Compiler.Source
    }
}

if(-not [string]::IsNullOrWhiteSpace($ISCC)) {
    & $ISCC "/DPluginRepo=$PluginRepo" (Join-Path $PSScriptRoot 'Network_Test_Bundle.iss')
    if($LASTEXITCODE -ne 0) {
        throw "Inno Setup failed with exit code $LASTEXITCODE"
    }
}
else {
    Write-Host 'Inno Setup was not found; the combined EXE installer was not rebuilt.'
}
