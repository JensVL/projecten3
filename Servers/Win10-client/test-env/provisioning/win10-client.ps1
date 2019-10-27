# Provisioning script for delta2

#------------------------------------------------------------------------------
# Parameters
#------------------------------------------------------------------------------
Param(
    [string]$downloadpath       = 'C:\SetupMedia'

#     [string]$include_linter     = "$false"
)

#------------------------------------------------------------------------------
# Variables
#------------------------------------------------------------------------------
$provisioning_scripts="c:\vagrant\provisioning"

#------------------------------------------------------------------------------
# Imports
#------------------------------------------------------------------------------
. "$provisioning_scripts\util.ps1"

#------------------------------------------------------------------------------
# Show parameter values
#------------------------------------------------------------------------------
debug "downloadpath = $downloadpath"
# debug "include_linter = $include_linter"

#------------------------------------------------------------------------------
# Run Powershell Linter
#------------------------------------------------------------------------------
# if ($include_linter) {
#     if ($PSVersionTable.PSVersion -gt 5.1.17763.592) {
#         Install-PackageProvider Nuget -MinimumVersion 2.8.5.201 -Force
#     }
#     Install-Module -Name PSScriptAnalyzer -Force
# }

#------------------------------------------------------------------------------
# Provision server
#------------------------------------------------------------------------------
# Ensure download path for installation files exists
ensure_download_path $downloadpath

debug 'Setting DNS to Alfa2'
$domaincontrollerip='172.18.1.66'
Set-DnsClientServerAddress -InterfaceAlias "Ethernet 2" -ServerAddresses $domaincontrollerip

$strUser = "RED\Administrator"
$strDomain = "red.local"
$strPassword = ConvertTo-SecureString "Admin2019" -AsPlainText -Force
$Credentials = New-Object System.Management.Automation.PsCredential($strUser,$strPassword)

debug "Joining domain $strDomain"
Add-computer -DomainName $strDomain -Credential $Credentials
