Write-Host 'Installatie SQL Server 2017'
#Installatie SQL Server 2017
$folderpath="C:\Users\Administrator\Desktop"
$filepath="$folderpath\Setup.exe"
$Parms = " /qs /Install /ConfigurationFile=ConfigurationFile.ini -silent"
.\Setup.exe /ConfigurationFile=ConfigurationFile.ini

Write-Host 'Done'
Restart-Computer

