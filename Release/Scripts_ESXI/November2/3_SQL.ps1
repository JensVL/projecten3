#Member voor Papa2 toevoegen
Add-LocalGroupMember -Group "Administrators" -Member "RED\Administrator"
Add-LocalGroupMember -Group "Administrators" -Member "RED\Papa2$"

Write-Host 'Installatie SQL Server 2017'
#Installatie SQL Server 2017
$folderpath="C:\Scripts_ESXI\November2"
$filepath="$folderpath\Setup.exe"
$Parms = " /qs /Install /ConfigurationFile=ConfigurationFile.ini -silent"
.\Setup.exe /ConfigurationFile=ConfigurationFile.ini

Write-Host 'Done'
Restart-Computer
