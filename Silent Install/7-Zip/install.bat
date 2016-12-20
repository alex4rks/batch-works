@echo off
set PATH=%SYSTEMROOT%\SYSTEM32;%SYSTEMROOT%;%SYSTEMROOT%\SYSTEM32\WBEM;
set PROGRAM_DIR=%ProgramFiles: (x86)=%

:: http://sourceforge.net/projects/sevenzip/files/7-Zip/
if defined ProgramFiles(x86) (
  for /R "%~dp0" %%i in ("7z*x64*.msi") do set INSTALLER=%%~nxi
) else (
  for /R "%~dp0" %%i in ("7z*x32*.msi") do set INSTALLER=%%~nxi
)

set PROGRAM_DESC=Архиватор
set PROGRAM_NAME=7-Zip
set PROGRAM_EXEC=7zfm.exe

set   PROGRAM_ID=7-Zip.
set PROGRAM_ICON=7z.dll

set KEY=%~1
if defined SFXCMD set SFXCMD=%SFXCMD:*.exe=%
if defined SFXCMD set SFXCMD=%SFXCMD:"=%
if defined SFXCMD set    KEY=%SFXCMD: =%
if defined KEY    set    KEY=%KEY:/=-%

if /I "%KEY%"=="-sfx" goto MakeSFX

:UnInstall
taskkill.exe>nul 2>nul /F /T /IM "%PROGRAM_EXEC%" /IM "7z.exe" /IM "7zg.exe"
msiexec.exe >nul 2>nul /X "%~dp0%INSTALLER%" /QN /NORESTART
call        >nul 2>nul :UnInstallByName "7-Zip"
call        >nul 2>nul :DelDirInProgs "7-Zip"
for /F "tokens=1,2,*" %%i in ('reg.exe 2^>nul query "HKU"') do ^
reg.exe     >nul 2>nul delete "%%~i\Software\7-Zip" /F
reg.exe     >nul 2>nul delete "HKLM\Software\7-Zip" /F
call        >nul 2>nul :UnSet_Assoc "7z"
call        >nul 2>nul :UnSet_Assoc "arj"
call        >nul 2>nul :UnSet_Assoc "bz2"
call        >nul 2>nul :UnSet_Assoc "bzip2"
call        >nul 2>nul :UnSet_Assoc "cab"
call        >nul 2>nul :UnSet_Assoc "cpio"
call        >nul 2>nul :UnSet_Assoc "deb"
call        >nul 2>nul :UnSet_Assoc "dmg"
call        >nul 2>nul :UnSet_Assoc "fat"
call        >nul 2>nul :UnSet_Assoc "gz"
call        >nul 2>nul :UnSet_Assoc "gzip"
call        >nul 2>nul :UnSet_Assoc "hfs"
call        >nul 2>nul :UnSet_Assoc "iso"
call        >nul 2>nul :UnSet_Assoc "lha"
call        >nul 2>nul :UnSet_Assoc "lzh"
call        >nul 2>nul :UnSet_Assoc "lzma"
call        >nul 2>nul :UnSet_Assoc "ntfs"
call        >nul 2>nul :UnSet_Assoc "rar"
call        >nul 2>nul :UnSet_Assoc "rpm"
call        >nul 2>nul :UnSet_Assoc "squashfs"
call        >nul 2>nul :UnSet_Assoc "001"
call        >nul 2>nul :UnSet_Assoc "swm"
call        >nul 2>nul :UnSet_Assoc "tar"
call        >nul 2>nul :UnSet_Assoc "taz"
call        >nul 2>nul :UnSet_Assoc "tbz"
call        >nul 2>nul :UnSet_Assoc "tbz2"
call        >nul 2>nul :UnSet_Assoc "tgz"
call        >nul 2>nul :UnSet_Assoc "tpz"
call        >nul 2>nul :UnSet_Assoc "txz"
call        >nul 2>nul :UnSet_Assoc "vhd"
call        >nul 2>nul :UnSet_Assoc "wim"
call        >nul 2>nul :UnSet_Assoc "xar"
call        >nul 2>nul :UnSet_Assoc "xz"
call        >nul 2>nul :UnSet_Assoc "z"
call        >nul 2>nul :UnSet_Assoc "zip"
call        >nul 2>nul :DelShortcuts "7-Zip*"
if /I "%KEY%"=="-u" goto Finish

