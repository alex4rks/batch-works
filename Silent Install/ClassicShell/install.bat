@echo off
:: Disable CMD UNC Check
setlocal enableextensions
Reg Query "HKLM\SOFTWARE\Microsoft\Command Processor" /v DisableUNCCheck 2>nul | findstr /c:"DisableUNCCheck    REG_DWORD    0x1" >nul
if not %errorlevel%==0 (echo +++UNC Support & Reg.exe add "HKLM\SOFTWARE\Microsoft\Command Processor" /v "DisableUNCCheck" /t REG_DWORD /d "1" /f >nul)

if defined ProgramFiles(x86) set PROGRAM_DIR=%ProgramFiles(x86)%

:: http://www.classicshell.net/
set   INSTALLER=ClassicShellSetup_4_3_0.exe
set UNINSTALLER={417502AF-ABF9-457B-AE32-940BEA8F4627}

set PROGRAM_NAME=Classic Shell

set KEY=%~1
if defined SFXCMD set SFXCMD=%SFXCMD:*.exe=%
if defined SFXCMD set SFXCMD=%SFXCMD:"=%
if defined SFXCMD set    KEY=%SFXCMD: =%
if defined KEY    set    KEY=%KEY:/=-%

if /I "%KEY%"=="-sfx" goto MakeSFX

:UnInstall
taskkill.exe>nul 2>nul /F /T /IM "%INSTALLER%" /IM "classicstartmenu.exe"
msiexec.exe >nul 2>nul /X "%UNINSTALLER%" /QN /NORESTART
call        >nul 2>nul :DelDirInProgs "Classic Shell"
for /F "tokens=1,2,*" %%i in ('reg.exe 2^>nul query "HKU"') do ^
reg.exe     >nul 2>nul delete "%%~i\Software\IvoSoft" /F
reg.exe     >nul 2>nul delete "HKLM\Software\IvoSoft" /F
if /I "%KEY%"=="-u" goto Finish

:Install
for /F "tokens=1,2,*" %%i in ('reg.exe 2^>nul query "HKU"') do (
  reg.exe   >nul 2>nul add "%%~i\Software\IvoSoft\ClassicStartMenu"          /V "ShowedStyle2"    /T REG_DWORD  /D "1" /F
  reg.exe   >nul 2>nul add "%%~i\Software\IvoSoft\ClassicStartMenu"          /V "CSettingsDlg"    /T REG_BINARY /D "ae0000005b0000000000000000000000900c000001000000" /F
  reg.exe   >nul 2>nul add "%%~i\Software\IvoSoft\ClassicStartMenu\Settings" /V "SkipMetro"       /T REG_DWORD  /D "1" /F
  reg.exe   >nul 2>nul add "%%~i\Software\IvoSoft\ClassicStartMenu\Settings" /V "SkinW7"          /T REG_SZ     /D "Windows Aero" /F
  reg.exe   >nul 2>nul add "%%~i\Software\IvoSoft\ClassicStartMenu\Settings" /V "SkinVariationW7" /T REG_SZ     /D "" /F
  reg.exe   >nul 2>nul add "%%~i\Software\IvoSoft\ClassicStartMenu\Settings" /V "SkinOptionsW7"   /T REG_SZ     /D "C26EAF5C|5D3248DC|1FC64124|5EA361A2|0663DC39|" /F
)
"%~dp0%INSTALLER%">nul 2>nul /QN ADDLOCAL=ClassicStartMenu
call        >nul 2>nul :DelShortcuts "%PROGRAM_NAME%"
goto Finish

:ExistFile
if "%~1"=="" exit /B 255
dir>nul 2>nul /A:-D "%~1" || exit /B 1
exit /B 0

:ExistDir
if "%~1"=="" exit /B 255
dir>nul 2>nul /A:D "%~1" || exit /B 1
exit /B 0

:DelFile
call>nul 2>nul :ExistFile "%~1" || exit /B
setlocal
cd /D "%~dp1"
set myname=%~1
:DelFile_Loop
if not defined myname exit /B
if "%myname%"=="%myname:*\=%" goto DelFile_Skip
set myname=%myname:*\=%
goto DelFile_Loop
:DelFile_Skip
forfiles.exe 2>nul /C "%COMSPEC% /C if @isdir==FALSE ( del /A /F /Q @path )" /M "%myname%" || del /A /F /Q "%~1"
endlocal
exit /B

