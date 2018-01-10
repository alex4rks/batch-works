@echo off
:: Disable CMD UNC Check
setlocal enableextensions
Reg Query "HKLM\SOFTWARE\Microsoft\Command Processor" /v DisableUNCCheck 2>nul | findstr /c:"DisableUNCCheck    REG_DWORD    0x1" >nul
if %errorlevel%==0 (echo ...UNC is allowed) else (echo +++UNC Support added! & Reg.exe add "HKLM\SOFTWARE\Microsoft\Command Processor" /v "DisableUNCCheck" /t REG_DWORD /d "1" /f >nul)

set INSTALLER=%~dp0setup.exe
set UNINSTALLER={95140000-00AF-0409-0000-0000000FF1CE}

if /I "%~1"=="-u" goto Uninstall
if /I "%~1"=="/u" goto Uninstall
goto Install

:UnInstall
taskkill.exe      >nul 2>nul /F /T /IM "%INSTALLER%" /IM "excel.exe" /IM "groove.exe" /IM "infopath.exe" /IM "msaccess.exe" /IM "msosync.exe" /IM "msouc.exe" /IM "mspub.exe" /IM "mstore.exe" /IM "mstordb.exe" /IM "ois.exe" /IM "onenote.exe" /IM "onenotem.exe" /IM "osppsvc.exe" /IM "outlook.exe" /IM "powerpnt.exe" /IM "selfcert.exe" /IM "setlang.exe" /IM "visio.exe" /IM "winword.exe"
echo Uninstalling Office 2013 ProPlus with vbs...
cscript.exe       >nul "%~dp0OffScrub15.vbs" "ProPlus" /NoCancel /OSE /Quiet
echo Uninstalling MS Office 2010 PowerPoint Viewer, installed on systems with older office
msiexec.exe       /X "%UNINSTALLER%" /QN /NORESTART
"%INSTALLER%" /uninstall "ProPlus" /config "%~dp0uninstall.xml"
rmdir /S /Q C:\MSOCache
if %errorlevel%==0 ( echo SUCCESS : MS office 2013 ProPlus uninstalled successfully )
goto Finish

:Install
taskkill.exe      >nul 2>nul /F /T /IM "%INSTALLER%" /IM "excel.exe" /IM "groove.exe" /IM "infopath.exe" /IM "msaccess.exe" /IM "msosync.exe" /IM "msouc.exe" /IM "mspub.exe" /IM "mstore.exe" /IM "mstordb.exe" /IM "ois.exe" /IM "onenote.exe" /IM "onenotem.exe" /IM "osppsvc.exe" /IM "outlook.exe" /IM "powerpnt.exe" /IM "selfcert.exe" /IM "setlang.exe" /IM "visio.exe" /IM "winword.exe"
echo Installing MS Office 2013 pro plus...
"%INSTALLER%" 	  >nul /adminfile "%~dp0install.msp"
if %errorlevel%==0 ( echo SUCCESS : MS office 2013 ProPlus installed successfully )
net.exe           >nul 2>nul stop   "ose"
sc.exe            >nul 2>nul config "ose" start= disabled

:Finish