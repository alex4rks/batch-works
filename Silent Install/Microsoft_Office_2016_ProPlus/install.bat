@echo off
:: Disable CMD UNC Check
setlocal enableextensions
Reg Query "HKLM\SOFTWARE\Microsoft\Command Processor" /v DisableUNCCheck 2>nul | findstr /c:"DisableUNCCheck    REG_DWORD    0x1" >nul
if %errorlevel%==0 (echo ...UNC is allowed) else (echo +++UNC Support added! & Reg.exe add "HKLM\SOFTWARE\Microsoft\Command Processor" /v "DisableUNCCheck" /t REG_DWORD /d "1" /f >nul)


:: preconfigured "..\x86_RUS\config.xml" should be in the setup.exe directory to avoid unnessesary setup dialogs

set INSTALLER=%~dp0x86_RUS\setup.exe

if /I "%~1"=="-u" goto Uninstall
if /I "%~1"=="/u" goto Uninstall
goto Install

:UnInstall
taskkill.exe      >nul 2>nul /F /T /IM "%INSTALLER%" /IM "excel.exe" /IM "groove.exe" /IM "infopath.exe" /IM "msaccess.exe" /IM "msosync.exe" /IM "msouc.exe" /IM "mspub.exe" /IM "mstore.exe" /IM "mstordb.exe" /IM "ois.exe" /IM "onenote.exe" /IM "onenotem.exe" /IM "osppsvc.exe" /IM "outlook.exe" /IM "powerpnt.exe" /IM "selfcert.exe" /IM "setlang.exe" /IM "visio.exe" /IM "winword.exe"
echo Uninstalling MS office 2016
"%INSTALLER%" /uninstall "ProPlus" /config "%~dp0uninstall.xml"
rmdir /S /Q C:\MSOCache
if %errorlevel%==0 ( echo SUCCESS : MS office 2016 uninstalled successfully )
goto Finish

:Install
taskkill.exe      >nul 2>nul /F /T /IM "%INSTALLER%" /IM "excel.exe" /IM "groove.exe" /IM "infopath.exe" /IM "msaccess.exe" /IM "msosync.exe" /IM "msouc.exe" /IM "mspub.exe" /IM "mstore.exe" /IM "mstordb.exe" /IM "ois.exe" /IM "onenote.exe" /IM "onenotem.exe" /IM "osppsvc.exe" /IM "outlook.exe" /IM "powerpnt.exe" /IM "selfcert.exe" /IM "setlang.exe" /IM "visio.exe" /IM "winword.exe"
echo Installing MS Office 2016...
"%INSTALLER%" /adminfile "%~dp0install.msp"
if %errorlevel%==0 ( echo SUCCESS : MS office 2016 installed successfully )
net.exe           >nul 2>nul stop   "ose"
sc.exe            >nul 2>nul config "ose" start= disabled


schtasks.exe /Change /TN "Microsoft\Office\Office Automatic Updates" /Disable
schtasks.exe /Change /TN "Microsoft\Office\OfficeTelemetryAgentFallBack2016" /Disable
schtasks.exe /Change /TN "Microsoft\Office\OfficeTelemetryAgentLogOn2016" /Disable
schtasks.exe /Change /TN "Microsoft\Office\Office ClickToRun Service Monitor" /Disable
::
schtasks.exe /Change /TN "Microsoft\Office\OfficeBackgroundTaskHandlerRegistration" /Disable
schtasks.exe /Change /TN "Microsoft\Office\OfficeBackgroundTaskHandlerLogon" /Disable


