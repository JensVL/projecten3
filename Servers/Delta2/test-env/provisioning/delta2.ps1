# Provisioning script for delta2

#------------------------------------------------------------------------------
# Parameters
#------------------------------------------------------------------------------
Param(
    [string]$downloadpath       = 'C:\SetupMedia',

    [string]$iisusername        = 'vagrant',
    [string]$iispassword        = 'vagrant',

    [string]$stringasp45        = "$false",
    [string]$stringdotnetcore21 = "$false",
    [string]$stringdotnetcore22 = "$false",
    [string]$stringdotnetcore30 = "$false",

    [string]$stringdemo         = "$false",
    [string]$app_name           = 'App',
    [string]$pool_name          = 'Delta2Red',
    [string]$website_domain     = 'www.red.local',
    [string]$publocation        = 'C:\inetpub\wwwroot\',
    [string]$packagelocation    = 'C:\vagrant\app\app.zip',

    [string]$domain             = 'red.local',
    [string]$domain_user        = 'Administrator',
    [string]$domain_pw          = 'Admin2019',

    [string]$wan_adapter_name   = 'NAT',
    [string]$lan_adapter_name   = 'LAN',
    [string]$local_ip           = '172.18.1.69',
    [int]$lan_prefix            = 27,
    [string]$default_gateway    = '172.18.1.65',
    [string]$primary_dns        = '172.18.1.66',
    [string]$secondary_dns      = '172.18.1.67',


    [string]$stringlinter       = "$false"
)

[boolean]$asp45          = [convert]::ToBoolean($stringasp45)
[boolean]$dotnetcore21   = [convert]::ToBoolean($stringdotnetcore21)
[boolean]$dotnetcore22   = [convert]::ToBoolean($stringdotnetcore22)
[boolean]$dotnetcore30   = [convert]::ToBoolean($stringdotnetcore30)
[boolean]$demo           = [convert]::ToBoolean($stringdemo)
[boolean]$include_linter = [convert]::ToBoolean($stringlinter)

#------------------------------------------------------------------------------
# Variables
#------------------------------------------------------------------------------
$provisioning_scripts="c:\vagrant\provisioning"
$website_name = $app_name


# $app_name = "App"
# $pool_name ="Delta2Red"
# $website_domain = "www.red.local"

# $shared_Path = "$provisioning_scripts\files\App.zip"
# $dotnet_app_deploy_location = "c:\inetpub\wwwroot"
# $dotnet_app_deploy_zip_location = "c:\inetpub\wwwroot\App.zip"
# $dotnet_app_deploy_unzip_location = "c:\inetpub\wwwroot\App"

#------------------------------------------------------------------------------
# Imports
#------------------------------------------------------------------------------
. "$provisioning_scripts\util.ps1"

#------------------------------------------------------------------------------
# Show parameter values
#------------------------------------------------------------------------------
debug "downloadpath = $downloadpath"

debug "iisusername = $iisusername"
debug "iispassword = $iispassword"

debug "stringasp45 = $stringasp45"
debug "stringdotnetcore21 = $stringdotnetcore21"
debug "stringdotnetcore22 = $stringdotnetcore22"
debug "stringdotnetcore30 = $stringdotnetcore30"
debug "stringdemo = $stringdemo"

debug "asp45 = $asp45"
debug "dotnetcore21 = $dotnetcore21"
debug "dotnetcore22 = $dotnetcore22"
debug "dotnetcore30 = $dotnetcore30"
debug "demo = $demo"
debug "publocation = $publocation"
debug "packagelocation = $packagelocation"

debug "domain = $domain"
debug "domain = $domain_user"
debug "domain = $domain_pw"

debug "include_linter = $include_linter"

#------------------------------------------------------------------------------
# Run Powershell Linter
#------------------------------------------------------------------------------
if ($include_linter) {
    if ($PSVersionTable.PSVersion -gt 5.1.17763.592) {
        Install-PackageProvider Nuget -MinimumVersion 2.8.5.201 -Force
    }
    Install-Module -Name PSScriptAnalyzer -Force
}

#------------------------------------------------------------------------------
# Configure adapters
#------------------------------------------------------------------------------
# Changing adapter names depending if used by Vagrant(2 adapters)
# or directly in Virtualbox(1 adapter)
debug "Changing adapter names"
$adaptercount=(Get-NetAdapter | measure).count
if ($adaptercount -eq 1) {
    (Get-NetAdapter -Name "Ethernet") | Rename-NetAdapter -NewName $lan_adapter_name
} 
elseif ($adaptercount -eq 2) {
    (Get-NetAdapter -Name "Ethernet") | Rename-NetAdapter -NewName $wan_adapter_name
    (Get-NetAdapter -Name "Ethernet 2") | Rename-NetAdapter -NewName $lan_adapter_name
}

# Set static IP address on LAN interface
$existing_ip=(Get-NetAdapter -Name $lan_adapter_name | Get-NetIPAddress -AddressFamily IPv4).IPAddress
if ("$existing_ip" -ne "$local_ip") {
    debug "Setting static IP address on adapter $lan_adapter_name to $local_ip with default_gateway $default_gateway"
    New-NetIPAddress -InterfaceAlias "$lan_adapter_name" -IPAddress "$local_ip" -PrefixLength $lan_prefix -DefaultGateway "$default_gateway"
}

# Set DNS of LAN adapter
debug "Settings DNS of adapter $lan_adapter_name to $primary_dns and $secondary_dns"
Set-DnsClientServerAddress -InterfaceAlias "$lan_adapter_name" -ServerAddresses($primary_dns,$secondary_dns)

#------------------------------------------------------------------------------
# Configuring local Administrator account 
#------------------------------------------------------------------------------
# Set default password
debug "Setting default Administrator password"
$local_admin_pw = ConvertTo-SecureString "Admin2019" -asPlainText -force

# Configure Administrator account
debug "Configuring local Administrator account"
Set-LocalUser -Name Administrator -AccountNeverExpires -Password $local_admin_pw -PasswordNeverExpires:$true -UserMayChangePassword:$true

#------------------------------------------------------------------------------
# Provision server
#------------------------------------------------------------------------------
# Ensure download path for installation files exists
ensure_download_path $downloadpath

# Install + configure IIS
install_iis

# Download + install webdeploy
install_webdeploy $downloadpath

############################################################################
### To install .NET Framework on Windows 2019 refer to the documentation ###
############################################################################

if ($asp45) {
    install_asp_dotnet_45
}

if ($dotnetcore21) {
    install_asp_dotnet_core_21 $downloadpath
}

if ($dotnetcore22) {
    install_asp_dotnet_core_22 $downloadpath
}

if ($dotnetcore30) {
    install_asp_dotnet_core_30 $downloadpath
}

# TODO: test
configure_iis $iisusername $iispassword
 

# Deploy  demo
if ($demo) {
    # CopyPaste $shared_Path $dotnet_app_deploy_location
    # unzip $dotnet_app_deploy_zip_location $dotnet_app_deploy_unzip_location

    # TODO: implement
    # deploy_app $publocation $packagelocation

    # create_App_Pool $NamePool
    create_App_Pool $pool_name

    # create_Site $dotnet_app_deploy_unzip_location $NamePool
    create_site $app_name $publocation $website_domain $pool_name

    # TODO: test
    fix_ssl $website_name $website_domain
}

# Join the domain
join_domain $domain $domain_user $domain_pw
