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
Write-Host 'Deel 1...'
$paswd="Admin2019" | ConvertTo-SecureString -AsPlainText -Force
Write-Host 'Deel 2...'
.$folderpath\SETUP.exe /Q /ACTION=Install /IACCEPTSQLSERVERLICENSETERMS /Features=SQLENGINE /INSTANCENAME=MSSQLSERVER `
/INSTANCEID=MSSQLSERVER `
/SQLSVCACCOUNT="RED\Administrator" `
/SQLSVCPASSWORD=$paswd `
/AGTSVCACCOUNT="RED\Administrator" `
/AGTSVCPASSWORD=$paswd `
/FTSVCACCOUNT="RED\Administrator" `
/FTSVCPASSWORD=$paswd `
/SQLSysAdminAccounts = @('RED\Administrators') `
/INSTALLSQLDATADIR=$folderpath\SQLServer `
/SQLUSERDBDIR=$folderpath\Database `
/SQLUSERDBLOGDIR=$folderpath\DBlogs `
/SQLBACKUPDIR=$folderpath\Backup `
/SQLTEMPDBDIR=$folderpath\TempDB `
/SQLTEMPDBLOGDIR=$folderpath\TempDBlog `
/TCPENABLED="1" `
/NPENABLED="1"

Write-Host 'Done'

