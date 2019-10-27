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
# pwd
# ls /vagrant/provision

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


