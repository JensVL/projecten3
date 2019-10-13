start-transcript "C:\ScriptLogs\2.txt"
Write-host "Waiting 5 seconds before continuing"
start-sleep -s 5
Write-Output "installing prerequisites"
# install prerequisites voor sharepoint moet access tot internet hebben  
# dit hangt af van waar de shared folder is
  \\VBOXSVR\windows_school_vm\sharepoint\PrerequisiteInstaller.exe /unattended

# //install sql internet nodig
# \\VBOXSVR\windows_school_vm\SQLServer2016-SSEI-Eval.exe  /Iacceptsqlserverlicenseterms /q

Write-host "Waiting 5 seconds before continuing"
start-sleep -s 5



#############################################################################################################################
$password = ConvertTo-SecureString "Admin19" -AsPlainText -Force

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

stop-transcript