:DelDir
call>nul 2>nul :ExistDir "%~1" || exit /B
setlocal
cd /D "%~dp1"
set myname=%~1
:DelDir_Loop
if not defined myname exit /B
if "%myname%"=="%myname:*\=%" goto DelDir_Skip
set myname=%myname:*\=%
goto DelDir_Loop
:DelDir_Skip
forfiles.exe 2>nul /C "%COMSPEC% /C if @isdir==TRUE ( rmdir /S /Q @path )" /M "%myname%" || rmdir /S /Q "%~1"
endlocal
exit /B

:DelDirInProgs
if "%~1"=="" exit /B 1
if defined ProgramFiles      call :DelDir "%ProgramFiles: (x86)=%\%~1"
if defined ProgramFiles(x86) call :DelDir "%ProgramFiles(x86)%\%~1"
for /D %%i in ("%SYSTEMDRIVE%\Users") do ^
for /D %%j in ("%%~i\All Users" "%%~i\Default" "%%~i\Public" "%%~i\*.*") do (
  for /D %%k in ("%%~j\AppData\Local\VirtualStore\Program Files\%~1"      ) do call :DelDir "%%~k"
  for /D %%k in ("%%~j\AppData\Local\VirtualStore\Program Files (x86)\%~1") do call :DelDir "%%~k"
)
exit /B

:DelDirInAppData
if "%~1"=="" exit /B 1
for /D %%h in (C D) do if exist "%%~h:" ^
for /D %%i in ("%%~h:\Users" "%%~d:\Documents and Settings") do if exist "%%~i" ^
for /D %%j in ("%%~i\All Users" "%%~i\Default" "%%~i\*.*") do if exist "%%~j" (
  for /D %%k in ("%%~j\AppData\Local\%~1"                             ) do call :DelDir "%%~k"
  for /D %%k in ("%%~j\AppData\Local\VirtualStore\Windows\AppData\%~1") do call :DelDir "%%~k"
  for /D %%k in ("%%~j\AppData\LocalLow\%~1"                          ) do call :DelDir "%%~k"
  for /D %%k in ("%%~j\AppData\Roaming\%~1"                           ) do call :DelDir "%%~k"
  for /D %%k in ("%%~j\Application Data\%~1"                          ) do call :DelDir "%%~k"
  for /D %%k in ("%%~j\Local Settings\%~1"                            ) do call :DelDir "%%~k"
  for /D %%k in ("%%~j\Local Settings\Application Data\%~1"           ) do call :DelDir "%%~k"
)
if defined ProgramData for /D %%i in ("%PROGRAMDATA%\%~1"       ) do call :DelDir "%%~i"
if defined SystemRoot  for /D %%i in ("%SYSTEMROOT%\AppData\%~1") do call :DelDir "%%~i"
exit /B

:DelShortcuts
if "%~1"=="" exit /B 1
for /D %%i in ("%SYSTEMDRIVE%\Users") do ^
for /D %%j in ("%%~i\*.*" "%%~i\All Users" "%%~i\Default") do (
  call :DelDir  "%%~j\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\%~1"
  call :DelDir  "%%~j\AppData\Roaming\Microsoft\Windows\Start Menu\%~1"
  call :DelDir  "%%~j\Microsoft\Windows\Start Menu\Programs\%~1"
  call :DelDir  "%%~j\Microsoft\Windows\Start Menu\%~1"
  call :DelFile "%%~j\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\%~1.lnk"
  call :DelFile "%%~j\AppData\Roaming\Microsoft\Windows\Start Menu\%~1.lnk"
  call :DelFile "%%~j\AppData\Roaming\Microsoft\Windows\Recent\%~1.lnk"
  call :DelFile "%%~j\Microsoft\Windows\Start Menu\Programs\%~1.lnk"
  call :DelFile "%%~j\Microsoft\Windows\Start Menu\%~1.lnk"
  call :DelFile "%%~j\Desktop\%~1.lnk"
)
if defined ProgramData (
  call :DelDir  "%ProgramData%\Microsoft\Windows\Start Menu\Programs\%~1"
  call :DelDir  "%ProgramData%\Microsoft\Windows\Start Menu\%~1"
  call :DelFile "%ProgramData%\Microsoft\Windows\Start Menu\Programs\%~1.lnk"
  call :DelFile "%ProgramData%\Microsoft\Windows\Start Menu\%~1.lnk"
)
exit /B

:Finish
