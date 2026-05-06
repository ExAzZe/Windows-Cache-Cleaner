#Requires -RunAsAdministrator
[CmdletBinding()]
param(
    [switch]$DryRun
)

$Host.UI.RawUI.WindowTitle = "Windows Cache Cleaner"
$LogDir     = "$PSScriptRoot\Logs"
$LogFile    = "$LogDir\CacheCleaner_$(Get-Date -Format 'yyyy-MM-dd_HH-mm-ss').log"
$TotalFreed = [long]0

if (-not (Test-Path $LogDir)) {
    New-Item -ItemType Directory -Path $LogDir -Force | Out-Null
}

function Write-Log {
    param([string]$Message, [string]$Color = "White")
    $line = "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] $Message"
    Write-Host $line -ForegroundColor $Color
    Add-Content -Path $LogFile -Value $line
}

function Get-FolderSizeBytes {
    param([string]$Path, [string]$Filter = "*")
    if (-not (Test-Path $Path)) { return [long]0 }
    $sum = (Get-ChildItem -Path $Path -Filter $Filter -Recurse -Force -File -ErrorAction SilentlyContinue |
            Measure-Object -Property Length -Sum).Sum
    if ($null -eq $sum) { return [long]0 }
    return [long]$sum
}

function Clear-Folder {
    param(
        [string]$Label,
        [string]$Path,
        [string]$Filter = "*"
    )

    if (-not (Test-Path $Path)) {
        Write-Log " - $Label : Path not found, skipped" "Yellow"
        return
    }

    $files      = Get-ChildItem -Path $Path -Filter $Filter -Recurse -Force -File -ErrorAction SilentlyContinue
    $fileCount  = $files.Count
    $sizeBefore = [long]($files | Measure-Object -Property Length -Sum).Sum

    if ($DryRun) {
        Write-Log " - [DRYRUN] $Label : $fileCount files (~$([math]::Round($sizeBefore / 1MB, 2)) MB)" "Cyan"
        return
    }

    Get-ChildItem -Path $Path -Filter $Filter -Recurse -Force -ErrorAction SilentlyContinue |
        Remove-Item -Recurse -Force -ErrorAction SilentlyContinue

    $sizeAfter      = Get-FolderSizeBytes -Path $Path -Filter $Filter
    $freed          = $sizeBefore - $sizeAfter
    $script:TotalFreed += $freed

    Write-Log " - $Label : CLEAN ($fileCount files, $([math]::Round($freed / 1MB, 2)) MB freed)" "Green"
}

# ---------------------------------------------------------------------------
Clear-Host
Write-Log "==========================================" "Cyan"
Write-Log "         WINDOWS CACHE CLEANER" "Cyan"
if ($DryRun) {
    Write-Log "      ** DRY RUN - No files will be deleted **" "Yellow"
}
Write-Log "==========================================" "Cyan"
Write-Log ""

Write-Log "[*] Cleaning User Temp folder..."
Clear-Folder -Label "User Temp" -Path $env:TEMP

Write-Log "[*] Cleaning Windows Temp folder..."
Clear-Folder -Label "Windows Temp" -Path "$env:windir\Temp"

Write-Log "[*] Cleaning Prefetch folder..."
Clear-Folder -Label "Prefetch" -Path "$env:windir\Prefetch"

Write-Log "[*] Cleaning Windows Update Cache..."
Clear-Folder -Label "Update Cache" -Path "$env:windir\SoftwareDistribution\Download"

Write-Log "[*] Cleaning Thumbnail Cache..."
Clear-Folder -Label "Thumbnail Cache" -Path "$env:LOCALAPPDATA\Microsoft\Windows\Explorer" -Filter "thumbcache_*.db"

Write-Log "[*] Cleaning CBS Logs..."
Clear-Folder -Label "CBS Logs" -Path "$env:windir\Logs\CBS"

Write-Log "[*] Cleaning Recycle Bin..."
if ($DryRun) {
    Write-Log " - [DRYRUN] Recycle Bin : Would be emptied" "Cyan"
} else {
    try {
        Clear-RecycleBin -Force -ErrorAction Stop
        Write-Log " - Recycle Bin : EMPTIED" "Green"
    } catch {
        Write-Log " - Recycle Bin : Already empty or error" "Yellow"
    }
}

Write-Log "[*] Flushing DNS Cache..."
if ($DryRun) {
    Write-Log " - [DRYRUN] DNS Cache : Would be flushed" "Cyan"
} else {
    Clear-DnsClientCache
    Write-Log " - DNS Cache : FLUSHED" "Green"
}

# ---------------------------------------------------------------------------
Write-Log ""
Write-Log "==========================================" "Cyan"
Write-Log "          ALL TASKS COMPLETED" "Cyan"
Write-Log "==========================================" "Cyan"

if ($DryRun) {
    Write-Log "Dry run complete. No files were deleted." "Yellow"
} else {
    Write-Log "Total space freed : $([math]::Round($TotalFreed / 1MB, 2)) MB" "Green"
}

Write-Log "Log saved to : $LogFile" "Gray"
Write-Log ""
Write-Log "  github.com/ExAzZe" "DarkGray"
Write-Log ""
Read-Host "Press Enter to exit"
