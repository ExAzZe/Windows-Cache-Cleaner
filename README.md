# Windows Cache Cleaner

Hey there! Welcome to my Windows Cache Cleaner repository.
This script started as a simple batch file and has since been rewritten in PowerShell to be more reliable, more detailed, and more useful in professional environments. It automatically requests Administrator rights, cleans system junk, logs everything it does, and even supports a dry run mode so you can see what would be deleted before committing.

## What does it clean?

| Target | Path |
|---|---|
| User Temp | `%TEMP%` |
| Windows Temp | `%windir%\Temp` |
| Prefetch | `%windir%\Prefetch` |
| Windows Update Cache | `%windir%\SoftwareDistribution\Download` |
| Thumbnail Cache | `%LOCALAPPDATA%\Microsoft\Windows\Explorer\thumbcache_*.db` |
| CBS Logs | `%windir%\Logs\CBS` |
| Recycle Bin | All drives |
| DNS Cache | Flushed via `Clear-DnsClientCache` |

### Why these folders?

- **User Temp & Windows Temp** — Applications dump temporary files here and rarely clean up after themselves. Safe to wipe entirely.
- **Prefetch** — Windows stores launch data here to speed up applications. Over time it accumulates traces of uninstalled or rarely used apps. Clearing it gives the folder a fresh start; Windows rebuilds it automatically on next launches.
- **Windows Update Cache** — Installation files left over after updates are applied. They serve no purpose once the update is installed.
- **Thumbnail Cache** — Windows stores image previews here. It rebuilds itself automatically, so clearing it is always safe.
- **CBS Logs** — Windows Update and component servicing logs. They can grow to several hundred MB over time.
- **Recycle Bin** — Often overlooked, can hold gigabytes of forgotten files.
- **DNS Cache** — Clears outdated DNS records, useful for resolving network glitches.

## How to use it

### Simple (recommended)

1. Download both `WindowsCacheCleaner.ps1` and `Start.bat`
2. Keep them in the same folder
3. Double-click `Start.bat`
4. Accept the UAC prompt (Administrator rights are required to access system folders)
5. Press Enter when done

### Dry Run mode

Want to see what would be deleted without actually deleting anything?

Via the launcher:

    Start.bat -DryRun

Or directly in an elevated PowerShell session:

    .\WindowsCacheCleaner.ps1 -DryRun

### Direct PowerShell

If you already have an elevated PowerShell session:

    .\WindowsCacheCleaner.ps1

## Logs

Every run automatically generates a timestamped log file in a `Logs\` folder next to the script:

    Logs\CacheCleaner_2026-05-06_15-45-35.log

Useful if you want to keep track of how much space was freed over time or deploy the script across multiple machines.

---

*Note: Files locked by Windows at the time of execution will be silently skipped. This is normal and safe.*

*Made by [ExAzZe](https://github.com/ExAzZe)*
