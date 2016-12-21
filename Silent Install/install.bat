@echo off
:: Disable CMD UNC Check
setlocal enableextensions
Reg Query "HKLM\SOFTWARE\Microsoft\Command Processor" /v DisableUNCCheck 2>nul | findstr /c:"DisableUNCCheck    REG_DWORD    0x1" >nul
if not %errorlevel%==0 (echo +++UNC Support & Reg.exe add "HKLM\SOFTWARE\Microsoft\Command Processor" /v "DisableUNCCheck" /t REG_DWORD /d "1" /f >nul)


echo Libs..
call "%~dp0Java\install.bat"
call "%~dp0Dotnet4\install.bat"

echo part 1
call "%~dp0Radmin\install.bat"
call "%~dp0AdobeReader\install.bat"
call "%~dp0doPDF\install.bat"
call "%~dp0FlashPlayer\install.bat"
call "%~dp0Lotus\install.bat"
call "%~dp0OpenOffice\install.bat"
call "%~dp0LibreOffice\install.bat"

echo part 2..
call "%~dp0Firefox\install.bat"
call "%~dp0WinRAR\install.bat"
call "%~dp0Skype\install.bat"

echo part 3..
call "%~dp0DWG\install.bat"
::call <your script>

:Finish