@echo off
:: Disable CMD UNC Check
setlocal enableextensions
Reg Query "HKLM\SOFTWARE\Microsoft\Command Processor" /v DisableUNCCheck 2>nul | findstr /c:"DisableUNCCheck    REG_DWORD    0x1" >nul
if not %errorlevel%==0 (echo +++UNC Support & Reg.exe add "HKLM\SOFTWARE\Microsoft\Command Processor" /v "DisableUNCCheck" /t REG_DWORD /d "1" /f >nul)

:: place package *.cab in current directory
:: get it from installation media
set PACKAGE=Microsoft-Windows-NetFx3-OnDemand-Package.cab
set UNINSTALLER=Setup.exe
set INSTALLER=%~dp0%package%

reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\NET Framework Setup\NDP\v3.5" /v Install 2>nul | findstr /R /C:"Install    REG_DWORD    0x1" >nul
if %errorlevel%==0 (
	echo DOTNET 3.5 IS ALREADY INSTALLED
	goto Finish )

:Install
echo Installing %PACKAGE%!
Dism.exe /Online /LogLevel:4 /Add-Package /PackagePath:%INSTALLER% /NoRestart /Quiet
if %errorlevel%==0 ( echo SUCCESS : %installer% installed successfully && echo . )
if NOT %errorlevel%==0 ( echo ERROR : %installer% installed successfully && exit /b 1 )

:Finish