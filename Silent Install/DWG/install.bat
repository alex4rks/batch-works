@echo off
:: Disable CMD UNC Check
setlocal enableextensions
Reg Query "HKLM\SOFTWARE\Microsoft\Command Processor" /v DisableUNCCheck 2>nul | findstr /c:"DisableUNCCheck    REG_DWORD    0x1" >nul
if not %errorlevel%==0 (echo +++UNC Support & Reg.exe add "HKLM\SOFTWARE\Microsoft\Command Processor" /v "DisableUNCCheck" /t REG_DWORD /d "1" /f >nul)

set path_dotnet=%~dp0..\Dotnet4\install.bat

:: Install Requisites: Dotnet4
call %path_dotnet%
ping -n 4 127.0.0.1 >nul 2>nul

if defined ProgramFiles(x86) (
	set INSTALLER=2014-64bit
) else (
	set INSTALLER=2014-32bit
)

echo Installing DWG True View 2014
%~dp0%INSTALLER%\setup.exe /Q /W /I %~dp0%INSTALLER%\setup.ini
if %errorlevel%==0 ( echo SUCCESS : %installer% installed successfully )

:Finish