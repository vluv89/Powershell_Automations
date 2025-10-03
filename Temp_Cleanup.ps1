# Run as Admin
Write-Host "Starting system cleanup..." -ForegroundColor Cyan
# Clear Recycle Bin
try {
Write-Host "Emptying Recycle Bin..."
Clear-RecycleBin -Force -ErrorAction SilentlyContinue
} catch {
Write-Warning "Failed to clear Recycle Bin: $_"
}
# Clear Windows Temp
$tempPaths = @(
"$env:TEMP",
"$env:WINDIR\Temp",
"$env:LOCALAPPDATA\Temp"
)
foreach ($path in $tempPaths) {
if (Test-Path $path) {
Write-Host "Cleaning: $path"
Get-ChildItem -Path $path -Recurse -Force -ErrorAction SilentlyContinue | Remove-Item
-Force -Recurse -ErrorAction SilentlyContinue
}
}
# Clean Delivery Optimization files
$doPath = "C:\Windows\SoftwareDistribution\DeliveryOptimization"
if (Test-Path $doPath) {
Write-Host "Cleaning Delivery Optimization files..."
Get-ChildItem -Path $doPath -Recurse -Force -ErrorAction SilentlyContinue | Remove-Item
-Force -Recurse -ErrorAction SilentlyContinue
}
# Optional: Clean SoftwareDistribution\Download (Windows Update cache)
$updateCache = "C:\Windows\SoftwareDistribution\Download"
if (Test-Path $updateCache) {
Write-Host "Cleaning Windows Update cache..."
Get-ChildItem -Path $updateCache -Recurse -Force -ErrorAction SilentlyContinue |
Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
}
# Optional: Clean Prefetch
$prefetch = "$env:SystemRoot\Prefetch"
if (Test-Path $prefetch) {
Write-Host "Cleaning Prefetch folder..."
Get-ChildItem -Path $prefetch -Recurse -Force -ErrorAction SilentlyContinue | Remove-Item
-Force -Recurse -ErrorAction SilentlyContinue
}
# Clean Microsoft Edge browser cache
try {
Write-Host "Clearing Microsoft Edge browser cache..."
$edgeCachePath = "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Cache"
if (Test-Path $edgeCachePath) {
Get-ChildItem -Path $edgeCachePath -Recurse -Force -ErrorAction SilentlyContinue |
Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
}
} catch {
Write-Warning "Edge cache cleanup skipped or failed."
}
