@echo off
:: Disable CMD UNC Check
setlocal enableextensions
Reg Query "HKLM\SOFTWARE\Microsoft\Command Processor" /v DisableUNCCheck 2>nul | findstr /c:"DisableUNCCheck    REG_DWORD    0x1" >nul
if not %errorlevel%==0 (echo +++UNC Support & Reg.exe add "HKLM\SOFTWARE\Microsoft\Command Processor" /v "DisableUNCCheck" /t REG_DWORD /d "1" /f >nul)

set INSTALLER=%~dp0setup.exe

if /I "%~1"=="-u" goto Uninstall
if /I "%~1"=="/u" goto Uninstall
goto Install

:UnInstall
taskkill.exe      >nul 2>nul /F /T /IM "%INSTALLER%" /IM "excel.exe" /IM "groove.exe" /IM "infopath.exe" /IM "msaccess.exe" /IM "msosync.exe" /IM "msouc.exe" /IM "mspub.exe" /IM "mstore.exe" /IM "mstordb.exe" /IM "ois.exe" /IM "onenote.exe" /IM "onenotem.exe" /IM "osppsvc.exe" /IM "outlook.exe" /IM "powerpnt.exe" /IM "selfcert.exe" /IM "setlang.exe" /IM "visio.exe" /IM "winword.exe"
echo Uninstalling MS Office 2007 ProPlus
"%INSTALLER%" /uninstall "ProPlus" /config "%~dp0uninstall.xml"
if %errorlevel%==0 ( echo SUCCESS : MS office 2007 uninstalled successfully )
rmdir /S /Q C:\MSOCache
goto Finish

:Install
taskkill.exe      >nul 2>nul /F /T /IM "%INSTALLER%" /IM "excel.exe" /IM "groove.exe" /IM "infopath.exe" /IM "msaccess.exe" /IM "msosync.exe" /IM "msouc.exe" /IM "mspub.exe" /IM "mstore.exe" /IM "mstordb.exe" /IM "ois.exe" /IM "onenote.exe" /IM "onenotem.exe" /IM "osppsvc.exe" /IM "outlook.exe" /IM "powerpnt.exe" /IM "selfcert.exe" /IM "setlang.exe" /IM "visio.exe" /IM "winword.exe"
echo Installing Ms Office 2007 pro plus
"%INSTALLER%" /adminfile "%~dp0install.msp" /config "%~dp0install.xml"
if %errorlevel%==0 ( echo SUCCESS : MS office 2007 installed successfully )
net.exe           >nul 2>nul stop   "ose"
sc.exe            >nul 2>nul config "ose" start= disabled

:Finish