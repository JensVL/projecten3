Start-Process "Z:\sharepoint\setup.exe" -ArgumentList "/config `"$PSScriptRoot\SPinstallation.xml`"" -WindowStyle Minimized -wait

Add-PSSnapIn Microsoft.SharePoint.PowerShell

& "C:\Scripts_ESXI\Mike2\SPFarm.ps1"
