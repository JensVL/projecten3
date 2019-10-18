# Installatiescript dat de configuratie doet van de DNS (primary forward en reversed lookup zones maken + Forwarder):

# VARIABLES:
$VBOXdrive = "Z:"
$Bravo2IP = "172.18.1.67" # DC2

# PREFERENCE VARIABLES: (Om Debug, Verbose en Information info in de Start-Transcript log files te kunnen bekijken)
$DebugPreference = "Continue"
$VerbosePreference = "Continue"
$InformationPreference = "Continue"

# LOG SCRIPT TO FILE:
Start-Transcript "C:\ScriptLogs\3_ConfigDCDNSlog.txt"
Write-Host "Waiting 30 seconds before starting script:" -ForeGroundColor "Green"
Start-Sleep -s 30

# 7.1) Check domaincontroller informatie en forest
Get-ADDomainController 
Get-ADTrust –Filter  *

# Replicatie DNS niet nodig de A records werden automatisch gerepliceerd van Alfa2 naar BRavo2

# DNS Check
Test-DnsServer -IPAddress $Bravo2IP -Context RootHints

Stop-Transcript

