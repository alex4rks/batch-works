:: Windows 10 Lite Touch Configuration Post-Install Script
:: Kosarev Albert, 2017

:: Disable CMD UNC Check
setlocal enableextensions
Reg Query "HKLM\SOFTWARE\Microsoft\Command Processor" /v DisableUNCCheck 2>nul | findstr /c:"DisableUNCCheck    REG_DWORD    0x1" >nul
if not %errorlevel%==0 (echo +++UNC Support & Reg.exe add "HKLM\SOFTWARE\Microsoft\Command Processor" /v "DisableUNCCheck" /t REG_DWORD /d "1" /f >nul)

:: add admin
net user admin pass /add
powershell.exe -command "& {Add-LocalGroupMember -SID 'S-1-5-32-544' -Member 'admin'}"

::
rmdir /s /q C:\Logs >nul 2>nul
rmdir /s /q C:\PerfLogs >nul 2>nul

:: LM
call \\share\Software\LiteManager\install.bat

:: Telemetry shared folder
mkdir C:\telemetry 2>nul
net share telemetry="C:\telemetry"

:: 5 % protection on disk C
vssadmin.exe Resize ShadowStorage /For=C: /On=C: /MaxSize=5%%

:: For installing .dll as normal user
:: http://neophob.com/2007/08/setacl-examples/
\\share\Software\OS\_Litetouch\conf\tweaks\SetACL_x64.exe -on "hklm\software\Classes" -ot reg -actn ace -ace "n:S-1-5-32-547;p:full"

powercfg -h off

:: UAC
:: http://winaero.com/blog/how-to-tweak-or-disable-uac-in-windows-8-1/
reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "EnableLUA" /t REG_DWORD /d "1" /f
reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "ConsentPromptBehaviorAdmin" /t REG_DWORD /d "5" /f
reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "ConsentPromptBehaviorUser" /t REG_DWORD /d "3" /f
reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "PromptOnSecureDesktop" /t REG_DWORD /d "0" /f



:: "SMBv1 remove"
dism /Online /Disable-Feature /FeatureName:SMB1Protocol /Quiet /NoRestart 
reg add "HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" /v "SMB1" /t REG_DWORD /d "0" /f

:: antispy, removes onedrive, defender, etc
powershell.exe -noprofile -Executionpolicy Bypass -File "\\share\Software\OS\_Litetouch\conf\tweaks\windows10_optimizations.ps1" 
