Write-Host 'Installatie SQL Server 2017'
#Installatie SQL Server 2017
$folderpath="C:\Users\Administrator\Desktop"
$filepath="$folderpath\SSDT-Setup-ENU.exe"
$Parms = " -f=$folderpath\ConfigurationFile.ini -silent"

Start-Process -Filepath $filepath -ArgumentList $Parms -Wait
Write-Host 'Done'
Restart-Computer
