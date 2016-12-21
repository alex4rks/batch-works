@echo off

:: Disable CMD UNC Check
setlocal enableextensions
Reg Query "HKLM\SOFTWARE\Microsoft\Command Processor" /v DisableUNCCheck 2>nul | findstr /c:"DisableUNCCheck    REG_DWORD    0x1" >nul
if %errorlevel%==0 (echo ...UNC is allowed) else (echo +++UNC Support added! & Reg.exe add "HKLM\SOFTWARE\Microsoft\Command Processor" /v "DisableUNCCheck" /t REG_DWORD /d "1" /f >nul)

set PROGRAM_DIR=%ProgramFiles: (x86)=%
if defined ProgramFiles(x86) set PROGRAM_DIR=%ProgramFiles(x86)%

:: http://www.codecguide.com/download_k-lite_codec_pack_mega.htm
set INSTALLER=MPC-HC_1710_x86.exe


:UnInstall
taskkill.exe>nul 2>nul /F /T /IM "%INSTALLER%" /IM "mpc-hc.exe" /IM "codectweaktool.exe"
"%PROGRAM_DIR%\MPC-HC\unins000.exe">nul 2>nul /SILENT
ping.exe    >nul 2>nul 127.0.0.1 -n 3
rmdir       >nul 2>nul /S /Q "%PROGRAM_DIR%\MPC-HC"
if /I "%~1"=="-u" goto Finish
if /I "%~1"=="/u" goto Finish

:Install
"%~dp0%INSTALLER%" /VERYSILENT /NORESTART
goto Finish

:Finish
