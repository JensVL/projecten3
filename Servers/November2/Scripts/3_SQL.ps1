#Member voor Papa2 toevoegen
Add-LocalGroupMember -Group "Administrators" -Member "RED\Administrator"
Add-LocalGroupMember -Group "Administrators" -Member "RED\Papa2$"

#Write-Host 'Installatie SQL Server 2017'
#Installatie SQL Server 2017
#$folderpath="C:\Users\Administrator\Desktop\SQLserver"
#$filepath="$folderpath\Setup.exe"
#Set-location -Path "$folderpath"
#$Parms = " /qs /Install /ConfigurationFile=ConfigurationFile.ini -silent"
#.\Setup.exe /ConfigurationFile=ConfigurationFile.ini

$folderpath="C:\Users\Administrator.RED\Documents"
$filepath="$folderpath\SETUP.exe"
$paswd="Admin2019" | ConvertTo-SecureString - AsPlainText -Force
.$folderpath\SETUP.exe /Q /ACTION=Install /IACCEPTSQLSERVERLICENSETERMS /Features=SQL /INSTANCENAME="MSSQLSERVER" /INSTANCEID="MSSQLSERVER" /SQLSVCACCOUNT="RED\Administrator" `
/SQLSVCPASSWORD="$paswd" /AGTSVCACCOUNT="RED\Administrator" /AGTSVCPASSWORD="$paswd" /FTSVACCOUNT="RED\Administrator" /FTSVCPASSWORD="$paswd" `
/SQLSYSADMINACCOUNTS="RED\Administrator" /INSTALLSQLDATADIR=C:\SQLServer /SQLUSERDBDIR="C:\Database" /SQLUSERDBLOGDIR="C:\DBlogs" `
/SQLBACKUPDIR="C:\Backup" /SQLTEMPDBDIR="C:\TempDB" /SQLTEMPDBLOGDIR="C:\TempDBlog" `
/TCPENABLED="1" `
/NPENABLED="1"

Write-Host 'Done'

