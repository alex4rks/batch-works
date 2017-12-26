@echo off
:: Disable CMD UNC Check
setlocal enableextensions
Reg Query "HKLM\SOFTWARE\Microsoft\Command Processor" /v DisableUNCCheck 2>nul | findstr /c:"DisableUNCCheck    REG_DWORD    0x1" >nul
if not %errorlevel%==0 (echo +++UNC Support & Reg.exe add "HKLM\SOFTWARE\Microsoft\Command Processor" /v "DisableUNCCheck" /t REG_DWORD /d "1" /f >nul)


:: set DRV_DIR=384.94-desktop-win10-64bit-international-whql

:: https://ss64.com/nt/for_d.html
pushd %~dp0
for /D %%i in ("*win10*") do set WIN10DIR=%%~nxi
for /D %%i in ("*win7*") do set WIN78DIR=%%~nxi


ver | find "10.0"
if %ERRORLEVEL% == 0 goto Win10_drv

:: 6.1, 6.2, 6.3
ver | find "6."
if %ERRORLEVEL% == 0 goto Win7_8_drv

echo ERROR:: unsupported OS!
exit /b 1

:Win10_drv
"%~dp0%WIN10DIR%\setup.exe" -noreboot -passive -noeula -nofinish 
:: -gfexperienceinitiated
:: -clean
goto Finish

:Win7_8_drv
"%~dp0%WIN78DIR%\setup.exe" -noreboot -passive -noeula -nofinish
goto Finish

:Finish
:: disable telemetry
for /f "tokens=2 delims=\" %%x in ('schtasks /query /fo:list ^| find "NvTm"') do schtasks /Change /TN "%%x" /Disable
for /f "tokens=2 delims=\" %%x in ('schtasks /query /fo:list ^| find "NvDriverUpdateCheckDaily"') do schtasks /Change /TN "%%x" /Disable
for /f "tokens=2 delims=\" %%x in ('schtasks /query /fo:list ^| find "NVIDIA GeForce Experience SelfUpdate"') do schtasks /Change /TN "%%x" /Disable





echo Done!
popd