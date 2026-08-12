# Refreshes the HomeNVR scoop manifests for the newest release tag.
# Requires: gh authenticated against the homenvr repo.
$ErrorActionPreference = 'Stop'
$root = Join-Path (Split-Path -Parent $PSScriptRoot) 'bucket'
$repo = 'ric-dg/homenvr'

$tag = (gh release view --repo $repo --json tagName --jq .tagName)
if (-not $tag) { throw 'no release found' }
$ver = $tag.TrimStart('v')
Write-Host "latest release: $tag"

foreach ($m in @('homenvr', 'homenvr-lite')) {
    $path = Join-Path $root "$m.json"
    $json = Get-Content $path -Raw
    $json = $json -replace '"version": "\d+\.\d+\.\d+"', "`"version`": `"$ver`""
    $json = $json -replace '/v\d+\.\d+\.\d+/', "/$tag/"
    $json = $json -replace 'HomeNVR-\d+\.\d+\.\d+', "HomeNVR-$ver"
    Set-Content $path $json -NoNewline
    Write-Host "updated $m.json -> $ver"
}
Write-Host "next: run bin/checkurls.ps1 to fill in the real hashes"
