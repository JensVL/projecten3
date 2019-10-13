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

# 1) Stel forward primary lookup zones in voor alle servers in het red domein:
# TODO: Checken of DC2 / DNS2 automatisch een NS record heeft (voor replicatie TransferToZoneNameServer) TODO TODO TODO TODO
Write-host "Adding DNS primary zone for red.local" -ForeGroundColor "Green"
Add-DnsServerPrimaryZone -Name "red.local" -ReplicationScope "Domain" -DynamicUpdate "Secure"
Set-DnsServerPrimaryZone -Name "red.local" -SecureSecondaries "TransferToZoneNameServer"

# 2) Voeg de servers als AAAA records toe met hun ip adres in de aangemaakte primary zone: (name to ip address)
# LET OP: Charlie2 Exchange (mail) server = MX record ipv AAAA record
# en Bravo2 DC2 = NS record (NS record niet zelf aanmaken gebeurd automatisch volgens AD-integration zones)
# MX record -MailExchange option moet pointen naar bestaande A record (Zie -Mail Exchange optie Microsoft docs Add-DnsServerResourceRecordMX)
Write-host "Adding DNS A and MX records for the servers of red.local" -ForeGroundColor "Green"

# TODO CHECKEN OF DIT KLOPT MET MX RECORD (geen ip adres in dns manager bij charlie2????) TODO TODO TODO
Add-DnsServerResourceRecordA -Name "Charlie2" -ZoneName "red.local" -IPv4Address "$Charlie2IP"
Add-DnsServerResourceRecordMX -Name "." -MailExchange "Charlie2.red.local" -ZoneName "red.local" -Peference 100

Add-DnsServerResourceRecordA -Name "Delta2" -ZoneName "red.local" -IPv4Address "$Delta2IP"
Add-DnsServerResourceRecordA -Name "Kilo2" -ZoneName "red.local" -IPv4Address "$Kilo2IP"
Add-DnsServerResourceRecordA -Name "Lima2" -ZoneName "red.local" -IPv4Address "$Lima2IP"
Add-DnsServerResourceRecordA -Name "Mike2" -ZoneName "red.local" -IPv4Address "$Mike2IP"
Add-DnsServerResourceRecordA -Name "November2" -ZoneName "red.local" -IPv4Address "$November2IP"
Add-DnsServerResourceRecordA -Name "Oscar2" -ZoneName "red.local" -IPv4Address "$Oscar2IP"
Add-DnsServerResourceRecordA -Name "Papa2" -ZoneName "red.local" -IPv4Address "$Papa2IP"

# 3) DNS forwarders instellen op de Hogent DNS servers:         TODO DNS FORWARDERS MOETEN OF NIET??????????????????????????????
Write-host "Adding Hogent DNS servers as DNS forwarders:" -ForeGroundColor "Green"
Add-DnsServerForwarder -IpAddress "193.190.173.1","193.190.173.2"

# 4) Start het 4_ADstructure.ps1 script als Administrator:
Write-host "Running next script 4_ADSTRUCTUR.ps1 as admin:" -ForeGroundColor "Green"
Start-Process powershell -Verb runAs -ArgumentList "$VBOXdrive\4_ADstructure.ps1"

# TODO: Na configuratie DNS testen met nslookup

# TODO Eventueel vragen aan Bravo2 om secondary zones aan te maken van mijn zone(s)

Stop-Transcript
