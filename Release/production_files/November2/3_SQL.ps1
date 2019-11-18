#Member voor Papa2 toevoegen
Add-LocalGroupMember -Group "Administrators" -Member "RED\Administrator"
Add-LocalGroupMember -Group "Administrators" -Member "RED\Papa2$"

Write-Host 'Installatie SQL Server 2017'
#Installatie SQL Server 2017

$folderpath="D:\School\3de jaar\Projecten\Laatste versie\Project\SQL Server 2017 Installation"
$filepath="$folderpath\SETUP.exe"
Write-Host 'Deel 1...'
$paswd="Admin2019" | ConvertTo-SecureString -AsPlainText -Force
$SCCMPassword = [System.Runtime.Interopservices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($paswd))
Write-Host 'Deel 2...'
.$folderpath\SETUP.exe /Q /ACTION=Install /IACCEPTSQLSERVERLICENSETERMS /Features=SQL /INSTANCENAME=MSSQLSERVER /INSTANCEID=MSSQLSERVER `
/SQLSVCACCOUNT="RED\Administrator" `
/SQLSVCPASSWORD="$SCCMPassword" `
/AGTSVCACCOUNT="RED\Administrator" `
/AGTSVCPASSWORD="$SCCMPassword" `
/FTSVCACCOUNT="RED\Administrator" `
/FTSVCPASSWORD="$SCCMPassword" `
/SQLSysAdminAccounts= "RED\Administrator" `
/INSTALLSQLDATADIR="C:\SQLServer" `
/SQLUSERDBDIR="C:\Database" `
/SQLUSERDBLOGDIR="C:\DBlogs" `
/SQLBACKUPDIR="C:\Backup" `
/SQLTEMPDBDIR="C:\TempDB" `
/SQLTEMPDBLOGDIR="C:\TempDBlog" `
/TCPENABLED="1" `
/NPENABLED="1"

Write-Host 'Done'
Restart-Computer
