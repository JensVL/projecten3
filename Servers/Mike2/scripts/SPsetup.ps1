Start-Process "Z:\sharepoint\officeserver\setup.exe" -ArgumentList "/config `"$PSScriptRoot\SPinstallation.xml`"" -WindowStyle Minimized -wait


& "Z:\scripts voor mike2\SPfarm.ps1"