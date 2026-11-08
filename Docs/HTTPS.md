# HTTPS HTML server

The SDL2 Network plugin now supports a portable Mbed TLS listener alongside its existing HTTP/ECHO/CHAT/APPEAL services. HTTPS uses the same HTML response handler and `Set_HTML_Path` folder (currently its `index.html` response). This adds encrypted server transport, not a new full web framework or TLS implementation for Network clients/downloads.

```text
Add_Dynamic_Module Network Appeal_SDL2_Network
Network Set_HTML_Path Resources/Network/HTML
Set_Var Ready (Network Configure_TLS Resources/Network/TLS/server.crt Resources/Network/TLS/server.key)
Network Configure HTTPS 127.0.0.1 8443
Network Disable HTTP
Network Server
Print (Network Is_Server_Running)
```

Check Configure_TLS before starting, as in `Resources/Appeal/Examples/Network/HTTPS_Server.Appeal`. The full example disables other default listeners and exposes only HTTPS. Existing HTTP remains available unless disabled; configure a different port if serving both. `Configure`/`Disable` endpoint changes apply at the next server restart.

New script APIs:

- **Configure_TLS Certificate_File Private_Key_File** (Basic): validate a PEM certificate/chain and matching unencrypted PEM private key; return 1/0. Paths follow the process working directory, like Set_HTML_Path. Stop the server before changing credentials. Failed credential setup clears TLS configuration, so an explicitly configured HTTPS endpoint cannot silently fall back to plain HTTP.
- **Is_Server_Running** (Basic): return 1/0.
- **Last_Error** (Basic): return the latest configuration/startup diagnostic.
- **Disable Type** (Advanced): remove a service endpoint before restarting the server. Types are case-insensitive, for example HTTP or ECHO.

TLS is opt-in: no HTTPS port is opened without a Configure HTTPS endpoint and valid credentials. It uses Mbed TLS defaults with a TLS 1.2 minimum. Clients verify certificate trust, hostname, and validity; no browser certificate-validation bypass is installed. Plain HTTP sent to the HTTPS port is rejected. No automatic certificate issuance, renewal, HTTP redirect, HSTS policy, or client HTTPS API is added.

The TLS listener is nonblocking, with at most 32 active connections, 64 KiB request headers, 10-second idle timeout, 30-second total connection lifetime, and 32 MiB response limit. Incomplete handshakes do not block other clients or server shutdown. Serving behavior otherwise matches the existing HTML server.

## Certificates

For development only:

```text
python Resources/Modules/Appeal_Module_Network/Appeal_SDL2_Network/Packaging/Create_Development_Certificate.py
Appeal.exe Examples/Network/HTTPS_Server
```

The helper needs the OpenSSL CLI (it finds the copy bundled with Git for Windows when present), refuses overwrites, and creates a seven-day self-signed localhost certificate. Trust that certificate explicitly in your development client; it is not a public certificate. Production deployments should use their own CA-issued certificate, protected key file, and intended bind address. Store credentials outside the HTML folder and keep them out of source control.

## Build

```text
python Resources/Modules/Appeal_Module_Network/Appeal_SDL2_Network/Packaging/Install_MbedTLS.py
make -C Resources/Modules/Appeal_Module_Network -f Makefile
make -C Resources/Modules/Appeal_Module_Network/Test -f Makefile
make -C Resources/Modules/Appeal_Module_Network/Appeal_SDL2_Network -f Makefile
```

The installer pins Mbed TLS 3.6.7 LTS, verifies release SHA-256 and GitHub's digest when provided, keeps the source/license/provenance, and builds static libraries using its portable vendor Makefile. Python, GNU make, gcc, and ar are needed. Libraries live in `.deps/mbedtls/lib/windows` (or linux/darwin); no new TLS runtime DLL is required. Keep the public headers and libraries from the same version. See https://mbed-tls.readthedocs.io/en/latest/kb/how-to/mbedtls-tutorial/ for the library's API.

## Validation

`python Tests/Network_HTTPS_Tests.py` checks CA-verified HTTPS, certificate hostname/trust rejection, rejection of plaintext and TLS 1.1, HTTP compatibility, incomplete-handshake isolation, stop/restart, and invalid certificate/key failure through the Appeal module. Test certificates are ephemeral and explicitly trusted only in the test client. Certificate generation in this test requires Python cryptography; this checkout reuses the local verifier package installed by the Security SDK installer, or a normal Python environment can provide it.
