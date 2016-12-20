@echo off
:: Disable CMD UNC Check
setlocal enableextensions
Reg Query "HKLM\SOFTWARE\Microsoft\Command Processor" /v DisableUNCCheck 2>nul | findstr /c:"DisableUNCCheck    REG_DWORD    0x1" >nul
if not %errorlevel%==0 (echo +++UNC Support & Reg.exe add "HKLM\SOFTWARE\Microsoft\Command Processor" /v "DisableUNCCheck" /t REG_DWORD /d "1" /f >nul)

set PROGRAM_DIR=%ProgramFiles: (x86)=%
if defined ProgramW6432 set PROGRAM_DIR=%ProgramFiles(x86)%

:: http://download.qip.ru/2012/qip2012.exe
set INSTALLER=%~dp0qip2012.exe

set PROGRAM_DESC=QIP
set PROGRAM_NAME=QIP 2012
set PROGRAM_EXEC=qip.exe
set KEY=%~1

:UnInstall
taskkill.exe>nul 2>nul /F /T /IM "%INSTALLER%" /IM "%PROGRAM_EXEC%" /IM "qipguard*"
ping.exe    >nul 2>nul 127.0.0.1 -n 4
"%PROGRAM_DIR%\%PROGRAM_NAME%\unins000.exe">nul 2>nul /VERYSILENT
for /F "tokens=1,2,*" %%i in ('reg.exe 2^>nul query "HKU"') do (
  reg.exe   >nul 2>nul delete "%%~i\Software\Infium" /F
  reg.exe   >nul 2>nul delete "%%~i\Software\QIP"    /F
  reg.exe   >nul 2>nul delete "%%~i\Software\qip.ru" /F
)
call        >nul 2>nul :DelDirInAppData "QIP"
call        >nul 2>nul :DelDirInAppData "QipGuard"
call        >nul 2>nul :DelDirInProgs   "%PROGRAM_NAME%"
call        >nul 2>nul :DelShortcuts    "%PROGRAM_NAME%"
if /I "%KEY%"=="-u" goto Finish

:Install
echo Installing QIP 2012
"%INSTALLER%">nul /VERYSILENT /NOICONS /TASKS=""taskkill.exe>nul 2>nul /F /T /IM "qipguard*"
if %errorlevel%==0 ( echo SUCCESS : %installer% installed successfully )
ping.exe    >nul 2>nul 127.0.0.1 -n 2
call        >nul 2>nul :DelDirInAppData "QipGuard"
call        >nul 2>nul :DelDirInProgs "%PROGRAM_NAME%\Plugins"
for /F "tokens=1,2,*" %%i in ('reg.exe 2^>nul query "HKU"') do ^
reg.exe     >nul 2>nul delete "%%~i\Software\Microsoft\Windows\CurrentVersion\Uninstall\QipGuard" /F
wscript.exe >nul 2>nul "%~dp0shortcut.vbs" "%PROGRAM_DIR%\%PROGRAM_NAME%\%PROGRAM_EXEC%" "AllUsersPrograms" "%PROGRAM_NAME%" "%PROGRAM_DESC%"
wscript.exe >nul 2>nul "%~dp0shortcut.vbs" "%PROGRAM_DIR%\%PROGRAM_NAME%\%PROGRAM_EXEC%" "AllUsersDesktop"  "%PROGRAM_NAME%" "%PROGRAM_DESC%"
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
for /D %%i in ("%SYSTEMDRIVE%\Users" "%SYSTEMDRIVE%\Documents and Settings") do ^
for /D %%j in ("%%~i\All Users" "%%~i\Default" "%%~i\Public" "%%~i\Администратор" "%%~i\*.*") do (
  for /D %%k in ("%%~j\AppData\Local\VirtualStore\Program Files\%~1"      ) do call :DelDir "%%~k"
  for /D %%k in ("%%~j\AppData\Local\VirtualStore\Program Files (x86)\%~1") do call :DelDir "%%~k"
)
exit /B

:DelDirInAppData
if "%~1"=="" exit /B 1
for /D %%h in (C D) do if exist "%%~h:" ^
for /D %%i in ("%%~h:\Users" "%%~d:\Documents and Settings") do if exist "%%~i" ^
for /D %%j in ("%%~i\All Users" "%%~i\Default" "%%~i\Все пользователи" "%%~i\*.*") do if exist "%%~j" (
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
for /D %%i in ("%SYSTEMDRIVE%\Users" "D:\Users" "%SYSTEMDRIVE%\Documents and Settings") do ^
for /D %%j in ("%%~i\*.*" "%%~i\All Users" "%%~i\Default" "%%~i\Все пользователи") do (
  call :DelDir  "%%~j\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\%~1"
  call :DelDir  "%%~j\AppData\Roaming\Microsoft\Windows\Start Menu\%~1"
  call :DelDir  "%%~j\Microsoft\Windows\Start Menu\Programs\%~1"
  call :DelDir  "%%~j\Microsoft\Windows\Start Menu\%~1"
  call :DelDir  "%%~j\Главное меню\Программы\%~1"
  call :DelDir  "%%~j\Главное меню\%~1"
  call :DelFile "%%~j\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\%~1.lnk"
  call :DelFile "%%~j\AppData\Roaming\Microsoft\Windows\Start Menu\%~1.lnk"
  call :DelFile "%%~j\AppData\Roaming\Microsoft\Windows\Recent\%~1.lnk"
  call :DelFile "%%~j\Microsoft\Windows\Start Menu\Programs\%~1.lnk"
  call :DelFile "%%~j\Microsoft\Windows\Start Menu\%~1.lnk"
  call :DelFile "%%~j\Главное меню\Программы\%~1.lnk"
  call :DelFile "%%~j\Главное меню\%~1.lnk"
  call :DelFile "%%~j\Desktop\%~1.lnk"
  call :DelFile "%%~j\Рабочий стол\%~1.lnk"
  call :DelFile "%%~j\Application Data\Microsoft\Internet Explorer\Quick Launch\%~1.lnk"
  call :DelFile "%%~j\AppData\Roaming\Microsoft\Internet Explorer\Quick Launch\%~1.lnk"
  rem call :DelFile "%%~j\AppData\Roaming\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\%~1.lnk"
)
if defined ProgramData (
  call :DelDir  "%ProgramData%\Microsoft\Windows\Start Menu\Programs\%~1"
  call :DelDir  "%ProgramData%\Microsoft\Windows\Start Menu\%~1"
  call :DelFile "%ProgramData%\Microsoft\Windows\Start Menu\Programs\%~1.lnk"
  call :DelFile "%ProgramData%\Microsoft\Windows\Start Menu\%~1.lnk"
)
exit /B

:Finish