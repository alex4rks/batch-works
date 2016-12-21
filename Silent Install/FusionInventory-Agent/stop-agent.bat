@echo off

sc query fusioninventory-agent >nul 2>nul
if %errorlevel%==0 (
	echo FusionInventory-Agent service found
	echo Stopping...
	net.exe stop   "fusioninventory-agent"
	sc.exe  config "fusioninventory-agent" start= disabled
		if %errorlevel%==0 ( echo SUCCESS : agent disabled successfully )
	goto Finish
) 


:Finish