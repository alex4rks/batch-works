Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Svchost" /v "GPSvcGroup" /t REG_MULTI_SZ /d "GPSvc" /f
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Svchost\GPSvcGroup" /v "AuthenticationCapabilities" /t REG_DWORD /d "12320" /f
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Svchost\GPSvcGroup" /v "CoInitializeSecurityParam" /t REG_DWORD /d "1" /f