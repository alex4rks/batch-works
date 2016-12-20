@echo off
:: echo Libs..
:: call "%~dp0..\_Script\OS\os.bat"
:: call "%~dp0..\Java\install.bat"
:: call "%~dp0..\Dotnet4\install.bat"

echo Must have: part 1
:: call "%~dp0..\Radmin\install.bat"
call "%~dp0..\AdobeReader\install.bat"
call "%~dp0..\doPDF\install.bat"
call "%~dp0..\FlashPlayer\install.bat"
:: call "%~dp0..\Lotus\install.bat"
:: call "%~dp0..\LibreOffice\install.bat"

echo part 2..
call "%~dp0..\Firefox\install.bat"
:: call "%~dp0..\WinRAR\install.bat"
call "%~dp0..\Skype\install.bat"

echo part 3..
call "%~dp0..\INVENTORY\install.bat"
:: call "%~dp0..\NS-2000\install.bat"
:: call "%~dp0..\DWG\install.bat"

:Finish