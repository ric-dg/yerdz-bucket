# Validates each scoop manifest: downloads the zip, checks the SHA256, and
# rewrites the manifest's "hash" to the real value. Run after checkver.ps1.
$ErrorActionPreference = 'Stop'
$root = Join-Path (Split-Path -Parent $PSScriptRoot) 'bucket'
$tmp = Join-Path $env:TEMP "homenvr-checkurls"
New-Item -ItemType Directory -Path $tmp -Force | Out-Null

foreach ($m in @('homenvr', 'homenvr-lite')) {
    $path = Join-Path $root "$m.json"
    $json = Get-Content $path -Raw | ConvertFrom-Json
    $url = $json.url
    $file = Join-Path $tmp ([System.IO.Path]::GetFileName($url))
    Write-Host "downloading $url"
    Invoke-WebRequest -Uri $url -OutFile $file -UseBasicParsing
    $hash = (Get-FileHash $file -Algorithm SHA256).Hash.ToLowerInvariant()
    if ($hash -ne $json.hash) {
        $raw = Get-Content $path -Raw
        $raw = $raw -replace '"hash": "[0-9a-f]{64}"', "`"hash`": `"$hash`""
        Set-Content $path $raw -NoNewline
        Write-Host "  hash updated: $hash"
    } else {
        Write-Host "  hash OK: $hash"
    }
    Remove-Item $file -Force
}
Write-Host 'done'
