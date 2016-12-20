@echo off
:: Disable CMD UNC Check
setlocal enableextensions
Reg Query "HKLM\SOFTWARE\Microsoft\Command Processor" /v DisableUNCCheck 2>nul | findstr /c:"DisableUNCCheck    REG_DWORD    0x1" >nul
if not %errorlevel%==0 (echo +++UNC Support & Reg.exe add "HKLM\SOFTWARE\Microsoft\Command Processor" /v "DisableUNCCheck" /t REG_DWORD /d "1" /f >nul)

echo Installing Radmin
:: INSTALLER = installer for radmin server, custom package
set INSTALLER=radmin_server_custom.msi
set INSTALLER_viewer=radmin_viewer35ru.msi
set PROGRAM_DIR=%ProgramFiles: (x86)=%
if defined ProgramFiles(x86) set PROGRAM_DIR=%ProgramFiles(x86)%

msiexec.exe >nul /I "%~dp0%INSTALLER%" /QN /NORESTART
if %errorlevel%==0 ( echo SUCCESS : %installer% installed successfully )
msiexec.exe >nul /I "%~dp0%INSTALLER_viewer%" /QN /NORESTART
if %errorlevel%==0 ( echo SUCCESS : %installer_viewer% installed successfully )
ping 127.0.0.1 -n 8 >nul
call "%~dp0LicenseAddon\install_addon.bat"
if %errorlevel%==0 ( echo SUCCESS : License added )

:Finish