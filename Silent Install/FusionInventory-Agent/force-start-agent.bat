@echo off

if exist C:\Program Files (x86)\FusionInventory-Agent (
	set FORCE_PATH=C:\Program Files (x86)\FusionInventory-Agent
) 
if exist C:\Program Files\FusionInventory-Agent (
	set FORCE_PATH=C:\Program Files\FusionInventory-Agent
) 


:: sc query fusioninventory-agent >nul 2>nul

echo Force starting agent
@echo on
cd /d "%FORCE_PATH%"
call "%FORCE_PATH%\fusioninventory-agent.bat"
@echo off

goto Finish
 


:Finish