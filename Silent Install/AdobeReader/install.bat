@echo off
:: Disable CMD UNC Check
setlocal enableextensions
Reg Query "HKLM\SOFTWARE\Microsoft\Command Processor" /v DisableUNCCheck 2>nul | findstr /c:"DisableUNCCheck    REG_DWORD    0x1" >nul
if not %errorlevel%==0 (echo +++UNC Support & Reg.exe add "HKLM\SOFTWARE\Microsoft\Command Processor" /v "DisableUNCCheck" /t REG_DWORD /d "1" /f >nul)

set Version=15.007.20033
Reg Query "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\{AC76BA86-7AD7-1049-7B44-AC0F074E4100}" /v DisplayVersion 2>nul | findstr /c:"DisplayVersion    REG_SZ    %VERSION%" >nul
	if %errorlevel%==0 goto AlreadyInstalled
Reg Query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{AC76BA86-7AD7-1049-7B44-AC0F074E4100}" /v DisplayVersion 2>nul | findstr /c:"DisplayVersion    REG_SZ    %VERSION%" >nul
	if %errorlevel%==0 goto AlreadyInstalled


set PROGRAM_DIR=%ProgramFiles: (x86)=%
if defined ProgramFiles(x86) set PROGRAM_DIR=%ProgramFiles(x86)%

REM http://get.adobe.com/reader/otherversions/
for /R "%~dp0" %%i in ("AcroRdr*.exe") do set INSTALLER=%%~nxi
rem set INSTALLER=AcroRdrDC1500720033_ru_RU.exe
REM set     UPDATER1=AdbeRdrUpd11007.msp
REM set     UPDATER2=AdbeRdrSecUpd11008.msp
REM set     UPDATER3=AdbeRdrUpd11009_incr.msp

set PROGRAM_NAME=Acrobat Reader DC
set PROGRAM_EXEC=acrord32.exe

:UnInstall
taskkill.exe>nul 2>nul /F /T /IM "%INSTALLER%" /IM "%PROGRAM_EXEC%" /IM "adobearm.exe" /IM "armsvc.exe" /IM "firefox.exe"
ping.exe    >nul 2>nul 127.0.0.1 -n 6
call        >nul 2>nul :UnInstallByName "Adobe Reader"
reg.exe     >nul 2>nul delete "HKLM\SOFTWARE\Adobe\Adobe ARM" /F
reg.exe     >nul 2>nul delete "HKLM\SOFTWARE\Wow6432Node\Adobe\Adobe ARM" /F

if /I "%~1"=="-u" goto Finish
if /I "%~1"=="/u" goto Finish

:Install
echo Installing Adobe Reader DC..
"%~dp0%INSTALLER%" >nul /sAll /rs /msi /QN /NORESTART ALLUSERS=1 EULA_ACCEPT=YES SUPPRESS_APP_LAUNCH=YES DISABLE_ARM_SERVICE_INSTALL=1 UPDATE_MODE=0
if %errorlevel%==0 ( echo SUCCESS : %installer% installed successfully )
REM msiexec.exe       >nul 2>nul /UPDATE "%~dp0%UPDATER1%" /QN /NORESTART
REM msiexec.exe       >nul 2>nul /UPDATE "%~dp0%UPDATER2%" /QN /NORESTART
REM msiexec.exe       >nul 2>nul /UPDATE "%~dp0%UPDATER3%" /QN /NORESTART
net.exe           >nul 2>nul stop   "AdobeARMservice"
sc.exe            >nul 2>nul config "AdobeARMservice" start= disabled
rmdir             >nul 2>nul /S /Q "%ALLUSERSPROFILE%\Adobe\ARM"
rmdir             >nul 2>nul /S /Q "%COMMONPROGRAMFILES%\Adobe\ARM"
rmdir             >nul 2>nul /S /Q "%COMMONPROGRAMFILES%\Adobe\Updater6"
del               >nul 2>nul /A /F /Q "%ALLUSERSPROFILE%\Desktop\Adobe Reader*.lnk"
del               >nul 2>nul /A /F /Q "%ALLUSERSPROFILE%\Рабочий стол\Adobe Reader*.lnk"
del               >nul 2>nul /A /F /Q "%PUBLIC%\Desktop\Adobe Reader*.lnk"
reg.exe           >nul 2>nul delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"             /V "Adobe ARM" /F
reg.exe           >nul 2>nul delete "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Run" /V "Adobe ARM" /F
reg.exe           >nul 2>nul delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"             /V "Adobe Reader Speed Launcher" /F
reg.exe           >nul 2>nul delete "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Run" /V "Adobe Reader Speed Launcher" /F
reg.exe           >nul 2>nul add    "HKLM\SOFTWARE\Adobe\Adobe ARM\1.0\ARM"                          /V "iCheckReader" /T REG_DWORD /D "0" /F
reg.exe           >nul 2>nul add    "HKLM\SOFTWARE\Wow6432Node\Adobe\Adobe ARM\1.0\ARM"              /V "iCheckReader" /T REG_DWORD /D "0" /F

