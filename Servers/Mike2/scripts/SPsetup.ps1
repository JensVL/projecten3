Start-Process "\\VBOXSVR\windows_school_vm\sharepoint\officeserver\setup.exe" -ArgumentList "/config `"$PSScriptRoot\SPinstallation.xml`"" -WindowStyle Minimized -wait
