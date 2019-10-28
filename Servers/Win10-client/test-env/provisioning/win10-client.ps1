# Provisioning script for delta2

#------------------------------------------------------------------------------
# Parameters
#------------------------------------------------------------------------------
Param(
    [string]$downloadpath  = "C:\SetupMedia",
    [string]$primary_dns   = "172.18.1.66",
    [string]$secondary_dns = "172.18.1.67",
    [string]$domain        = "red.local",
    [string]$domain_user   = "RED\Administrator",
    [string]$domain_pw     = "Administrator2019"

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
# $primaryDNS='172.18.1.66'
# $secondaryDNS='172.18.1.67'
Set-DnsClientServerAddress -InterfaceAlias "Ethernet 2" -ServerAddresses ($primary_dns, $secondary_dns)

# $strUser = "RED\Administrator"
# $strDomain = "red.local"
$secure_domain_pw = ConvertTo-SecureString $domain_pw -AsPlainText -Force
$credentials = New-Object System.Management.Automation.PsCredential($domain_user,$secure_domain_pw)

debug "Joining domain $domain"
Add-computer -DomainName $domain -DomainCredential $credentials -Verbose
