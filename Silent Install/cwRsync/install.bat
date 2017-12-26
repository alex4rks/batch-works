::@echo off
:: Disable CMD UNC Check
setlocal enableextensions
Reg Query "HKLM\SOFTWARE\Microsoft\Command Processor" /v DisableUNCCheck 2>nul | findstr /c:"DisableUNCCheck    REG_DWORD    0x1" >nul
if not %errorlevel%==0 (echo +++UNC Support & Reg.exe add "HKLM\SOFTWARE\Microsoft\Command Processor" /v "DisableUNCCheck" /t REG_DWORD /d "1" /f >nul)

set SOURCE_DIR=%~dp0cwRsync
set TARGET_DIR="C:\Program Files (x86)\cwRsync"
set INSTALLER=rsync


:Install
mkdir C:\sender
echo Installing rsync
taskkill.exe /f /t /IM rsync*
rmdir /S /Q "C:\Program Files (x86)\cwRsync"
schtasks.exe /delete /tn "cwRsync" /F

:: Robocopy.exe %SOURCE_DIR% %TARGET_DIR% /E /R:1 /W:4 /NOCOPY /COPY:D >nul
xcopy.exe %SOURCE_DIR% %TARGET_DIR% /V /E /Y /I /Q
if not exist "C:\Program Files (x86)\cwRsync" (
	echo ERROR :: package wasn't found! ((
	exit /b 1
)

:: wmic logicaldisk where drivetype=3 get deviceid | findstr /c:"D:"
SchTasks.exe /Create /TN "cwRsync" /SC ONSTART /TR "'C:\Program Files (x86)\cwRsync\bin\rsync.exe' --config 'C:\Program Files (x86)\cwRsync\bin\conf\rsyncd.conf.txt' --daemon" /RU "System" /RL HIGHEST

if %errorlevel%==0 ( echo SUCCESS : %INSTALLER% installed successfully )
if NOT %errorlevel%==0 ( echo ERROR : %INSTALLER% has installation errors && exit /b 1 )

:: run task
schtasks.exe /Run /TN cwRsync

:Finish