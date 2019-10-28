Add-PSSnapin microsoft.sharepoint.powershell

$password = ConvertTo-SecureString "Admin2019" -AsPlainText -Force

$farmcredentials = (New-Object System.Management.Automation.PSCredential ($DOMAIN + "\" + "Administrator"),($password))

Write-Output "Creating the configuration database"
New-SPConfigurationDatabase `
-DatabaseName "November2" `
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
