@echo off
:: Disable CMD UNC Check
setlocal enableextensions
Reg Query "HKLM\SOFTWARE\Microsoft\Command Processor" /v DisableUNCCheck 2>nul | findstr /c:"DisableUNCCheck    REG_DWORD    0x1" >nul
if not %errorlevel%==0 (echo +++UNC Support & Reg.exe add "HKLM\SOFTWARE\Microsoft\Command Processor" /v "DisableUNCCheck" /t REG_DWORD /d "1" /f >nul)

set PROGRAM_DIR=%ProgramFiles%

if defined ProgramFiles(x86) (
  for /R "%~dp0" %%i in ("winrar-x64*.exe") do set INSTALLER=%%~nxi
) else (
  for /R "%~dp0" %%i in ("winrar-x86*.exe") do set INSTALLER=%%~nxi
)

:UnInstall
rem "%PROGRAM_DIR%\%PROGRAM_NAME%\uninstall.exe" /s >nul 2>nul

:Install
taskkill.exe>nul 2>nul /F /T /IM "winrar*"
echo Installing WinRAR
"%~dp0%INSTALLER%" >nul /s
if %errorlevel%==0 ( echo SUCCESS : %installer% installed successfully )
copy /Y "%~dp0rarreg.key" "%PROGRAM_DIR%\WinRAR\rarreg.key" >nul

:Finish