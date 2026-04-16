@echo off
title Windows Cache Cleaner

net session >nul 2>&1
if %errorLevel% == 0 (
    goto :run
) else (
    powershell -Command "Start-Process '%~dpnx0' -Verb RunAs"
    exit
)

:run
cls
echo ==========================================
echo          WINDOWS CACHE CLEANER
echo ==========================================
echo.

echo [*] Cleaning User Temp folder...
set "count=0"
for /f %%A in ('dir /s /b /a-d "%temp%\*.*" 2^>nul ^| find /c /v ""') do set "count=%%A"
del /s /f /q %temp%\*.* >nul 2>&1
for /d %%p in ("%temp%\*") do rmdir "%%p" /s /q >nul 2>&1
echo  - User Temp: CLEAN (Processed %count% files)
echo.

echo [*] Cleaning Windows Temp folder...
set "count=0"
for /f %%A in ('dir /s /b /a-d "%windir%\temp\*.*" 2^>nul ^| find /c /v ""') do set "count=%%A"
del /s /f /q %windir%\temp\*.* >nul 2>&1
for /d %%p in ("%windir%\temp\*") do rmdir "%%p" /s /q >nul 2>&1
echo  - Windows Temp: CLEAN (Processed %count% files)
echo.

echo [*] Cleaning Prefetch folder...
set "count=0"
for /f %%A in ('dir /s /b /a-d "%windir%\Prefetch\*.*" 2^>nul ^| find /c /v ""') do set "count=%%A"
del /s /f /q %windir%\Prefetch\*.* >nul 2>&1
echo  - Prefetch: CLEAN (Processed %count% files)
echo.

echo [*] Cleaning Windows Update Cache...
set "count=0"
for /f %%A in ('dir /s /b /a-d "%windir%\SoftwareDistribution\Download\*.*" 2^>nul ^| find /c /v ""') do set "count=%%A"
del /s /f /q %windir%\SoftwareDistribution\Download\*.* >nul 2>&1
for /d %%p in ("%windir%\SoftwareDistribution\Download\*") do rmdir "%%p" /s /q >nul 2>&1
echo  - Update Cache: CLEAN (Processed %count% files)
echo.

echo [*] Flushing DNS Resolver Cache...
ipconfig /flushdns >nul 2>&1
echo  - DNS Cache: FLUSHED
echo.

echo ==========================================
echo          ALL TASKS COMPLETED
echo ==========================================
echo Note: Some files in use by Windows were skipped to prevent crashes.
echo.
echo Press any key to exit...
pause >nul
exit