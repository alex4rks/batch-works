@echo off

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