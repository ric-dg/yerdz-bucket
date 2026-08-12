# HomeNVR scoop bucket

Scoop manifests for [HomeNVR](https://github.com/ric-dg/homenvr) — a
self-hosted multi-camera NVR for Windows (motion & sound detection, event
recording, control panel). Windows only.

## Install

```powershell
scoop bucket add homenvr https://github.com/ric-dg/homenvr-bucket
scoop install homenvr
```

Two manifests:

| App | Package | Notes |
|-----|---------|-------|
| `homenvr` | `HomeNVR-<ver>-bundled.zip` | Includes pinned `go2rtc.exe` + `WinSW-x64.exe`. Recommended. |
| `homenvr-lite` | `HomeNVR-<ver>-lite.zip` | HomeNVR only; `go2rtc`/`ffmpeg`/`python` are auto-detected via PATH (or `tools.*` in the config). |

Both are **portable** — run HomeNVR via the installed `home-nvr` shim or
Start-menu shortcut (the control panel). A Windows *service* is a system-wide
concept and is NOT registered by scoop; install it with the
[HomeNVR installer](https://github.com/ric-dg/homenvr/releases) instead if you
want service mode. `config.jsonc` and `logs/` persist across updates.

## Updating on a new release

```powershell
pwsh bin/checkver.ps1    # bumps version + URLs to the newest release tag
pwsh bin/checkurls.ps1   # downloads each zip and verifies/fixes the SHA256
```

Requires `gh` authenticated against `ric-dg/homenvr`.

## Layout

```
bucket/homenvr.json        bundled-zip manifest (default)
bucket/homenvr-lite.json   lite-zip manifest
bin/checkver.ps1           version/URL bump
bin/checkurls.ps1          hash verification
```
