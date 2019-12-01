#Script voor het aanmaken van een webapplicatie in SharePoint 2019

#Add Snap-in Microsoft.SharePoint.PowerShell if not already loaded, continue if it already has been loaded
Add-PsSnapin "Microsoft.SharePoint.PowerShell" -EA 0
 
#Variables

$AppPoolAccount = "RED\Administrator"             #Application Pool domain account
$ApplicationPoolName ="SharePoint - 8080"         #Application Pool
$ContentDatabase = "SharePoint_ContentDB"         #Content DB
$DatabaseServer = "NOVEMBER2"                     #Alias of your DB Server
$Url = "http://mike2:8080/"                       #The name of your new Web Application
$Name = "Mike2 - Documenten"                      #The IIS host header
$Description = "SharePoint 2019 Publishing Site"
$SiteCollectionTemplate = 'STS#0'                 #Publishing site template

#Aanmaken SharePoint web applicatie
Write-Output "Creating New-SPWebApplication..."

New-SPWebApplication -ApplicationPool $ApplicationPoolName `
                     -ApplicationPoolAccount (Get-SPManagedAccount $AppPoolAccount) `
                     -Name $Description `
                     -AuthenticationProvider (New-SPAuthenticationProvider -UseWindowsIntegratedAuthentication) `
                     -DatabaseName $ContentDatabase `
                     -DatabaseServer $DatabaseServer `
                     -Port 8080 `
                     -URL $Url

#Aanmaken SharePoint site collection
Write-Output "Creating New-SPSite..."

New-SPSite -Url $Url `
           -Name $Name `
           -Description $Description `
           -OwnerAlias $AppPoolAccount `
           -Template $SiteCollectionTemplate

           
#set portal super accounts
$w = Get-SPWebApplication $Url
$w.Properties["portalsuperuseraccount"] = $AppPoolAccount
$w.Properties["portalsuperreaderaccount"] = $AppPoolAccount
$w.Update()
