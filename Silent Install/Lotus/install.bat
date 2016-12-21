@echo off

:: Disable CMD UNC Check
setlocal enableextensions
Reg Query "HKLM\SOFTWARE\Microsoft\Command Processor" /v DisableUNCCheck 2>nul | findstr /c:"DisableUNCCheck    REG_DWORD    0x1" >nul
if not %errorlevel%==0 (echo +++UNC Support & Reg.exe add "HKLM\SOFTWARE\Microsoft\Command Processor" /v "DisableUNCCheck" /t REG_DWORD /d "1" /f >nul)

::https://blog.darrenduke.net/Darren/DDBZ.nsf/dx/use-a-custom-notes.ini-file-and-prepopulate-user-settings-on-notes-first-startup.htm
:: "C:\Program Files\IBM\Lotus\Notes\notes.exe"
set KEY=%~1

set PROGRAM_DIR=%ProgramFiles: (x86)=%
if defined ProgramW6432 set PROGRAM_DIR=%ProgramFiles(x86)%
set Notes_pdata=C:\ProgramData\Lotus\Notes\Data


:: Disable Remote differential connection
:: Dism /online /Disable-Feature /FeatureName:MSRDC-Infrastructure
:: Disable ipv6
:: reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters" /v "DisabledComponents" /t REG_DWORD /d "0xff" /f

taskkill >nul 2>nul /t /f /im "notes.exe" /im "notes2.exe"

echo Installing Lotus Notes 8.5.3
"%~dp0Lotus_notes853\setup.exe" /s /v"SETMULTIUSER=1 SELECTINSTALLFEATURES= /qn"
if %errorlevel%==0 ( echo SUCCESS : Lotus 8.5 installed successfully )
ping.exe    >nul 2>nul 127.0.0.1 -n 2

:Finish
