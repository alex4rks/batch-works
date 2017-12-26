@echo off
:: Disable CMD UNC Check
setlocal enableextensions
Reg Query "HKLM\SOFTWARE\Microsoft\Command Processor" /v DisableUNCCheck 2>nul | findstr /c:"DisableUNCCheck    REG_DWORD    0x1" >nul
if not %errorlevel%==0 (echo +++UNC Support & Reg.exe add "HKLM\SOFTWARE\Microsoft\Command Processor" /v "DisableUNCCheck" /t REG_DWORD /d "1" /f >nul)

:: http://litemanager.ru
:: no changes
set INSTALLER_SERVER=LiteManager Pro - Server.msi
:: no changes
set INSTALLER_VIEWER=LiteManager Pro - Viewer.msi

:Uninstall
"%~dp0Uninstall_LM.exe" /server
"%~dp0Uninstall_LM.exe" /viewer

:Install
echo Installing %INSTALLER_SERVER%
msiexec.exe /I "%~dp0%INSTALLER_SERVER%" /QN
if %errorlevel%==0 ( 
	echo SUCCESS : %INSTALLER_SERVER% installed successfully
)

msiexec.exe /I "%~dp0%INSTALLER_VIEWER%" /QN
if %errorlevel%==0 ( 
	echo SUCCESS : %INSTALLER_VIEWER% installed successfully
)

del /Q "C:\Program Files (x86)\LiteManager Pro - Viewer\LMNoIpServer.exe"

:Config

:: set setings for blank server

:: import registry settings and restart service

:: apply settings
net stop ROMService
net start ROMService

:Finish