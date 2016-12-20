@echo off
:: Disable CMD UNC Check
setlocal enableextensions
Reg Query "HKLM\SOFTWARE\Microsoft\Command Processor" /v DisableUNCCheck 2>nul | findstr /c:"DisableUNCCheck    REG_DWORD    0x1" >nul
if not %errorlevel%==0 (echo +++UNC Support & Reg.exe add "HKLM\SOFTWARE\Microsoft\Command Processor" /v "DisableUNCCheck" /t REG_DWORD /d "1" /f >nul)

:: Check if it already installed
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\full" /v version 2>nul | findstr /R /C:"version    REG_SZ    4.[6-7]*" >nul
if %errorlevel%==0 (
	echo DOTNET 4.6 IS ALREADY INSTALLED
	goto Finish
)
set PACKAGE=NDP462-KB3120735-x86-x64-AllOS-ENU.exe
set UNINSTALLER=Setup.exe
set INSTALLER=C:\ProgramData\%package%

if exist "%INSTALLER%" goto UnInstall
echo Copying %PACKAGE% to local disk
copy /Y "%~dp0%PACKAGE%" C:\ProgramData >nul

ping -n 2 127.0.0.1 >nul 2>nul

if not exist %INSTALLER% (
	echo ERROR :: package wasn't found! ((
	goto Finish
)


:UnInstall
taskkill.exe      >nul 2>nul /F /T /IM "%INSTALLER%" /IM "%UNINSTALLER%"

:Install
echo Installing %PACKAGE%!
"%INSTALLER%" /q /NoRestart
if %errorlevel%==0 ( echo SUCCESS : %installer% installed successfully && echo . )

:DeleteInstaller
ping -n 2 127.0.0.1 >nul 2>nul
del /F /Q C:\ProgramData\%PACKAGE%

:Finish