

// configure hostonlyadapter
New-NetIPAddress -IPAddress 172.18.1.3 -PrefixLength 24 -InterfaceIndex (Get-NetAdapter).InterfaceIndex

// configure dns 
Set-DnsClientServerAddress -interfaceAlias ethernet -serveraddresses 172.18.1.66

//change domain met ADDS Credentials

$password = ConvertTo-SecureString "Admin19" -AsPlainText -Force
$Cred = New-Object System.Management.Automation.PSCredential ("Administrator", $password)
Add-Computer -DomainName red -Credential $Cred


//change computername met adds credentials
rename-computer -computername "$env:computername" -newname "mike2" -DomainCredential $cred

//install prerequisites voor sharepoint moet access tot internet hebben  
//dit hangt af van waar de shared folder is
  \\VBOXSVR\windows_school_vm\sharepoint\PrerequisiteInstaller.exe /unattended

//install sql internet nodig

 \\VBOXSVR\windows_school_vm\SQLServer2016-SSEI-Eval.exe  /Iacceptsqlserverlicenseterms /q





#############################################################################################################################

$farmcredentials = (New-Object System.Management.Automation.PSCredential ($DOMAIN + "\" + "Administrator"),($password))

Write-Output "Creating the configuration database"
New-SPConfigurationDatabase `
-DatabaseName "SP2019_Configuration" `
-DatabaseServer "SPFarmAlias" `
-AdministrationContentDatabaseName "SP2019_Content_CentralAdministration" `
-Passphrase  (ConvertTo-SecureString "Admin2019" -AsPlainText -force) `
-FarmCredentials $farmcredentials

# config wizard tasks
 
Write-Output "Install Help Collections"
Install-SPHelpCollection -All
 
Write-Output "Initialize security"
Initialize-SPResourceSecurity
 
Write-Output "Install services"
Install-SPService
 
Write-Output "Register features"
Install-SPFeature -AllExistingFeatures
 
Write-Output "Install Application Content"
Install-SPApplicationConten


Write-Output "Create the Central Administration site"
New-SPCentralAdministration `
-Port 11111 `
-WindowsAuthProvider "NTLM"



