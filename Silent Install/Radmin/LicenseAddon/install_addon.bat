@echo off
if not exist "%~dp0r32addon.dll" goto error:
if not exist "%~dp0nts64helper.dll" goto error:

set rdir=n
if exist "%windir%\System32\rserver30\rserver3.exe" set rdir=%windir%\System32\rserver30
if exist "%windir%\SysWOW64\rserver30\rserver3.exe" set rdir=%windir%\SysWOW64\rserver30
if %rdir%==n goto rerror:

echo>"%rdir%\ntstest"
if not exist "%rdir%\ntstest" goto rights:
del /f /q "%rdir%\ntstest" >nul

net stop rserver3
if exist "%rdir%\newtstop.dll" goto old:
:install
copy /y "%~dp0r32addon.dll" "%rdir%\wsock32.dll" >nul
if exist "%rdir%\fam64helper.exe" copy /y "%~dp0nts64helper.dll" "%rdir%" >nul
net start rserver3 >nul
goto end:

:error
echo Installation files not found.
goto end:

:rerror
echo Cannot find Radmin Server.
goto end:

:old
regsvr32 /s /u "%rdir%\newtstop.dll" >nul
del /f "%rdir%\newtstop.dll" >nul
del /f "%rdir%\newtstop.ini" >nul
goto install:

:rights
echo Administrator rights are required.
goto end:

:end
REG ADD HKLM\Software\Radmin\v3.0\Server /v "LicenseText" /t REG_SZ /d "There is no license" /f >nul