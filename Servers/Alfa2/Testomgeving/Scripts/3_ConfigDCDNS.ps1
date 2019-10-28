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
    [string]$Charlie2IP  = "172.18.1.68", # Exchange Server
    [string]$Delta2IP    = "172.18.1.69", # IIS Webserver
    [string]$Kilo2IP     = "172.18.1.1", # DHCP Server
    [string]$Lima2IP     = "172.18.1.2", # File Server
    [string]$Mike2IP     = "172.18.1.3", # Intranet Sharepoint Server
    [string]$November2IP = "172.18.1.4", # SQL Server
    [string]$Oscar2IP    = "172.18.1.5", # Monitoring Server
    [string]$Papa2IP     = "172.18.1.6", # SCCM Server
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

# Stel forward primary lookup zones in voor alle servers in het red domein:
Write-host "Setting DNS primary zone for red.local" -ForeGroundColor "Green"
Set-DnsServerPrimaryZone -Name "red.local" -SecureSecondaries "TransferToZoneNameServer"

# Voeg de servers als AAAA records toe met hun ip adres 
#   in de aangemaakte primary zone: (name to ip address)
# NOTE: Charlie2 Exchange (mail) server = MX record ipv AAAA record
#   en Bravo2 DC2 = NS record (NS record niet zelf aanmaken gebeurd
#   automatisch volgens AD-integration zones)
# NOTE: MX record -MailExchange option moet pointen naar 
#   bestaande A record
#   (Zie -Mail Exchange optie Microsoft docs Add-DnsServerResourceRecordMX)
Write-host "Adding DNS A and MX records for the servers of red.local" -ForeGroundColor "Green"

function add_dns_record() {
    param(
        [string]$record_name,
        [string]$record_zone_name,
        [string]$record_type,
        [string]$ipaddress,
        # [string]$record_mx_name,
        # [string]$record_cname_name,
        [string]$record_mail_exchange,
        [int]$record_preference,
        [string]$record_hostname_alias
    )

    # TODO: test with and without "2> $null"
    $record_exists=(Get-DnsServerResourceRecord -Name $record_name -RRType $record_type -ZoneName $record_zone_name 2> $null)

    if(!$record_exists) {
        # make record
        if($record_type -eq "MX") {
            Add-DnsServerResourceRecordMX -Name $record_name -ZoneName $record_zone_name -MailExchange $record_mail_exchange -Preference $record_preference
        }
        elseif ($record_type -eq "CNAME") {
            Add-DnsServerResourceRecordCName -Name $record_name -ZoneName $record_zone_name -HostNameAlias $record_hostname_alias
        }
        elseif ($record_type -eq "A") {
            Add-DnsServerResourceRecordA -Name $record_name -ZoneName $record_zone_name -IPv4Address $ipaddress
        }
    }
    else {
        Write-Warning "Record $record_name already exists (skipping)"
    }

}

add_dns_record -record_name "mail" -record_zone_name "red.local" -record_type "A" -ipaddress $Charlie2IP
add_dns_record -record_name "mail" -record_zone_name "red.local" -record_type "MX" -record_mail_exchange "mail.red.local" -record_preference 100
add_dns_record -record_name "owa" -record_zone_name "red.local" -record_type "CNAME" -record_hostname_alias "mail.red.local"

add_dns_record -record_name "Delta2" -record_zone_name "red.local" -record_type "A" -ipaddress $Delta2IP
add_dns_record -record_name "Kilo2" -record_zone_name "red.local" -record_type "A" -ipaddress $Kilo2IP
add_dns_record -record_name "Lima2" -record_zone_name "red.local" -record_type "A" -ipaddress $Lima2IP
add_dns_record -record_name "Mike2" -record_zone_name "red.local" -record_type "A" -ipaddress $Mike2IP
add_dns_record -record_name "November2" -record_zone_name "red.local" -record_type "A" -ipaddress $November2IP
add_dns_record -record_name "Oscar2" -record_zone_name "red.local" -record_type "A" -ipaddress $Oscar2IP
add_dns_record -record_name "Papa2" -record_zone_name "red.local" -record_type "A" -ipaddress $Papa2IP

# Add-DnsServerResourceRecordA -Name "mail" -ZoneName "red.local" -IPv4Address "$Charlie2IP"
# Add-DnsServerResourceRecordMX -Name "mail" -MailExchange "mail.red.local" -ZoneName "red.local" -Preference 100
# Add-DnsServerResourceRecordCName -Name "owa" -HostNameAlias "mail.red.local" -ZoneName "red.local"

# Add-DnsServerResourceRecordA -Name "Delta2" -ZoneName "red.local" -IPv4Address "$Delta2IP"
# Add-DnsServerResourceRecordA -Name "Kilo2" -ZoneName "red.local" -IPv4Address "$Kilo2IP"
# Add-DnsServerResourceRecordA -Name "Lima2" -ZoneName "red.local" -IPv4Address "$Lima2IP"
# Add-DnsServerResourceRecordA -Name "Mike2" -ZoneName "red.local" -IPv4Address "$Mike2IP"
# Add-DnsServerResourceRecordA -Name "November2" -ZoneName "red.local" -IPv4Address "$November2IP"
# Add-DnsServerResourceRecordA -Name "Oscar2" -ZoneName "red.local" -IPv4Address "$Oscar2IP"
# Add-DnsServerResourceRecordA -Name "Papa2" -ZoneName "red.local" -IPv4Address "$Papa2IP"

# Firewall uitzetten (want we gebruiken hardware firewall):
# Write-Host "Turning firewall off:" -ForeGroundColor "Green"
# Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False

# 5) Start het 4_ADstructure.ps1 script als Administrator:
# Write-host "Running next script 4_ADSTRUCTURE.ps1 as admin:" -ForeGroundColor "Green"
# Start-Process powershell -Verb runAs -ArgumentList "$VBOXdrive\4_ADstructure.ps1"

# Stop-Transcript
