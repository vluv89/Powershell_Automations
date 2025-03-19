# PC Cleanup and Optimization Script
# This script performs various cleanup operations to speed up your laptop

# Run as administrator check
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "Please run this script as an Administrator!"
    break
}

# Create a log file
$logFile = "$env:USERPROFILE\Desktop\PC_Cleanup_Log_$(Get-Date -Format 'yyyyMMdd_HHmmss').txt"
Start-Transcript -Path $logFile

Write-Host "=== PC Cleanup and Optimization Script ===" -ForegroundColor Green
Write-Host "Starting cleanup process at $(Get-Date)" -ForegroundColor Cyan
Write-Host "This script will clean temporary files, browser caches, and optimize your system" -ForegroundColor Cyan
Write-Host "----------------------------------------------" -ForegroundColor Cyan

# 1. Cleanup Windows Temp Files
Write-Host "`n[1/8] Cleaning Windows Temporary Files..." -ForegroundColor Yellow
$tempFolders = @(
    "$env:TEMP",
    "$env:SystemRoot\Temp",
    "$env:SystemRoot\Prefetch"
)

foreach ($folder in $tempFolders) {
    if (Test-Path $folder) {
        try {
            Get-ChildItem -Path $folder -File -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue
            Write-Host "  Cleaned $folder" -ForegroundColor Green
        }
        catch {
            Write-Host "  Failed to completely clean $folder - some files might be in use" -ForegroundColor Red
        }
    }
}

# 2. Clear Recycle Bin
Write-Host "`n[2/8] Emptying Recycle Bin..." -ForegroundColor Yellow
try {
    Clear-RecycleBin -Force -ErrorAction SilentlyContinue
    Write-Host "  Recycle Bin emptied successfully" -ForegroundColor Green
}
catch {
    Write-Host "  Failed to empty Recycle Bin" -ForegroundColor Red
}

# 3. Clear Browser Caches
Write-Host "`n[3/8] Clearing Browser Caches..." -ForegroundColor Yellow

# Chrome
$chromeCachePath = "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Cache"
if (Test-Path $chromeCachePath) {
    try {
        Get-ChildItem -Path $chromeCachePath -File -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue
        Write-Host "  Chrome cache cleared" -ForegroundColor Green
    }
    catch {
        Write-Host "  Failed to clear Chrome cache - browser might be running" -ForegroundColor Red
    }
}

# Edge
$edgeCachePath = "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Cache"
if (Test-Path $edgeCachePath) {
    try {
        Get-ChildItem -Path $edgeCachePath -File -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue
        Write-Host "  Edge cache cleared" -ForegroundColor Green
    }
    catch {
        Write-Host "  Failed to clear Edge cache - browser might be running" -ForegroundColor Red
    }
}

# Firefox
$firefoxProfiles = "$env:APPDATA\Mozilla\Firefox\Profiles"
if (Test-Path $firefoxProfiles) {
    try {
        Get-ChildItem -Path $firefoxProfiles -Directory | ForEach-Object {
            $cachePath = "$($_.FullName)\cache2"
            if (Test-Path $cachePath) {
                Get-ChildItem -Path $cachePath -File -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue
            }
        }
        Write-Host "  Firefox cache cleared" -ForegroundColor Green
    }
    catch {
        Write-Host "  Failed to clear Firefox cache - browser might be running" -ForegroundColor Red
    }
}

# 4. Clean Windows Update Cache
Write-Host "`n[4/8] Cleaning Windows Update Cache..." -ForegroundColor Yellow
try {
    Stop-Service -Name wuauserv -Force
    Get-ChildItem "$env:SystemRoot\SoftwareDistribution\Download" -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
    Start-Service -Name wuauserv
    Write-Host "  Windows Update cache cleaned" -ForegroundColor Green
}
catch {
    Write-Host "  Failed to clean Windows Update cache" -ForegroundColor Red
    Start-Service -Name wuauserv -ErrorAction SilentlyContinue
}

