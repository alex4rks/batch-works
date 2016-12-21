## Printing scripts
install and manage network printers

#### How to use print-reset.ps1 from cmd?

powershell.exe -NoProfile -executionpolicy bypass -Command "& '%~dp0print-reset.ps1' -full -force"

powershell.exe -NoProfile -executionpolicy bypass -Command "& '%~dp0print-reset.ps1' -light -force"


-Full: all printers will be deleted, spool folder will be restored and printing queue will be cleared.

-Light: cleans printing queue.



