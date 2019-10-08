# Installatiescript dat de configuratie doet van de DNS (primary forward en reversed lookup zones maken + Forwarder):
# Elke stap wordt uitgelegd met zijn eigen comment

# VARIABLES:
$VBOXdrive = "Z:"

#----Servers in Red domein hun ipadressen:
  $Bravo2IP = "172.18.1.67" # DC2 / DNS2      -----------------------(TODO: DNS MOET NS RECORD HEBBEN GEEN AAAA RECORD)
  $Charlie2IP = "172.18.1.68" # Exchange Server --------------------- TODO: MAIL SERVER IS MX RECORD GEEN AAAA RECORD!)
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

# 1) Stel forward primary lookup zones in voor alle servers in het red domein:
Add-DnsServerPrimaryZone -Name "red.local" -ReplicationScope "Domain" -DynamicUpdate "Secure"

# 2) Voeg de servers als AAAA records toe met hun ip adres in de aangemaakte primary zone: (name to ip address)
# LET OP: Charlie2 Exchange (mail) server = MX record ipv AAAA record en Bravo2 DC2 = NS record
# TODO Bravo2 en Charlie2 toevoegen als MX en NS record
Add-DnsServerResourceRecordA -Name "Delta2" -ZoneName "red.local" -IPv4Address "$Delta2IP" -CreatePtr
Add-DnsServerResourceRecordA -Name "Kilo2" -ZoneName "red.local" -IPv4Address "$Kilo2IP" -CreatePtr
Add-DnsServerResourceRecordA -Name "Lima2" -ZoneName "red.local" -IPv4Address "$Lima2IP" -CreatePtr
Add-DnsServerResourceRecordA -Name "Mike2" -ZoneName "red.local" -IPv4Address "$Mike2IP" -CreatePtr
Add-DnsServerResourceRecordA -Name "November2" -ZoneName "red.local" -IPv4Address "$November2IP" -CreatePtr
Add-DnsServerResourceRecordA -Name "Oscar2" -ZoneName "red.local" -IPv4Address "$Oscar2IP" -CreatePtr
Add-DnsServerResourceRecordA -Name "Papa2" -ZoneName "red.local" -IPv4Address "$Papa2IP" -CreatePtr

# 3) DNS reverse lookup zone maken (IP address to domain name):
# 172.18.1.66 / 27 => Network portion: 172.18.1.64
# TODO: MAG WSS WEG reverse lookup zone enkel voor als je subdomains hebt in andere subnets (wij hebben maar 1 domain = red.local)
Add-DnsServerPrimaryZone -ReplicationScope "Domain" -DynamicUpdate "Secure" -NetworkID "172.18.1.64/27"

# Voeg de servers van het red domain toe als PTR records in de reverse lookup zone:
# TODO: MAG WSS WEG reverse lookup zone enkel voor als je subdomains hebt in andere subnets (wij hebben maar 1 domain = red.local)
Add-DnsServerResourceRecordPtr -Name "Delta2" -ZoneName "1.18.172.in-addr.arpa" -AllowUpdateAny --PtrDomainName "Delta2.contoso.com"

# 3) DNS forwarders instellen op de Hogent DNS servers:          DNS FORWARDERS MOETEN OF NIET??????????????????????????????
Add-DnsServerForwarder -IpAddress "193.190.173.1","193.190.173.2"

# TODO: Na configuratie DNS testen met nslookup

# Eventueel vragen aan Bravo2 om secondary zones aan te maken van mijn zone(s)

Stop-Transcript
