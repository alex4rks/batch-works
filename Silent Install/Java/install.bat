@echo off
:: Disable CMD UNC Check
setlocal enableextensions
Reg Query "HKLM\SOFTWARE\Microsoft\Command Processor" /v DisableUNCCheck 2>nul | findstr /c:"DisableUNCCheck    REG_DWORD    0x1" >nul
if not %errorlevel%==0 (echo +++UNC Support & Reg.exe add "HKLM\SOFTWARE\Microsoft\Command Processor" /v "DisableUNCCheck" /t REG_DWORD /d "1" /f >nul)

for /R "%~dp0" %%i in ("jre*.msi") do set INSTALLER=%%~nxi
set UNINSTALLER={26A24AE4-039D-4CA4-87B4-2F83216016FF}

set PROGRAM_NAME=Java

:UnInstall
setlocal
taskkill.exe>nul 2>nul /F /T /IM "javaw.exe" /IM "jp2launcher.exe" /IM "jqs.exe" /IM "jusched.exe" /IM "iexplore.exe"
msiexec.exe >nul 2>nul /X "%~dp0%INSTALLER%" /QN /NORESTART
::msiexec.exe >nul 2>nul /X "%~dp0x64\%INSTALLER%" /QN /NORESTART
msiexec.exe >nul 2>nul /X "%UNINSTALLER%"        /QN /NORESTART
call        >nul 2>nul :UnInstallByName "Java"
call        >nul 2>nul :DelDirInProgs "Java"
call        >nul 2>nul :DelShortcuts "Java"
if /I "%KEY%"=="-u" goto Finish

:Install
echo Installing Java 32 for x86 and amd64
msiexec.exe >nul /I "%~dp0%INSTALLER%" /QN /NORESTART ALLUSERS=1 ADDLOCAL=ALL IEXPLORER=1 MOZILLA=0 STATIC=1 UPDATECHECK=0 AUTOUPDATECHECK=0 JAVAUPDATE=0 JU=0 JQS=0 SYSTRAY=0 EULA=0 REBOOT=suppress
if %errorlevel%==0 ( echo SUCCESS : %installer% installed successfully )
::64 bit
:: msiexec.exe >nul /I "%~dp0x64\%INSTALLER%" /QN /NORESTART ALLUSERS=1 ADDLOCAL=ALL IEXPLORER=1 MOZILLA=1 STATIC=1 UPDATECHECK=0 AUTOUPDATECHECK=0 JAVAUPDATE=0 JU=0 JQS=0 SYSTRAY=0 EULA=0 REBOOT=suppress
msiexec.exe >nul 2>nul /X "{4A03706F-666A-4037-7777-5F2748764D10}" /QN /NORESTART
call        >nul 2>nul :UnInstallByName "Java Auto Updater"
net.exe     >nul 2>nul stop   "JavaQuickStarterService"
reg.exe     >nul 2>nul delete "HKLM\SYSTEM\CurrentControlSet\Services\JavaQuickStarterService" /F
reg.exe     >nul 2>nul delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"             /V "SunJavaUpdateSched" /F
reg.exe     >nul 2>nul delete "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Run" /V "SunJavaUpdateSched" /F
rmdir       >nul 2>nul /S /Q  "%COMMONPROGRAMFILES%\Java\Java Update"
call        >nul 2>nul :DelShortcuts "Java"
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
)
if defined ProgramData (
  call :DelDir  "%ProgramData%\Microsoft\Windows\Start Menu\Programs\%~1"
  call :DelDir  "%ProgramData%\Microsoft\Windows\Start Menu\%~1"
  call :DelFile "%ProgramData%\Microsoft\Windows\Start Menu\Programs\%~1.lnk"
  call :DelFile "%ProgramData%\Microsoft\Windows\Start Menu\%~1.lnk"
)
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