Reg.exe add "HKLM\Software\Microsoft\Office\16.0\Outlook\Options\Mail" /v "EnableLogging" /t REG_DWORD /d "0" /f
Reg.exe add "HKLM\Software\Microsoft\Office\16.0\Word\Options" /v "EnableLogging" /t REG_DWORD /d "0" /f
Reg.exe add "HKLM\Software\Microsoft\Office\Common\ClientTelemetry" /v "DisableTelemetry" /t REG_DWORD /d "1" /f
Reg.exe add "HKLM\Software\Policies\Microsoft\Office\16.0\Firstrun" /v "disablemovie" /t REG_DWORD /d "1" /f
Reg.exe add "HKLM\Software\Policies\Microsoft\Office\16.0\Common" /v "sendcustomerdata" /t REG_DWORD /d "0" /f
Reg.exe add "HKLM\Software\Policies\Microsoft\Office\16.0\Common" /v "qmenable" /t REG_DWORD /d "0" /f
Reg.exe add "HKLM\Software\Policies\Microsoft\Office\16.0\Common" /v "updatereliabilitydata" /t REG_DWORD /d "0" /f
Reg.exe add "HKLM\Software\Policies\Microsoft\Office\16.0\Common\General" /v "shownfirstrunoptin" /t REG_DWORD /d "0" /f
Reg.exe add "HKLM\Software\Policies\Microsoft\Office\16.0\Common\General" /v "skydrivesigninoption" /t REG_DWORD /d "0" /f
Reg.exe add "HKLM\Software\Policies\Microsoft\Office\16.0\Common\Feedback" /v "enabled" /t REG_DWORD /d "0" /f
Reg.exe add "HKLM\Software\Policies\Microsoft\Office\16.0\Common\Feedback" /v "includescreenshot" /t REG_DWORD /d "0" /f
Reg.exe add "HKLM\Software\Policies\Microsoft\Office\16.0\Common\PTWatson" /v "ptwoptin" /t REG_DWORD /d "0" /f
Reg.exe add "HKLM\Software\Policies\Microsoft\Office\16.0\Common\Security\FileValidation" /v "disablereporting" /t REG_DWORD /d "1" /f
Reg.exe add "HKLM\Software\Policies\Microsoft\Office\16.0\Lync" /v "disableautomaticsendtracing" /t REG_DWORD /d "1" /f
Reg.exe add "HKLM\Software\Policies\Microsoft\Office\16.0\OSM" /v "Enablelogging" /t REG_DWORD /d "0" /f
Reg.exe add "HKLM\Software\Policies\Microsoft\Office\16.0\OSM" /v "EnableUpload" /t REG_DWORD /d "0" /f
Reg.exe add "HKLM\Software\Policies\Microsoft\Office\16.0\OSM\PreventedApplications" /v "accesssolution" /t REG_DWORD /d "1" /f
Reg.exe add "HKLM\Software\Policies\Microsoft\Office\16.0\OSM\PreventedApplications" /v "olksolution" /t REG_DWORD /d "1" /f
Reg.exe add "HKLM\Software\Policies\Microsoft\Office\16.0\OSM\PreventedApplications" /v "onenotesolution" /t REG_DWORD /d "1" /f
Reg.exe add "HKLM\Software\Policies\Microsoft\Office\16.0\OSM\PreventedApplications" /v "pptsolution" /t REG_DWORD /d "1" /f
Reg.exe add "HKLM\Software\Policies\Microsoft\Office\16.0\OSM\PreventedApplications" /v "projectsolution" /t REG_DWORD /d "1" /f
Reg.exe add "HKLM\Software\Policies\Microsoft\Office\16.0\OSM\PreventedApplications" /v "publishersolution" /t REG_DWORD /d "1" /f
Reg.exe add "HKLM\Software\Policies\Microsoft\Office\16.0\OSM\PreventedApplications" /v "visiosolution" /t REG_DWORD /d "1" /f
Reg.exe add "HKLM\Software\Policies\Microsoft\Office\16.0\OSM\PreventedApplications" /v "wdsolution" /t REG_DWORD /d "1" /f
Reg.exe add "HKLM\Software\Policies\Microsoft\Office\16.0\OSM\PreventedApplications" /v "xlsolution" /t REG_DWORD /d "1" /f
Reg.exe add "HKLM\Software\Policies\Microsoft\Office\16.0\OSM\PreventedSolutiontypes" /v "agave" /t REG_DWORD /d "1" /f
Reg.exe add "HKLM\Software\Policies\Microsoft\Office\16.0\OSM\PreventedSolutiontypes" /v "appaddins" /t REG_DWORD /d "1" /f
Reg.exe add "HKLM\Software\Policies\Microsoft\Office\16.0\OSM\PreventedSolutiontypes" /v "comaddins" /t REG_DWORD /d "1" /f
Reg.exe add "HKLM\Software\Policies\Microsoft\Office\16.0\OSM\PreventedSolutiontypes" /v "documentfiles" /t REG_DWORD /d "1" /f
Reg.exe add "HKLM\Software\Policies\Microsoft\Office\16.0\OSM\PreventedSolutiontypes" /v "templatefiles" /t REG_DWORD /d "1" /f


:Finish
