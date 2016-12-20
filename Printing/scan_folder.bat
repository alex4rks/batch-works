@echo off

IF EXIST "C:\scan" (GOTO sharedir) ELSE (GOTO mkshare)
:mkshare
mkdir "C:\scan"
GOTO sharedir
:sharedir 
icacls "C:\scan" /GRANT:r "etmcorp\пользователи домена":(OI)(CI)M /T /Q /C  /inheritance:e
net share Scan /delete
net share Scan="C:\scan" "/GRANT:etmcorp\пользователи домена,CHANGE"
GOTO finish

:finish

