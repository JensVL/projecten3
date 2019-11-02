param(
    [string]$filepath = "C:\Users\Administrator\Desktop\Setup.exe",
    [string]$params   = " /qs /Install /ConfigurationFile=ConfigurationFile.ini -silent"
)

Write-Host 'Installatie SQL Server 2017'
# Installatie SQL Server 2017
# NOTE: The variables below are declared as parameters at the top of the script
# $folderpath="C:\Users\Administrator\Desktop"
# $filepath="$folderpath\Setup.exe"
# $Parms = " /qs /Install /ConfigurationFile=ConfigurationFile.ini -silent"

# TODO: Use filepath like in script 4_SSMS.ps1
Setup.exe /ConfigurationFile=ConfigurationFile.ini
#.\Setup.exe /ConfigurationFile=ConfigurationFile.ini

Write-Host 'Done'
# Restart-Computer
