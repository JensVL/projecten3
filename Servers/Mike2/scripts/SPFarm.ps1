Write-Host " - Sharepoint PowerShell cmdlets..."
If ((Get-PsSnapin |?{$_.Name -eq "Microsoft.SharePoint.PowerShell"})-eq $null)
{
    Add-PsSnapin Microsoft.SharePoint.PowerShell | Out-Null
}
Start-SPAssignment -Global | Out-Null

$password = ConvertTo-SecureString "Admin2019" -AsPlainText -Force

$farmcredentials = (New-Object System.Management.Automation.PSCredential ("RED" + "\" + "Administrator"),($password))

Write-Output "Creating the configuration database"
New-SPConfigurationDatabase `
-DatabaseServer "NOVEMBER2" `
-DatabaseName "SharePoint_Config" `
-AdministrationContentDatabaseName "SP2019_Content_CentralAdministration" `
-Passphrase  (ConvertTo-SecureString "Admin2019" -AsPlainText -force) `
-FarmCredentials $farmcredentials `
-localserverrole "SingleServerFarm"

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
-Port 8080 `
-WindowsAuthProvider "NTLM"
