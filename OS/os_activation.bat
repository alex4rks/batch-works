@echo off
:: set proxy if nedeed
:: netsh winhttp set proxy 192.168.1.1:8080
:: ping.exe    >nul 2>nul 127.0.0.1 -n 4

cscript C:\Windows\System32\slmgr.vbs /ipk %~1
cscript C:\Windows\System32\slmgr.vbs /ato
ping.exe    >nul 2>nul 127.0.0.1 -n 3

:: cscript C:\Windows\System32\slmgr.vbs /dlv