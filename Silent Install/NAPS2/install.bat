@echo off
set PROGRAM_DIR=%ProgramFiles: (x86)=%
if defined ProgramFiles(x86) set PROGRAM_DIR=%ProgramFiles(x86)%

:: http://www.naps2.com/
set PROGRAM_DESC=Scan docs
set PROGRAM_NAME=NAPS2
set PROGRAM_EXEC=naps2.exe

set KEY=%~1
if defined SFXCMD set SFXCMD=%SFXCMD:*.exe=%
if defined SFXCMD set SFXCMD=%SFXCMD:"=%
if defined SFXCMD set    KEY=%SFXCMD: =%
if defined KEY    set    KEY=%KEY:/=-%

:UnInstall
taskkill.exe>nul 2>nul /F /T /IM "naps2.exe" /IM "naps2.console.exe"
"%PROGRAM_DIR%\NAPS2\unins000.exe">nul 2>nul /VERYSILENT /NORESTART
call        >nul 2>nul :DelDirInProgs   "NAPS2"
call        >nul 2>nul :DelDirInAppData "NAPS2"
call        >nul 2>nul :DelShortcuts    "NAPS2"
if /I "%KEY%"=="-u" goto Finish

:Install
xcopy.exe   >nul 2>nul /C /H /I /R /S /Y /Z "%~dp0Files"    "%PROGRAM_DIR%\NAPS2\"
call        >nul 2>nul :CopyFilesInAppData  "%~dp0Settings" "%PROGRAM_NAME%"
wscript.exe >nul 2>nul "%~dp0shortcut.vbs" "%PROGRAM_DIR%\%PROGRAM_NAME%\%PROGRAM_EXEC%" "AllUsersPrograms" "%PROGRAM_NAME%" "%PROGRAM_DESC%"
wscript.exe >nul 2>nul "%~dp0shortcut.vbs" "%PROGRAM_DIR%\%PROGRAM_NAME%\%PROGRAM_EXEC%" "AllUsersDesktop"  "%PROGRAM_NAME%" "%PROGRAM_DESC%"
if not exist C:\scan ( mkdir C:\scan )
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
for /D %%j in ("%%~i\All Users" "%%~i\Default" "%%~i\Public" "%%~i\*.*") do (
  for /D %%k in ("%%~j\AppData\Local\VirtualStore\Program Files\%~1"      ) do call :DelDir "%%~k"
  for /D %%k in ("%%~j\AppData\Local\VirtualStore\Program Files (x86)\%~1") do call :DelDir "%%~k"
)
exit /B

:DelDirInAppData
if "%~1"=="" exit /B 1
for /D %%h in (C D) do if exist "%%~h:" ^
for /D %%i in ("%%~h:\Users") do if exist "%%~i" ^
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
  call :DelFile "%%~j\Application Data\Microsoft\Internet Explorer\Quick Launch\%~1.lnk"
  call :DelFile "%%~j\AppData\Roaming\Microsoft\Internet Explorer\Quick Launch\%~1.lnk"
)
if defined ProgramData (
  call :DelDir  "%ProgramData%\Microsoft\Windows\Start Menu\Programs\%~1"
  call :DelDir  "%ProgramData%\Microsoft\Windows\Start Menu\%~1"
  call :DelFile "%ProgramData%\Microsoft\Windows\Start Menu\Programs\%~1.lnk"
  call :DelFile "%ProgramData%\Microsoft\Windows\Start Menu\%~1.lnk"
)
exit /B

:CopyFilesInAppData
if "%~1"=="" exit /B 1
if "%~2"=="" exit /B 1
setlocal
cd>nul 2>nul /D "%SYSTEMDRIVE%\Users" || ^
cd>nul 2>nul /D "%SYSTEMDRIVE%\Documents and Settings" || exit /B 1
for /D %%i in ("*.*" "All Users" "Default") do (
  if exist "%%~i\AppData\Local"                   xcopy.exe /C /H /I /R /S /Y /Z "%~1" "%%~i\AppData\Local\%~2\"
  if exist "%%~i\AppData\Roaming"                 xcopy.exe /C /H /I /R /S /Y /Z "%~1" "%%~i\AppData\Roaming\%~2\"
  if exist "%%~i\Application Data"                xcopy.exe /C /H /I /R /S /Y /Z "%~1" "%%~i\Application Data\%~2\"
  if exist "%%~i\Local Settings\Application Data" xcopy.exe /C /H /I /R /S /Y /Z "%~1" "%%~i\Local Settings\Application Data\%~2\"
)
endlocal
exit /B

:Finish
