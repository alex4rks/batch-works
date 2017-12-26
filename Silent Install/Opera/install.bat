@echo off
:: Disable CMD UNC Check
setlocal enableextensions
Reg Query "HKLM\SOFTWARE\Microsoft\Command Processor" /v DisableUNCCheck 2>nul | findstr /c:"DisableUNCCheck    REG_DWORD    0x1" >nul
if not %errorlevel%==0 (echo +++UNC Support & Reg.exe add "HKLM\SOFTWARE\Microsoft\Command Processor" /v "DisableUNCCheck" /t REG_DWORD /d "1" /f >nul)

:: no autoupdate x86 version
:: https://get.geo.opera.com/pub/opera/desktop/43.0.2442.1144/win/

for /R "%~dp0" %%i in ("Opera_*_Setup.exe") do set INSTALLER=%%~nxi
set KEY=%~1

:UnInstall
taskkill.exe>nul 2>nul /F /T /IM "%INSTALLER%" /IM "opera.exe" /IM "opera_plugin_wrapper.exe"
"%ProgramFiles%\Opera\launcher.exe" /SILENT /UNINSTALL
"%ProgramFiles(x86)%\Opera\launcher.exe" /SILENT /UNINSTALL

if /I "%KEY%"=="-u" goto Finish

:Install
ping 127.0.0.1 -n 7 >nul 2>nul
:: setx /M OPERA_AUTOUPDATE_DISABLED "wtf some text"
"%~dp0%INSTALLER%" /SILENT /ALLUSERS=YES /LAUNCHBROWSER=NO /SETDEFAULTBROWSER=YES /STARTMENUSHORTCUT=YES /DESKTOPSHORTCUT=NO /PINTOTASKBAR=YES /import-browser-data=NO /enable-stats=NO /enable-installer-stats=NO"

for /f "tokens=2 delims=\" %%x in ('schtasks /query /fo:list ^| find "Opera"') do schtasks /Change /TN "%%x" /Disable

:Finish