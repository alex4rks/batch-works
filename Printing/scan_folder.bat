@echo off

IF EXIST "C:\scan" (GOTO sharedir) ELSE (GOTO mkshare)
:mkshare
mkdir "C:\scan"
GOTO sharedir
:sharedir 
icacls "C:\scan" /GRANT:r "etmcorp\���짮��⥫� ������":(OI)(CI)M /T /Q /C  /inheritance:e
net share Scan /delete
net share Scan="C:\scan" "/GRANT:etmcorp\���짮��⥫� ������,CHANGE"
GOTO finish

:finish

