@echo off
:: Disable CMD UNC Check
setlocal enableextensions
Reg Query "HKLM\SOFTWARE\Microsoft\Command Processor" /v DisableUNCCheck 2>nul | findstr /c:"DisableUNCCheck    REG_DWORD    0x1" >nul
if not %errorlevel%==0 (echo +++UNC Support & Reg.exe add "HKLM\SOFTWARE\Microsoft\Command Processor" /v "DisableUNCCheck" /t REG_DWORD /d "1" /f >nul)


:: set DRV_DIR=384.94-desktop-win10-64bit-international-whql

:: https://ss64.com/nt/for_d.html
pushd %~dp0
for /D %%i in ("Non-WHQL-Win10*") do set WIN10DIR=%%~nxi
for /D %%i in ("Non-WHQL-Win7*") do set WIN78DIR=%%~nxi


ver | find "10.0"
if %ERRORLEVEL% == 0 goto Win10_drv

:: 6.2, 6.3 - 8, 8.1
ver | find "6.1"
if %ERRORLEVEL% == 0 goto Win7_drv

echo ERROR:: unsupported OS!
exit /b 1

:Win10_drv
"%~dp0%WIN10DIR%\Setup.exe" -INSTALL
goto Finish

:Win7_drv
"%~dp0%WIN78DIR%\Setup.exe" -INSTALL
goto Finish

:Finish
echo Done!
popd