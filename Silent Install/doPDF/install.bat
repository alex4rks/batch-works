@echo off
:: Disable CMD UNC Check
setlocal enableextensions
Reg Query "HKLM\SOFTWARE\Microsoft\Command Processor" /v DisableUNCCheck 2>nul | findstr /c:"DisableUNCCheck    REG_DWORD    0x1" >nul
if not %errorlevel%==0 (echo +++UNC Support & Reg.exe add "HKLM\SOFTWARE\Microsoft\Command Processor" /v "DisableUNCCheck" /t REG_DWORD /d "1" /f >nul)

if exist "C:\Program Files\Softland\doPDF 7\dopdf.exe" (
	echo DoPDF is already installed
	goto finish
)


:: https://chocolatey.org/packages/doPDF

set INSTALLER=dopdf_7_3_400.exe

:Install
echo Installing DoPDF
"%~dp0%INSTALLER%" /VERYSILENT /SUPPRESSMSGBOXES /NORESTART
if %errorlevel%==0 ( echo SUCCESS : %installer% installed successfully )

:Finish
