# Installatiescript dat de configuratie doet van de DNS (primary forward en reversed lookup zones maken + Forwarder):
# Elke stap wordt uitgelegd met zijn eigen comment

# VARIABLES:
$VBOXdrive = "Z:"

#----Servers in Red domein hun ipadressen:
  $Bravo2IP = "172.18.1.67" # DC2 / DNS2
  $Charlie2IP = "172.18.1.68" # Exchange Server
  $Delta2IP = "172.18.1.69" # IIS Webserver
  $Kilo2IP = "172.18.1.1" # DHCP Server
  $Lima2IP = "172.18.1.2" # File Server
  $Mike2IP = "172.18.1.3" # Intranet Sharepoint Server
  $November2IP = "172.18.1.4" # SQL Server
  $Oscar2IP = "172.18.1.5" # Monitoring Server
  $Papa2IP = "172.18.1.6" # SCCM Server


# PREFERENCE VARIABLES: (Om Debug,Verbose en informaation info in de Start-Transcript log files te zien)
$DebugPreference = "Continue"
$VerbosePreference = "Continue"
$InformationPreference = "Continue"

# LOG SCRIPT TO FILE (+ op het einde van het script Stop-Transcript doen):
Start-Transcript "C:\ScriptLogs\3_ConfigDCDNSlog.txt"
Write-Host "Waiting 30 seconds before starting script:" -ForeGroundColor "Green"
Start-Sleep -s 30

# 7.1) Check domaincontroller informatie en forest
Get-ADDomainController 
Get-ADTrust –Filter  *
# 8) Repliceren van Alfa2
Get-DnsServerZone -ComputerName "Alfa2.red.local" | where {("Primary" -eq $.ZoneType) | %{ $ | Add-DnsServerSecondaryZone -MasterServers 172.18.1.66 -ZoneFile "$($_.ZoneName).dns"}

# DNS Check
Test-DnsServer -IPAddress 172.18.1.67 -Context RootHint

