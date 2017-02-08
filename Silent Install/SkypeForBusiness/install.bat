@echo off
:: Disable CMD UNC Check
setlocal enableextensions
Reg Query "HKLM\SOFTWARE\Microsoft\Command Processor" /v DisableUNCCheck 2>nul | findstr /c:"DisableUNCCheck    REG_DWORD    0x1" >nul
if not %errorlevel%==0 (echo +++UNC Support & Reg.exe add "HKLM\SOFTWARE\Microsoft\Command Processor" /v "DisableUNCCheck" /t REG_DWORD /d "1" /f >nul)

:: https://blog.it-kb.ru/2014/09/24/preparation-distribution-microsoft-lync-2013-sp1-to-automatic-silent-installation-deployment-with-sccm-or-gpo/

:: Skype for Business Basic Client 2016 x32
set    INSTALLER=setup.exe
set     UPDATE1=updates\lync_nov2016.msp
:: Microsoft Skype for Business MUI (Russian) 2016
:: set UNINSTALLER1={90160000-012B-0419-0000-0000000FF1CE}

set KEY=%~1
if /I "%KEY%"=="-u" goto Uninstall
if /I "%KEY%"=="/u" goto Uninstall

:UnInstall
taskkill.exe      >nul 2>nul /F /T /IM "%INSTALLER%" /IM "lync.exe" /IM "ocpubmgr.exe" /IM "setlang.exe"
cscript.exe "%~dp0OffScrub16.vbs" "LYNC" /NoCancel /OSE /Quiet
"%~dp0%INSTALLER%">nul 2>nul /uninstall "LYNC" /config "%~dp0uninstall.xml"
if /I "%KEY%"=="-u" goto Finish
if /I "%KEY%"=="/u" goto Finish

:Install
taskkill.exe      >nul 2>nul /F /T /IM "%INSTALLER%" /IM "lync.exe" /IM "ocpubmgr.exe" /IM "setlang.exe"
"%~dp0%INSTALLER%">nul 2>nul /adminfile "%~dp0install.msp"
:: install updates
msiexec.exe /UPDATE "%~dp0%UPDATE1%" /QN /NORESTART
goto Finish

:Finish
