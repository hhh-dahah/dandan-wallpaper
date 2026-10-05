# Installs the "dandan boids" wallpaper into the Lively Wallpaper library.
# Usage (PowerShell):  .\install.ps1
# If scripts are blocked:  powershell -ExecutionPolicy Bypass -File .\install.ps1

$ErrorActionPreference = "Stop"
$src = Join-Path $PSScriptRoot "wallpaper"
if (-not (Test-Path (Join-Path $src "index.html"))) { throw "wallpaper\index.html not found next to this script." }

$store = Join-Path $env:LOCALAPPDATA "Packages\12030rocksdanister.LivelyWallpaper_97hta09mmv6hy\LocalCache\Local\Lively Wallpaper\Library\wallpapers"
$exe   = Join-Path $env:LOCALAPPDATA "Lively Wallpaper\Library\wallpapers"

if (Test-Path $store)    { $lib = $store; $kind = "Microsoft Store" }
elseif (Test-Path $exe)  { $lib = $exe;   $kind = "installer (GitHub)" }
else { throw "Lively Wallpaper library not found. Install Lively first and start it once." }

$dest = Join-Path $lib "dandanbo.ids"
New-Item -ItemType Directory -Force $dest | Out-Null
Copy-Item (Join-Path $src "*") $dest -Force
Write-Host "Installed to: $dest  (Lively $kind version)"

# Lively scans the library at startup, so restart it if it is running.
$running = Get-Process Lively, Lively.UI.WinUI -ErrorAction SilentlyContinue
if ($running) {
    $running | Stop-Process -Force
    Start-Sleep -Seconds 3
    $pkg = Get-AppxPackage | Where-Object { $_.Name -match "Lively" }
    if ($pkg) { Start-Process ("shell:AppsFolder\" + $pkg.PackageFamilyName + "!App") }
    else {
        $local = Join-Path $env:LOCALAPPDATA "Programs\Lively Wallpaper\Lively.exe"
        if (Test-Path $local) { Start-Process $local }
    }
    Write-Host "Lively restarted."
}
Write-Host "Done. Open Lively, find 'Boids' in the library and apply it."
