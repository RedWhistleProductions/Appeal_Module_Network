# Network

An Appeal module project.

## Development status

This repository was separated from the Appeal beta development tree. Its build and installer configuration will be modernized before the first standalone release.

Generated binaries and intermediate objects are intentionally excluded from version control.

## Windows portable release

Run the release builder from PowerShell:

```powershell
.\Packaging\Windows\Build-Release.ps1
```

The generated portable ZIP is an overlay for an existing Appeal folder. It
contains:

```text
Resources/Modules/Network/Network.dll
Resources/Appeal/Network/*.Appeal
```

Extract it into the folder containing `Appeal.exe`.

For a local checkout containing both the Network Module and SDL2 Network
plugin repositories, build a combined test bundle with:

```powershell
.\Packaging\Windows\Build-Test-Bundle.ps1
```
