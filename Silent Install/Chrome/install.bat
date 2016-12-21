@echo off
:: Disable CMD UNC Check
setlocal enableextensions
Reg Query "HKLM\SOFTWARE\Microsoft\Command Processor" /v DisableUNCCheck 2>nul | findstr /c:"DisableUNCCheck    REG_DWORD    0x1" >nul
if %errorlevel%==0 (echo ...UNC is allowed) else (echo +++UNC Support added! & Reg.exe add "HKLM\SOFTWARE\Microsoft\Command Processor" /v "DisableUNCCheck" /t REG_DWORD /d "1" /f >nul)

echo Installing Google Chrome !
set PROGRAM_DIR=%ProgramFiles: (x86)=%
if defined ProgramFiles(x86) set PROGRAM_DIR=%ProgramFiles(x86)%
if defined ProgramFiles(x86) set WOW6432NODE=Wow6432Node\

:: https://www.google.ru/chrome/business/browser/admin/index.html
set INSTALLER=GoogleChromeStandaloneEnterprise.msi

set PROGRAM_DESC=Browser
set PROGRAM_NAME=Google Chrome
set PROGRAM_EXEC=chrome.exe
set KEY=%~1

:UnInstall
taskkill.exe>nul 2>nul /F /T /IM "%PROGRAM_EXEC%" /IM "googleupdate.exe" /IM "googletoolbar*"
ping.exe    >nul 2>nul 127.0.0.1 -n 4
msiexec.exe >nul 2>nul /X "%~dp0%INSTALLER%" /QN /NORESTART
call        >nul 2>nul :UnInstallByName "Google Chrome"
call        >nul 2>nul :UnInstallByName "Google Update Helper"
if /I "%KEY%"=="-u" ^
call        >nul 2>nul :DelDirInAppData "Google\Chrome"
call        >nul 2>nul :DelDirInAppData "Google\CrashReports"
reg.exe     >nul 2>nul delete "HKLM\SOFTWARE\Google\Update\Clients" /F
reg.exe     >nul 2>nul delete "HKLM\SOFTWARE\Google\Update\ClientState" /F
reg.exe     >nul 2>nul delete "HKLM\SOFTWARE\Wow6432Node\Google\Update\Clients" /F
reg.exe     >nul 2>nul delete "HKLM\SOFTWARE\Wow6432Node\Google\Update\ClientState" /F
call        >nul 2>nul :DelDirInProgs "Google\Chrome"
call        >nul 2>nul :DelDirInProgs "Google\CrashReports"
call        >nul 2>nul :DelDirInProgs "Google\Common\Google Updater"
call        >nul 2>nul :DelDirInProgs "Google\Update"
call        >nul 2>nul :DelDirInProgs "Google\Google Toolbar"
call        >nul 2>nul :DelDirInProgs "Google\GoogleToolbarNotifier"
rmdir       >nul 2>nul /Q             "%PROGRAM_DIR%\Google"
call        >nul 2>nul :DelShortcuts "Google Chrome"
if /I "%KEY%"=="-u" goto Finish

:Install
msiexec.exe >nul /I "%~dp0%INSTALLER%" /QN /NORESTART ALLUSERS=1
taskkill.exe>nul 2>nul /F /T /IM "googleupdate.exe"
call        >nul 2>nul :DelDirInProgs "Google\CrashReports"
call        >nul 2>nul :DelDirInProgs "Google\Common\Google Updater"
call        >nul 2>nul :DelDirInProgs "Google\Update"
if /I "%KEY%"=="-clean" ^
call        >nul 2>nul :DelDirInAppData "Google\Chrome"
rem copy master_pref
xcopy.exe >nul   /C /H /I /R /S /Y /Z "%~dp0master_preferences" "%PROGRAM_DIR%\Google\Chrome\Application\"

