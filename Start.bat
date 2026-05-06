@echo off
cd /d "%~dp0"

net session >nul 2>&1
if %errorLevel% == 0 goto :run

powershell -Command "Start-Process '%~f0' -ArgumentList '%*' -Verb RunAs"
exit

:run
PowerShell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0WindowsCacheCleaner.ps1" %*