# 5. Clear Thumbnail Cache
Write-Host "`n[5/8] Clearing Thumbnail Cache..." -ForegroundColor Yellow
try {
    Remove-Item -Path "$env:LOCALAPPDATA\Microsoft\Windows\Explorer\thumbcache_*.db" -Force -ErrorAction SilentlyContinue
    Write-Host "  Thumbnail cache cleared" -ForegroundColor Green
}
catch {
    Write-Host "  Failed to clear thumbnail cache" -ForegroundColor Red
}

# 6. Run Disk Cleanup utility
Write-Host "`n[6/8] Running Disk Cleanup Utility..." -ForegroundColor Yellow
try {
    $cleanupProcess = Start-Process -FilePath cleanmgr.exe -ArgumentList "/sagerun:1" -NoNewWindow -PassThru
    Write-Host "  Disk Cleanup initiated" -ForegroundColor Green
}
catch {
    Write-Host "  Failed to run Disk Cleanup" -ForegroundColor Red
}

# 7. Optimize Windows Services
Write-Host "`n[7/8] Optimizing Windows Services..." -ForegroundColor Yellow

# Disable unnecessary startup items
Write-Host "  Listing startup items (consider disabling unnecessary ones):" -ForegroundColor Cyan
Get-CimInstance Win32_StartupCommand | Select-Object Name, Command, Location, User | Format-Table -AutoSize

# Disable Superfetch if enabled
try {
    $superfetch = Get-Service -Name "SysMain" -ErrorAction SilentlyContinue
    if ($superfetch -and $superfetch.Status -eq "Running") {
        Stop-Service -Name "SysMain" -Force
        Set-Service -Name "SysMain" -StartupType Disabled
        Write-Host "  Superfetch service disabled" -ForegroundColor Green
    }
}
catch {
    Write-Host "  Failed to disable Superfetch service" -ForegroundColor Red
}

# 8. Run DISM and SFC to repair system files
Write-Host "`n[8/8] Running System File Checker and DISM..." -ForegroundColor Yellow
try {
    Write-Host "  Running DISM (this might take a while)..." -ForegroundColor Cyan
    Start-Process -FilePath "DISM.exe" -ArgumentList "/Online", "/Cleanup-Image", "/RestoreHealth" -NoNewWindow -Wait
    
    Write-Host "  Running System File Checker (this might take a while)..." -ForegroundColor Cyan
    Start-Process -FilePath "sfc.exe" -ArgumentList "/scannow" -NoNewWindow -Wait
    
    Write-Host "  System file check completed" -ForegroundColor Green
}
catch {
    Write-Host "  Failed to complete system file check" -ForegroundColor Red
}

# Additional optimization - Clear Event Logs
Write-Host "`n[Bonus] Clearing Event Logs..." -ForegroundColor Yellow
try {
    wevtutil el | ForEach-Object { wevtutil cl "$_" 2>$null }
    Write-Host "  Event logs cleared" -ForegroundColor Green
}
catch {
    Write-Host "  Failed to clear some event logs" -ForegroundColor Red
}

# Display system info after cleanup
Write-Host "`n=== System Information After Cleanup ===" -ForegroundColor Green
$diskInfo = Get-CimInstance -ClassName Win32_LogicalDisk | Where-Object {$_.DriveType -eq 3}
foreach ($disk in $diskInfo) {
    $freeSpaceGB = [math]::Round($disk.FreeSpace / 1GB, 2)
    $totalSpaceGB = [math]::Round($disk.Size / 1GB, 2)
    $percentFree = [math]::Round(($disk.FreeSpace / $disk.Size) * 100, 2)
    
    Write-Host "Drive $($disk.DeviceID):" -ForegroundColor Cyan
    Write-Host "  Free Space: $freeSpaceGB GB of $totalSpaceGB GB ($percentFree% free)" -ForegroundColor White
}

# Cleanup complete
Write-Host "`n=== Cleanup Process Completed ===" -ForegroundColor Green
Write-Host "Finished at $(Get-Date)" -ForegroundColor Cyan
Write-Host "A log file has been created at: $logFile" -ForegroundColor Cyan
Write-Host "You may need to restart your computer for all changes to take effect." -ForegroundColor Yellow

Stop-Transcript