:Install
msiexec.exe>nul 2>nul /I "%~dp0%INSTALLER%" /QN /NORESTART ALLUSERS=1
reg.exe    >nul 2>nul import "%~dp07-zip.reg"
set PROGRAM_DIR=%ProgramFiles: (x86)=%
if exist "%ProgramFiles(x86)%\%PROGRAM_NAME%\%PROGRAM_EXEC%" set PROGRAM_DIR=%ProgramFiles(x86)%
call       >nul 2>nul :Set_Assoc "7z"       "0"
call       >nul 2>nul :Set_Assoc "arj"      "4"
call       >nul 2>nul :Set_Assoc "bz2"      "2"
call       >nul 2>nul :Set_Assoc "bzip2"    "2"
call       >nul 2>nul :Set_Assoc "cab"      "7"
call       >nul 2>nul :Set_Assoc "cpio"     "12"
call       >nul 2>nul :Set_Assoc "deb"      "11"
call       >nul 2>nul :Set_Assoc "dmg"      "17"
call       >nul 2>nul :Set_Assoc "fat"      "21"
call       >nul 2>nul :Set_Assoc "gz"       "14"
call       >nul 2>nul :Set_Assoc "gzip"     "14"
call       >nul 2>nul :Set_Assoc "hfs"      "18"
call       >nul 2>nul :Set_Assoc "iso"      "8"
call       >nul 2>nul :Set_Assoc "lha"      "6"
call       >nul 2>nul :Set_Assoc "lzh"      "6"
call       >nul 2>nul :Set_Assoc "lzma"     "16"
call       >nul 2>nul :Set_Assoc "ntfs"     "22"
call       >nul 2>nul :Set_Assoc "rar"      "3"
call       >nul 2>nul :Set_Assoc "rpm"      "10"
call       >nul 2>nul :Set_Assoc "squashfs" "24"
call       >nul 2>nul :Set_Assoc "001"      "9"
call       >nul 2>nul :Set_Assoc "swm"      "15"
call       >nul 2>nul :Set_Assoc "tar"      "13"
call       >nul 2>nul :Set_Assoc "taz"      "5"
call       >nul 2>nul :Set_Assoc "tbz"      "2"
call       >nul 2>nul :Set_Assoc "tbz2"     "2"
call       >nul 2>nul :Set_Assoc "tgz"      "14"
call       >nul 2>nul :Set_Assoc "tpz"      "14"
call       >nul 2>nul :Set_Assoc "txz"      "14"
call       >nul 2>nul :Set_Assoc "vhd"      "20"
call       >nul 2>nul :Set_Assoc "wim"      "15"
call       >nul 2>nul :Set_Assoc "xar"      "19"
call       >nul 2>nul :Set_Assoc "xz"       "23"
call       >nul 2>nul :Set_Assoc "z"        "5"
call       >nul 2>nul :Set_Assoc "zip"      "1"
::wscript.exe>nul 2>nul "%~dp0shortcut.vbs" "" "AllUsersPrograms\%PROGRAM_NAME%" "*"
::wscript.exe>nul 2>nul "%~dp0shortcut.vbs" "%PROGRAM_DIR%\%PROGRAM_NAME%\%PROGRAM_EXEC%" "AllUsersPrograms" "%PROGRAM_NAME%" "%PROGRAM_DESC%"
goto Finish

:UnSet_Assoc
reg.exe delete "HKCR\%PROGRAM_ID%%~1" /F
reg.exe delete "HKCU\Software\Classes\%PROGRAM_ID%%~1" /F
exit /B

:Set_Assoc
reg.exe add    "HKCR\.%~1"                               /VE /T REG_SZ /D "%PROGRAM_ID%%~1" /F
reg.exe add    "HKCR\%PROGRAM_ID%%~1"                    /VE /T REG_SZ /D "%PROGRAM_NAME%.%~1" /F
reg.exe add    "HKCR\%PROGRAM_ID%%~1\DefaultIcon"        /VE /T REG_SZ /D "%PROGRAM_DIR%\%PROGRAM_NAME%\%PROGRAM_ICON%,%~2" /F
reg.exe add    "HKCR\%PROGRAM_ID%%~1\shell\open\command" /VE /T REG_SZ /D "\"%PROGRAM_DIR%\%PROGRAM_NAME%\%PROGRAM_EXEC%\" \"%%1\"" /F
reg.exe delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.%~1\UserChoice" /F
reg.exe add    "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.%~1\UserChoice" /V "Progid" /T REG_SZ /D "%PROGRAM_ID%%~1" /F
exit /B

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
