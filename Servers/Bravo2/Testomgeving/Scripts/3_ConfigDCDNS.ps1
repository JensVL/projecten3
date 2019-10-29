#------------------------------------------------------------------------------
# Description
#------------------------------------------------------------------------------
# Installatiescript dat de configuratie doet van de DNS
#   (primary forward en reversed lookup zones maken + Forwarder)

#------------------------------------------------------------------------------
# Variables
#------------------------------------------------------------------------------
param(
    [string]$Bravo2IP    = "172.18.1.67", # DC2 / DNS2
    [string]$wan_adapter_name = "NAT"
)

#------------------------------------------------------------------------------
# Wait for AD services to become available
#------------------------------------------------------------------------------
while ($true) {
    try {
        Get-ADDomain | Out-Null
        break
    } catch {
        Start-Sleep -Seconds 10
    }
}

#------------------------------------------------------------------------------
# Configure DNS
#------------------------------------------------------------------------------
# Fix adapters
Set-DnsClientServerAddress -InterfaceAlias $wan_adapter_name -ResetServerAddresses

# Firewall uitzetten (want we gebruiken hardware firewall):
# Write-Host ">>> Turning firewall off"
# Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False

# DNS forwarder instellen op Hogent DNS servers:
Write-Host ">>> Set DNS forwarder to HoGent DNS"
Add-DnsServerForwarder -IPAddress 193.190.173.1,193.190.173.2

# Check domaincontroller informatie en forest
# Get-ADDomainController 
# Get-ADTrust -Filter  *

# DNS Check
# Test-DnsServer -IPAddress $Bravo2IP -Context RootHints
