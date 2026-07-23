param(
    [switch]$SkipBuild
)

$ErrorActionPreference = 'Stop'
$RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
$Version = (Get-Content (Join-Path $RepoRoot 'VERSION') -Raw).Trim()
$Dist = Join-Path $RepoRoot 'Dist'
$Stage = Join-Path $Dist "Appeal-Network-Module-$Version-windows-x64"
$Archive = Join-Path $Dist "Appeal-Network-Module-$Version-windows-x64-portable.zip"

if(-not $SkipBuild) {
    & make -B -C $RepoRoot
    if($LASTEXITCODE -ne 0) {
        throw "Network Module build failed with exit code $LASTEXITCODE"
    }
}

$Module = Join-Path $RepoRoot 'Network.dll'
if(-not (Test-Path -LiteralPath $Module)) {
    throw "Missing Network Module: $Module"
}

if(Test-Path -LiteralPath $Stage) {
    Remove-Item -LiteralPath $Stage -Recurse -Force
}
if(Test-Path -LiteralPath $Archive) {
    Remove-Item -LiteralPath $Archive -Force
}

$ModuleDestination = Join-Path $Stage 'Resources\Modules\Network'
$ScriptDestination = Join-Path $Stage 'Resources\Appeal\Network'
New-Item -ItemType Directory -Path $ModuleDestination,$ScriptDestination -Force | Out-Null

Copy-Item -LiteralPath $Module -Destination $ModuleDestination
Copy-Item -Path (Join-Path $RepoRoot 'Resources\Network\*.Appeal') -Destination $ScriptDestination
Copy-Item -LiteralPath (Join-Path $RepoRoot 'LICENSE') -Destination $Stage
Copy-Item -LiteralPath (Join-Path $RepoRoot 'VERSION') -Destination $Stage
Copy-Item -LiteralPath (Join-Path $PSScriptRoot 'PORTABLE_INSTALL.txt') -Destination $Stage

Compress-Archive -Path (Join-Path $Stage '*') -DestinationPath $Archive -CompressionLevel Optimal
Write-Host "Created $Archive"

$ISCC = Get-Command ISCC.exe -ErrorAction SilentlyContinue
if($null -ne $ISCC) {
    & $ISCC.Source (Join-Path $PSScriptRoot 'Network.iss')
    if($LASTEXITCODE -ne 0) {
        throw "Inno Setup failed with exit code $LASTEXITCODE"
    }
}
else {
    Write-Host 'Inno Setup was not found; the portable ZIP was created without rebuilding the EXE installer.'
}
