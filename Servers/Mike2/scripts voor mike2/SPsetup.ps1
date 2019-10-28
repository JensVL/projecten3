Start-Process "Z:\sharepoint\setup.exe" -ArgumentList "/config `"$PSScriptRoot\SPinstallation.xml`"" -WindowStyle Minimized -wait


& "Z:\scripts voor mike2\SPfarm.ps1"