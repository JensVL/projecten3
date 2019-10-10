# Provisioning script for delta2

#------------------------------------------------------------------------------
# Parameters
#------------------------------------------------------------------------------
Param(
    [string]$downloadpath       = "C:\SetupMedia",

    [string]$iisusername        = "vagrant",
    [string]$iispassword        = "vagrant",

    [string]$stringasp35        = "$false",
    [string]$stringasp45        = "$false",
    [string]$stringdotnetcore21 = "$false",
    [string]$stringdotnetcore22 = "$false",
    [string]$stringdotnetcore30 = "$false",

    [string]$stringdemo         = "$false",
    [string]$publocation        = "C:\inetpub\wwwroot\",
    [string]$packagelocation    = 'C:\vagrant\app\app.zip',
    [string]$include_linter     = "$false"
)

[boolean]$asp35        = [convert]::ToBoolean($stringasp35)
[boolean]$asp45        = [convert]::ToBoolean($stringasp45)
[boolean]$dotnetcore21 = [convert]::ToBoolean($stringdotnetcore21)
[boolean]$dotnetcore22 = [convert]::ToBoolean($stringdotnetcore22)
[boolean]$dotnetcore30 = [convert]::ToBoolean($stringdotnetcore30)
[boolean]$demo         = [convert]::ToBoolean($stringdemo)

#------------------------------------------------------------------------------
# Variables
#------------------------------------------------------------------------------
$provisioning_scripts="c:\vagrant\provisioning"
$shared_Path = "c:\vagrant\provisioning\files\App.zip"
$dotnet_app_deploy_location = "c:\inetpub\wwwroot"
$dotnet_app_deploy_zip_location = "c:\inetpub\wwwroot\App.zip"
$dotnet_app_deploy_unzip_location = "c:\inetpub\wwwroot\App"
$NamePool ="Delta2Red"

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

debug "stringasp35 = $stringasp35"
debug "stringasp45 = $stringasp45"
debug "stringdotnetcore21 = $stringdotnetcore21"
debug "stringdotnetcore22 = $stringdotnetcore22"
debug "stringdotnetcore30 = $stringdotnetcore30"
debug "stringdemo = $stringdemo"

debug "asp35 = $asp35"
debug "asp45 = $asp45"
debug "dotnetcore21 = $dotnetcore21"
debug "dotnetcore22 = $dotnetcore22"
debug "dotnetcore30 = $dotnetcore30"
debug "demo = $demo"
debug "publocation = $publocation"
debug "packagelocation = $packagelocation"


#------------------------------------------------------------------------------
# Run Powershell Linter
#------------------------------------------------------------------------------
if ($include_linter) {
    if ($PSVersionTable.PSVersion -gt 5.1.17763.592) {
        Install-PackageProvider Nuget -MinimumVersion 2.8.5.201 –Force
    }
    Install-Module -Name PSScriptAnalyzer
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

### update:26-09-2019: offline installer not working on windows 2019
### method via DISM with the iso might work but will omit this for now
# if ($asp35) {
# }

if ($asp45) {
    install_asp_dotnet_45
}

if($dotnetcore21){
    install_asp_dotnet_core_21 $downloadpath
}

if($dotnetcore22){
    install_asp_dotnet_core_22 $downloadpath
}

if($dotnetcore30){
    install_asp_dotnet_core_30 $downloadpath
}

# # TODO: Configure website on IIS
 configure_iis $iisusername $iispassword
 
#To Do test underlying functionss

# TODO
# Deploy  demo
if($demo){
    # deploy_app $publocation $packagelocation
    CopyPaste $shared_Path $dotnet_app_deploy_location
    unzip $dotnet_app_deploy_zip_location $dotnet_app_deploy_unzip_location
    create_App_Pool $NamePool
    create_Site $dotnet_app_deploy_unzip_location $NamePool
}

### perhaps we don't need this as the script is executed by the root user
### will test this
# # changes unzipped file ExecutionPolicy
# Set-ExecutionPolicy RemoteSigned

# # Download SSL cmdlets for certificate generation
# TODO: download script on host and include it in the provisioning files
# for if the link is unreachable
# download_ssl_cmdlets $downloadpath

# # Generate SSL certificate
# TODO: test
# configure_certs $downloadpath $website