REM don't send telemetry
Reg.exe >nul 2>nul add "HKLM\SOFTWARE\Policies\Adobe\Acrobat Reader\DC\FeatureLockDown\cServices" /v "bToggleAdobeDocumentServices" /t REG_DWORD /d "1" /f
Reg.exe >nul 2>nul add "HKLM\SOFTWARE\Policies\Adobe\Acrobat Reader\DC\FeatureLockDown\cServices" /v "bToggleAdobeSign" /t REG_DWORD /d "1" /f
Reg.exe >nul 2>nul add "HKLM\SOFTWARE\Policies\Adobe\Acrobat Reader\DC\FeatureLockDown\cServices" /v "bTogglePrefSync" /t REG_DWORD /d "1" /f
Reg.exe >nul 2>nul add "HKLM\SOFTWARE\Policies\Adobe\Acrobat Reader\DC\FeatureLockDown\cServices" /v "bUpdater" /t REG_DWORD /d "0" /f

goto Finish

:UnInstallByName
setlocal EnableDelayedExpansion
set name=%~1
set name=%name:"=%
set key1=
for /F "tokens=1,2,*" %%i in ('reg.exe 2^>nul query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" /V "DisplayName" /S') do (
  set key2=%%~k
  set key2=!key2:"=!
  call :MatchStr "!key2!" "%name%" && call :UnInstallByName2 "!key1!"
  set key1=%%~i
  set key1=!key1:*Uninstall\=!
)
set key1=
for /F "tokens=1,2,*" %%i in ('reg.exe 2^>nul query "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" /V "DisplayName" /S') do (
  set key2=%%~k
  set key2=!key2:"=!
  call :MatchStr "!key2!" "%name%" && call :UnInstallByName2 "!key1!"
  set key1=%%~i
  set key1=!key1:*Uninstall\=!
)
set key1=
for /F "tokens=1,2,*" %%i in ('reg.exe 2^>nul query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Installer\UserData" /V "DisplayName" /S') do (
  set key2=%%~k
  set key2=!key2:"=!
  call :MatchStr "!key2!" "%name%" && reg.exe delete "!key1!" /F
  set key1=%%~i
  set key1=!key1:\InstallProperties=!
)
set key1=
for /F "tokens=1,2,*" %%i in ('reg.exe 2^>nul query "HKCR\Installer\Products" /V "ProductName" /S') do (
  set key2=%%~k
  set key2=!key2:"=!
  call :MatchStr "!key2!" "%name%" && reg.exe delete "!key1!" /F
  set key1=%%~i
)
endlocal
exit /B
:UnInstallByName2
if "%~1"=="" exit /B
msiexec.exe /X "%~1" /QN /NORESTART
reg.exe delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\%~1" /F
reg.exe delete "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\%~1" /F
exit /B

:MatchStr
if "%~1"=="" exit /B 1
if "%~2"=="" exit /B 1
setlocal
set str=%~1
call :MatchStr2 "%~1" "%%str:%~2=%%"
endlocal
exit /B
:MatchStr2
if "%~1"=="%~2" exit /B 1
exit /B 0

:AlreadyInstalled
echo Adobe Reader DC is already installed

:Finish