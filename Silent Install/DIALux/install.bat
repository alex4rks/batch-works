@echo off
echo Installing Dialux 4.12!

:: Disable CMD UNC Check
setlocal enableextensions
Reg Query "HKLM\SOFTWARE\Microsoft\Command Processor" /v DisableUNCCheck 2>nul | findstr /c:"DisableUNCCheck    REG_DWORD    0x1" >nul
if %errorlevel%==0 (echo ...UNC is allowed) else (echo +++UNC Support added! & Reg.exe add "HKLM\SOFTWARE\Microsoft\Command Processor" /v "DisableUNCCheck" /t REG_DWORD /d "1" /f >nul)

"%~dp0setup.exe" /s:%~dp0config.ini