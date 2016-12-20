@echo off
netsh winhttp set proxy 172.20.2.254:8080
ping.exe    >nul 2>nul 127.0.0.1 -n 4

set PROGRAM_DIR=%ProgramFiles: (x86)=%
if defined ProgramW6432 set PROGRAM_DIR=%ProgramFiles(x86)%
set KEY=%~1

rem KEY=YYYYY-XXXXX-ZZZZZ-FFFFF-DDDDD
@echo on
if not exist "%PROGRAM_DIR%\Microsoft Office\Office16\ospp.vbs" ( goto NoVBS )

cscript "%PROGRAM_DIR%\Microsoft Office\Office16\ospp.vbs" /inpkey:%KEY%
cscript "%PROGRAM_DIR%\Microsoft Office\Office16\ospp.vbs" /act

@echo off
goto Finish

:NoVBS
echo Error. OSPP.VBS not found!

:Finish