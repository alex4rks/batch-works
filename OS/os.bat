:: for Russian Windows OS 
@echo off

:: disable ipv6
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters" /v "DisabledComponents" /t REG_DWORD /d "0xff" /f

netsh interface tcp set global rss=disabled autotuninglevel=disabled 
netsh interface 6to4 set state state=disabled 
netsh interface isatap set state disabled 

:: включить обнаружение пк в сети
netsh advfirewall firewall set rule group="Обнаружение сети" new enable=Yes
netsh advfirewall firewall set rule group="Общий доступ к файлам и принтерам" new enable=yes

:: explorer settings
:: show file extensions
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\Folder\HideFileExt" /v DefaultValue /t REG_DWORD /d 0 /f

:: ie addon dialog disable
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Ext" /v IgnoreFrameApprovalCheck /t REG_DWORD /d 1 /f
