@echo off
:: Disable CMD UNC Check
setlocal enableextensions
Reg Query "HKLM\SOFTWARE\Microsoft\Command Processor" /v DisableUNCCheck 2>nul | findstr /c:"DisableUNCCheck    REG_DWORD    0x1" >nul
if not %errorlevel%==0 (echo +++UNC Support & Reg.exe add "HKLM\SOFTWARE\Microsoft\Command Processor" /v "DisableUNCCheck" /t REG_DWORD /d "1" /f >nul)

set PACKAGE=LibreOffice_523_x86.msi
set LibreOffice_pd=C:\ProgramData\LibreOffice
set INSTALLER=%LibreOffice_pd%\%package%

if not exist %LibreOffice_pd% mkdir %LibreOffice_pd%
if exist "%INSTALLER%" goto Install
echo Copying Libre Office 5 RUS to local disk
copy /Y "%~dp0%PACKAGE%" %LibreOffice_pd% >nul

ping -n 4 127.0.0.1 >nul 2>nul

if not exist %INSTALLER% (
	echo ERROR :: package wasn't found! ((
	goto Finish
)

:Install
taskkill.exe >nul 2>nul /f /t /im soffice.exe /im soffice.bin /im "%INSTALLER%"
echo Installing Libre Office 5 RUS from local disk
msiexec.exe /I "%INSTALLER%" /QB-! ADDLOCAL=ALL CREATEDESKTOPLINK=1 REGISTER_ALL_MSO_TYPES=1 REMOVE=gm_o_Onlineupdate RebootYesNo=No
if %errorlevel%==0 ( 
	echo SUCCESS : %installer% installed successfully 
	rmdir /S /Q %LibreOffice_pd%
)

:Finish