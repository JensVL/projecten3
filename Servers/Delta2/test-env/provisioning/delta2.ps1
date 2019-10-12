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

    [string]$include_linter     = "$false"
)

[boolean]$asp45        = [convert]::ToBoolean($stringasp45)
[boolean]$dotnetcore21 = [convert]::ToBoolean($stringdotnetcore21)
[boolean]$dotnetcore22 = [convert]::ToBoolean($stringdotnetcore22)
[boolean]$dotnetcore30 = [convert]::ToBoolean($stringdotnetcore30)
[boolean]$demo         = [convert]::ToBoolean($stringdemo)

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
