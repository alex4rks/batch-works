@echo off
:: Disable CMD UNC Check
setlocal enableextensions
Reg Query "HKLM\SOFTWARE\Microsoft\Command Processor" /v DisableUNCCheck 2>nul | findstr /c:"DisableUNCCheck    REG_DWORD    0x1" >nul
if not %errorlevel%==0 (echo +++UNC Support & Reg.exe add "HKLM\SOFTWARE\Microsoft\Command Processor" /v "DisableUNCCheck" /t REG_DWORD /d "1" /f >nul)

set INSTALLER=FSViewerSetup63.exe

:Install
:: taskkill.exe >nul 2>nul /f /t /im fsviwer.exe /im "%INSTALLER%"
echo Installing %installer%
"%~dp0%INSTALLER%" /S
if %errorlevel%==0 ( 
	echo SUCCESS : %installer% installed successfully
)

:Finish