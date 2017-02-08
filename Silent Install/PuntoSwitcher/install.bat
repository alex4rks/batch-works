@echo off
:: Disable CMD UNC Check
setlocal enableextensions
Reg Query "HKLM\SOFTWARE\Microsoft\Command Processor" /v DisableUNCCheck 2>nul | findstr /c:"DisableUNCCheck    REG_DWORD    0x1" >nul
if not %errorlevel%==0 (echo +++UNC Support & Reg.exe add "HKLM\SOFTWARE\Microsoft\Command Processor" /v "DisableUNCCheck" /t REG_DWORD /d "1" /f >nul)


set INSTALLER=PuntoSwitcherSetup.exe

:Install
echo Installing PuntoSwitcher
"%~dp0%INSTALLER%" >nul /S
if %errorlevel%==0 ( echo SUCCESS : %installer% installed successfully )
:Finish
