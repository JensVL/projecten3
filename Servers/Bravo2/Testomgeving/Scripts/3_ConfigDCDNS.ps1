# Installatiescript dat de configuratie doet van de DNS (primary forward en reversed lookup zones maken + Forwarder):

# VARIABLES:
$VBOXdrive = "Z:"
$Bravo2IP = "172.18.1.67" # DC2

# PREFERENCE VARIABLES: (Om Debug, Verbose en Information info in de Start-Transcript log files te kunnen bekijken)
# $DebugPreference = "Continue"
# $VerbosePreference = "Continue"
# $InformationPreference = "Continue"

# LOG SCRIPT TO FILE:
# Start-Transcript "C:\ScriptLogs\3_ConfigDCDNSlog.txt"
Write-Host "Waiting 30 seconds before starting script:" -ForeGroundColor "Green"
Start-Sleep -s 30


# Firewall uitzetten (want we gebruiken hardware firewall):
 Write-Host "Turning firewall off:" -ForeGroundColor "Green"
 Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False

# DNS forwarder instellen op Hogent DNS servers:
Add-DnsServerForwarder -IPAddress 193.190.173.1,193.190.173.2

#Check domaincontroller informatie en forest
Get-ADDomainController 
Get-ADTrust -Filter  *

# Replicatie DNS niet nodig de A records werden automatisch gerepliceerd van Alfa2 naar BRavo2

# DNS Check
Test-DnsServer -IPAddress $Bravo2IP -Context RootHints

# Stop-Transcript
