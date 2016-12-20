@echo on
:: PCL6 drivers October 2016 - v6.3
setlocal enableextensions
Reg Query "HKLM\SOFTWARE\Microsoft\Command Processor" /v DisableUNCCheck 2>nul | findstr /c:"DisableUNCCheck    REG_DWORD    0x1" >nul
if not %errorlevel%==0 (echo +++UNC Support added! & Reg.exe add "HKLM\SOFTWARE\Microsoft\Command Processor" /v "DisableUNCCheck" /t REG_DWORD /d "1" /f >nul)

set PRN_NAME=%~1
:: echo "%PRN_NAME%" | findstr /R "[0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][A-Z][A-Z][A-Z]"
echo %PRN_NAME% | findstr /R "[0][1][0-9][0-9]-[0][0-9][0-9][M,P][F,R][U,T]"
if not %errorlevel%==0 goto WrongName

set DEPT=%PRN_NAME:~2,2%
FOR /F "tokens=* delims=0" %%A IN ("%PRN_NAME:~5,3%") DO SET PRN_NUM=%%A

set PRN_IP=10.120.%DEPT%.%PRN_NUM%
:: exceptions for RC, OP3, OP9, LC, OP7
if %DEPT%==00 ( 
	set PRN_IP=172.20.3.%PRN_NUM% )
if %DEPT%==12 ( 
	set PRN_IP=172.20.3.%PRN_NUM% )
if %DEPT%==39 ( 
	set PRN_IP=172.20.3.%PRN_NUM% )
if %DEPT%==01 ( 
	set PRN_IP=172.30.2.%PRN_NUM% )
if %DEPT%==37 ( 
	set PRN_IP=172.30.2.%PRN_NUM% )
::echo name: %PRN_NAME% ip: %PRN_IP%
goto Install

:WrongName
echo Please write the correct name of the printer, for example: %0 0100-010MFU
exit /b 3

:Install	
echo Adding KX Printer
set PRINTER_NAME="Kyocera FS-1135MFP KX"
::set Print_n="0100-010MFU"
set Print_n=%PRN_NAME%
set IP=%PRN_IP%
set PORT=9100
set PAS_PATH="C:\Windows\System32\Printing_Admin_Scripts\ru-RU

echo PRINTER: %Print_n%  on IP: %IP%
REM default is 64 bit
set DRV_PATH=%~dp0KX_Universal\64bit\XP and newer
set INF_PATH=%~dp0KX_Universal\64bit\XP and newer\OEMSETUP.INF
set ARCH=x64
IF %PROCESSOR_ARCHITECTURE% == x86 (
  IF NOT DEFINED PROCESSOR_ARCHITEW6432 ( 
  set DRV_PATH=%~dp0KX_Universal\32bit\XP and newer
  set INF_PATH=%~dp0KX_Universal\32bit\XP and newer\OEMSETUP.INF
  set ARCH=x86
  )
)

cscript %PAS_PATH%\prnport.vbs" -a -r "IP_%IP%" -h %IP% -o raw -n %PORT%
	if %errorlevel%==0 ( echo Port %PORT% added successfully )
cscript %PAS_PATH%\prndrvr.vbs" -a -m %PRINTER_NAME% -e "%ARCH%" -h "%DRV_PATH%" -i "%INF_PATH%"
	if %errorlevel%==0 ( echo Driver "%INF_PATH%" installed successfully )
cscript %PAS_PATH%\prnmngr.vbs" -a -p %PRINT_N% -m %PRINTER_NAME% -r "IP_%IP%"
	if %errorlevel%==0 ( echo Printer %PRINT_N% installed successfully )
:: make default
cscript %PAS_PATH%\prnmngr.vbs" -t -p %PRINT_N% >nul

:finish