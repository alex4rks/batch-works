@echo off
:: Disable CMD UNC Check
setlocal enableextensions
Reg Query "HKLM\SOFTWARE\Microsoft\Command Processor" /v DisableUNCCheck 2>nul | findstr /c:"DisableUNCCheck    REG_DWORD    0x1" >nul
if not %errorlevel%==0 (echo +++UNC Support & Reg.exe add "HKLM\SOFTWARE\Microsoft\Command Processor" /v "DisableUNCCheck" /t REG_DWORD /d "1" /f >nul)

set PROGRAM_DIR=%ProgramFiles%

if defined ProgramFiles(x86) (
  for /R "%~dp0" %%i in ("far*x64*.msi") do set INSTALLER=%%~nxi
) else (
  for /R "%~dp0" %%i in ("far*x86*.msi") do set INSTALLER=%%~nxi
)

:UnInstall
msiexec.exe /X "%~dp0%INSTALLER%" /QN >nul

:Install
taskkill.exe>nul 2>nul /F /T /IM "far*"
echo Installing %INSTALLER%
msiexec.exe /I "%~dp0%INSTALLER%" /QN >nul
if %errorlevel%==0 ( echo SUCCESS : %installer% installed successfully )

:Finish
