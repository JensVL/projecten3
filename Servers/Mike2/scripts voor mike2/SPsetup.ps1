Start-Process "Z:\sharepoint\setup.exe" -ArgumentList "/config `"$PSScriptRoot\SPinstallation.xml`"" -WindowStyle Minimized -wait

Add-PSSnapIn Microsoft.SharePoint.PowerShell

& "Z:\scripts voor mike2\SPfarm.ps1"