rem call        >nul 2>nul :UpdateFilesInAppData  "%~dp0Settings" "Google\Chrome\User Data\Default"
for /F %%i in ('reg.exe 2^>nul query "HKLM\SYSTEM\CurrentControlSet\Services"^|find.exe /I "gupdate"') do reg.exe>nul 2>nul delete "%%~i" /F
schtasks.exe>nul 2>nul /F /DELETE /TN "GoogleUpdateTaskMachineCore"
schtasks.exe>nul 2>nul /F /DELETE /TN "GoogleUpdateTaskMachineUA"
del         >nul 2>nul /A /F /Q       "%SYSTEMROOT%\Tasks\GoogleUpdateTaskMachineCore.job"
del         >nul 2>nul /A /F /Q       "%SYSTEMROOT%\Tasks\GoogleUpdateTaskMachineUA.job"
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
for /D %%i in ("%SYSTEMDRIVE%\Users" "D:\Users" "%SYSTEMDRIVE%\Documents and Settings") do ^ (
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

:UpdateFilesInAppData
if "%~1"=="" exit /B 1
if "%~2"=="" exit /B 1
setlocal
cd>nul 2>nul /D "%SYSTEMDRIVE%\Users" || ^
cd>nul 2>nul /D "%SYSTEMDRIVE%\Documents and Settings" || exit /B 1
for /D %%i in ("*.*" "All Users" "Default") do (
  if exist "%%~i\AppData\Local"                   xcopy.exe /C /D /H /I /R /S /Y /Z "%~1" "%%~i\AppData\Local\%~2\"
  if exist "%%~i\AppData\Roaming"                 xcopy.exe /C /D /H /I /R /S /Y /Z "%~1" "%%~i\AppData\Roaming\%~2\"
  if exist "%%~i\Application Data"                xcopy.exe /C /D /H /I /R /S /Y /Z "%~1" "%%~i\Application Data\%~2\"
  if exist "%%~i\Local Settings\Application Data" xcopy.exe /C /D /H /I /R /S /Y /Z "%~1" "%%~i\Local Settings\Application Data\%~2\"
)
endlocal
exit /B

:UnInstallByName
setlocal EnableDelayedExpansion
set sname=%~1
if defined sname set sname=!sname::=!
if defined sname set sname=!sname:"=!
if not defined sname exit /B 1
set dname=
set ktail=
for /F "tokens=*" %%s in ('reg.exe 2^>nul query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" /S^|findstr.exe 2^>nul /R "^HKEY_ ^....DisplayName"') do (
  for /F "tokens=1,2,*" %%a in ("%%~s") do if not "%%~a"=="" (
    if /I "%%~a"=="DisplayName" (
      set dname=%%~c
      if defined dname set dname=!dname::=!
      if defined dname set dname=!dname:"=!
      if defined dname call :MatchStr "!dname!" "!sname!" && call :UnInstallByName2 "!ktail!"
    ) else (
      set ktail=%%~s
      if defined ktail set ktail=!ktail::=!
      if defined ktail set ktail=!ktail:"=!
      if defined ktail set ktail=!ktail:*Uninstall\=!
    )
  )
)
set dname=
set ktail=
for /F "tokens=*" %%s in ('reg.exe 2^>nul query "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" /S^|findstr.exe 2^>nul /R "^HKEY_ ^....DisplayName"') do (
  for /F "tokens=1,2,*" %%a in ("%%~s") do if not "%%~a"=="" (
    if /I "%%~a"=="DisplayName" (
      set dname=%%~c
      if defined dname set dname=!dname::=!
      if defined dname set dname=!dname:"=!
      if defined dname call :MatchStr "!dname!" "!sname!" && call :UnInstallByName2 "!ktail!"
    ) else (
      set ktail=%%~s
      if defined ktail set ktail=!ktail::=!
      if defined ktail set ktail=!ktail:"=!
      if defined ktail set ktail=!ktail:*Uninstall\=!
    )
  )
)
set dname=
set ktail=
for /F "tokens=*" %%s in ('reg.exe 2^>nul query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Installer\UserData" /S^|findstr.exe 2^>nul /R "^HKEY_ ^....DisplayName"') do (
  for /F "tokens=1,2,*" %%a in ("%%~s") do if not "%%~a"=="" (
    if /I "%%~a"=="DisplayName" (
      set dname=%%~c
      if defined dname set dname=!dname::=!
      if defined dname set dname=!dname:"=!
      if defined dname call :MatchStr "!dname!" "!sname!" && reg.exe delete "!ktail!" /F
    ) else (
      set ktail=%%~s
      if defined ktail set ktail=!ktail::=!
      if defined ktail set ktail=!ktail:"=!
      if defined ktail set ktail=!ktail:\InstallProperties=!
    )
  )
)
set dname=
set ktail=
for /F "tokens=*" %%s in ('reg.exe 2^>nul query "HKCR\Installer\Products" /S^|findstr.exe 2^>nul /R "^HKEY_ ^....ProductName"') do (
  for /F "tokens=1,2,*" %%a in ("%%~s") do if not "%%~a"=="" (
    if /I "%%~a"=="ProductName" (
      set dname=%%~c
      if defined dname set dname=!dname::=!
      if defined dname set dname=!dname:"=!
      if defined dname call :MatchStr "!dname!" "!sname!" && reg.exe delete "!ktail!" /F
    ) else (
      set ktail=%%~s
      if defined ktail set ktail=!ktail::=!
      if defined ktail set ktail=!ktail:"=!
    )
  )
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
set str="%~1"
set str=%str:&=^&%
set str=%str:"=%
call :MatchStr2 "%str%" "%%str:%~2=%%"
endlocal
exit /B
:MatchStr2
if "%~1"=="%~2" exit /B 1
exit /B 0

:Finish
