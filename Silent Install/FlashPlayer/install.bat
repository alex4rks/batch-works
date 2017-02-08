@echo off
:: Disable CMD UNC Check
setlocal enableextensions
Reg Query "HKLM\SOFTWARE\Microsoft\Command Processor" /v DisableUNCCheck 2>nul | findstr /c:"DisableUNCCheck    REG_DWORD    0x1" >nul
if not %errorlevel%==0 (echo +++UNC Support & Reg.exe add "HKLM\SOFTWARE\Microsoft\Command Processor" /v "DisableUNCCheck" /t REG_DWORD /d "1" /f >nul)

echo Installing Flash player Firefox, IE

:: https://chocolatey.org/packages/flashplayeractivex
:: for IE
for /R "%~dp0" %%i in ("*_active_x.msi") do set INSTALLER1=%%~nxi
:: for Firefox
for /R "%~dp0" %%i in ("*_plugin.msi") do set INSTALLER2=%%~nxi

set PROGRAM_NAME=Flash Player

:UnInstall
taskkill.exe       >nul 2>nul /F /T /IM "%INSTALLER1%" /IM "%INSTALLER2%" /IM "flashutil*" /IM "firefox.exe" /IM "iexplore.exe"
:: "%~dp0%INSTALLER1%">nul /uninstall
:: "%~dp0%INSTALLER2%">nul /uninstall
:: "%~dp0%INSTALLER3%">nul 2>nul /uninstall
:: if /I "%KEY%"=="-u" goto Finish

:Install
msiexec.exe /I "%~dp0%INSTALLER1%" /quiet /norestart REMOVE_PREVIOUS=YES
if %errorlevel%==0 ( echo SUCCESS : %installer1% installed successfully )
msiexec.exe /I "%~dp0%INSTALLER2%" /quiet /norestart REMOVE_PREVIOUS=YES
if %errorlevel%==0 ( echo SUCCESS : %installer2% installed successfully )
ping.exe           >nul 2>nul 127.0.0.1 -n 2
del                >nul 2>nul /A /F /Q "%SYSTEMROOT%\SYSTEM32\Macromed\Flash\*.exe"
reg.exe            >nul 2>nul delete "HKLM\SYSTEM\CurrentControlSet\Services\AdobeFlashPlayerUpdateSvc" /F
reg.exe            >nul 2>nul delete "HKCU\Software\Microsoft\Windows\CurrentVersion\RunOnce" /V "FlashPlayerUpdate" /F
schtasks.exe       >nul 2>nul /F /DELETE /TN "Adobe Flash Player Updater"
goto Finish

:Finish