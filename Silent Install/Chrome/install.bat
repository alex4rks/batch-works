@echo off
:: Disable CMD UNC Check
setlocal enableextensions
Reg Query "HKLM\SOFTWARE\Microsoft\Command Processor" /v DisableUNCCheck 2>nul | findstr /c:"DisableUNCCheck    REG_DWORD    0x1" >nul
if %errorlevel%==0 (echo ...UNC is allowed) else (echo +++UNC Support added! & Reg.exe add "HKLM\SOFTWARE\Microsoft\Command Processor" /v "DisableUNCCheck" /t REG_DWORD /d "1" /f >nul)

echo Installing Google Chrome !
set PROGRAM_DIR=%ProgramFiles: (x86)=%
if defined ProgramFiles(x86) set PROGRAM_DIR=%ProgramFiles(x86)%
if defined ProgramFiles(x86) set WOW6432NODE=Wow6432Node\

:: https://www.google.ru/chrome/business/browser/admin/index.html
set INSTALLER=GoogleChromeStandaloneEnterprise.msi

set PROGRAM_DESC=Browser
set PROGRAM_NAME=Google Chrome
set PROGRAM_EXEC=chrome.exe
set KEY=%~1

:UnInstall
taskkill.exe>nul 2>nul /F /T /IM "%PROGRAM_EXEC%" /IM "googleupdate.exe" /IM "googletoolbar*"
ping.exe    >nul 2>nul 127.0.0.1 -n 4
:: msiexec.exe >nul 2>nul /X "%~dp0%INSTALLER%" /QN /NORESTART
if /I "%KEY%"=="-u" goto Finish

:Install
msiexec.exe /I "%~dp0%INSTALLER%" /QN /NORESTART ALLUSERS=1

rem copy master_pref
xcopy.exe /C /H /I /R /S /Y /Z "%~dp0master_preferences" "%PROGRAM_DIR%\Google\Chrome\Application\"

goto Finish


:Finish
