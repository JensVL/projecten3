############################################################
# Configure-SPFarm.ps1
# Configures a SharePoint 2019 farm with:
#   Configuration Database
#   Central Administation web application and site
############################################################
 
# Service accounts
$DOMAIN = "CONTOSO"
$accounts = @{}
$accounts.Add("SPFarm", @{"username" = "sp2019-farm"; "password" = "Password123"})
$accounts.Add("SPWebApp", @{"username" = "sp2019-ap-webapp"; "password" = "Password123"})
$accounts.Add("SPSvcApp", @{"username" = "sp2019-ap-service"; "password" = "Password123"})
 
 
Foreach ($account in $accounts.keys) {
    $accounts.$account.Add(`
    "credential", `
    (New-Object System.Management.Automation.PSCredential ($DOMAIN + "\" + $accounts.$account.username), `
    (ConvertTo-SecureString -String $accounts.$account.password -AsPlainText -Force)))
}
 
 
# SQL Server client alias
 
 
#This is the name of your SQL Alias
$AliasName = "SPFarmAlias"
  
#This is the name of your SQL server
# In this case we're using the current computer name as we are assuming SharePoint and SQL are on the same server
$ServerName = $env:computername
  
#These are the two Registry locations for the SQL Alias locations
$x86 = "HKLM:\Software\Microsoft\MSSQLServer\Client\ConnectTo"
$x64 = "HKLM:\Software\Wow6432Node\Microsoft\MSSQLServer\Client\ConnectTo"
  
#We're going to see if the ConnectTo key already exists, and create it if it doesn't.
if ((test-path -path $x86) -ne $True)
{
    write-host "$x86 doesn't exist"
    New-Item $x86
}
if ((test-path -path $x64) -ne $True)
{
    write-host "$x64 doesn't exist"
    New-Item $x64
}
  
#Adding the extra "fluff" to tell the machine what type of alias it is
$TCPAlias = ("DBMSSOCN," + $ServerName)
  
#Creating our TCP/IP Aliases
New-ItemProperty -Path $x86 -Name $AliasName -PropertyType String -Value $TCPAlias
New-ItemProperty -Path $x64 -Name $AliasName -PropertyType String -Value $TCPAlias
 
# Open cliconfig to verify the aliases
Start-Process C:\Windows\System32\cliconfg.exe
Start-Process C:\Windows\SysWOW64\cliconfg.exe
 
 
 
# Farm configuration
 
$configPassphrase = "SharePoint 2019 is the latest version of SharePoint!"
$s_configPassphrase = (ConvertTo-SecureString -String $configPassphrase -AsPlainText -force)
 
$serverDB = $AliasName
$dbConfig = "SP2019_Configuration"
$dbCentralAdmin = "SP2019_Content_CentralAdministration"
 
$caPort = 11111
$caAuthProvider = "NTLM"
 
########################################
# Create the farm
 
Add-PSSnapin Microsoft.SharePoint.PowerShell
 
Write-Output "Creating the configuration database $dbConfig"
New-SPConfigurationDatabase `
-DatabaseName $dbConfig `
-DatabaseServer $serverDB `
-AdministrationContentDatabaseName $dbCentralAdmin `
-Passphrase  $s_configPassphrase `
-FarmCredentials $accounts.SPFarm.credential
 
# Check to make sure the farm exists and is running. if not, end the script
$farm = Get-SPFarm
if (!$farm -or $farm.Status -ne "Online") {
    Write-Output "Farm was not created or is not running"
    exit
}
 
Write-Output "Create the Central Administration site on port $caPort"
New-SPCentralAdministration `
-Port $caPort `
-WindowsAuthProvider $caAuthProvider
 
 
# Perform the config wizard tasks
 
Write-Output "Install Help Collections"
Install-SPHelpCollection -All
 
Write-Output "Initialize security"
Initialize-SPResourceSecurity
 
Write-Output "Install services"
Install-SPService
 
Write-Output "Register features"
Install-SPFeature -AllExistingFeatures
 
Write-Output "Install Application Content"
Install-SPApplicationContent
 
 
# Add managed accounts
Write-Output "Creating managed accounts ..."
New-SPManagedAccount -credential $accounts.SPWebApp.credential
New-SPManagedAccount -credential $accounts.SPSvcApp.credential
New-SPManagedAccount -credential $accounts.SPCrawl.credential
 
#Start Central Administration
Write-Output "Starting Central Administration"
& 'C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\15\BIN\psconfigui.exe' -cmd showcentraladmin
 
Write-Output "Farm build complete."