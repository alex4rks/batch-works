::@echo off
:: Disable CMD UNC Check
setlocal enableextensions
Reg Query "HKLM\SOFTWARE\Microsoft\Command Processor" /v DisableUNCCheck 2>nul | findstr /c:"DisableUNCCheck    REG_DWORD    0x1" >nul
if not %errorlevel%==0 (echo +++UNC Support & Reg.exe add "HKLM\SOFTWARE\Microsoft\Command Processor" /v "DisableUNCCheck" /t REG_DWORD /d "1" /f >nul)

set INSTALLER=openofficeorg341.msi

set PROGRAM_DIR=%ProgramFiles: (x86)=%
if defined ProgramFiles(x86) set PROGRAM_DIR=%ProgramFiles(x86)%


taskkill.exe >nul 2>nul /f /t /im soffice.exe /im soffice.bin /im "%INSTALLER%" /im "msiexec.exe" /im scalc.exe /im swriter.exe
:: /IM "firefox.exe" /IM "opera.exe" /IM "iexplore.exe"

echo uninstall
:: 3.4.1
msiexec.exe /qn /x {0E18CD78-6B42-4068-A51D-C5A85A9B32D2}
:: 4.1.2
msiexec.exe /qn /x {21B8775C-C570-4ED8-B53C-E5ADC872850A}

echo Installing Open Office 3.4.1
msiexec.exe /I "%~dp0%INSTALLER%" /QB-! SETUP_USED=1 RebootYesNo=No REGISTER_NO_MSO_TYPES=1 CREATEDESKTOPLINK=1 ADDLOCAL=ALL REMOVE=gm_o_Quickstart,gm_o_Onlineupdate
if %errorlevel%==0 ( echo SUCCESS : %installer% installed successfully )

:Finish