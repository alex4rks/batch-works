@echo off
:: Disable CMD UNC Check
setlocal enableextensions
Reg Query "HKLM\SOFTWARE\Microsoft\Command Processor" /v DisableUNCCheck 2>nul | findstr /c:"DisableUNCCheck    REG_DWORD    0x1" >nul
if not %errorlevel%==0 (echo +++UNC Support & Reg.exe add "HKLM\SOFTWARE\Microsoft\Command Processor" /v "DisableUNCCheck" /t REG_DWORD /d "1" /f >nul)

set INSTALLER=fusioninventory-agent_windows-x86.exe

sc query fusioninventory-agent >nul 2>nul
if %errorlevel%==0 (
	echo +++ FusionInventory is already installed +++
	goto Finish) 

:Install
echo Installing fusion inventory for glpi
%~dp0%INSTALLER% /acceptlicense /execmode=Service /S /installtasks=Collect,Inventory  /installtype=from-scratch /task-daily-modifier=7 /task-frequency=Daily /server="http://172.20.2.111/glpi/plugins/fusioninventory/" /no-ssl-check /no-httpd /no-p2p /no-start-menu /runnow
if %errorlevel%==0 ( echo SUCCESS : %installer% installed successfully )

:Finish