#------------------------------------------------------------------------------
# Description
#------------------------------------------------------------------------------
# Installatiescript dat zorgt voor de initiële configuratie
# en de installatie van de ADDS role

#------------------------------------------------------------------------------
# Variables
#------------------------------------------------------------------------------
param(
    [string]$land             = "eng-BE",
    [string]$local_ip         = "172.18.1.66",
    [string]$default_gateway  = "172.18.1.65",
    [string]$lan_prefix       = "27",
    [string]$lan_adapter_name = "LAN"
)


#------------------------------------------------------------------------------
# Initial config
#------------------------------------------------------------------------------
# Romance standard time = Brusselse tijd
# Eerste commando zal tijd naar 24uur formaat instellen
#   (eng zorgt dat taal op engels blijft maar regio komt op BE)
Write-host ">>> Setting correct timezone and time format settings"
Set-Culture -CultureInfo $land
set-timezone -Name "Romance Standard Time"

# NAT = de adapter die met het internet verbinding
# LAN = de adapter met static IP instellingen die alle servers met elkaar verbind.
Write-host "Changing NIC adapter names"

Rename-NetAdapter -Name "Ethernet 2" -NewName $lan_adapter_name

# 3) Geef de LAN adapter de correcte IP instellingen volgens de opdracht:
# Prefixlength = CIDR notatie van subnet (in ons geval 255.255.255.224)
# Default gateway option stelt deze in op de Layer 3 switch van VLAN 500
Write-host "Setting correct ipv4 adapter settings (including DNS and Default gateway):" -ForeGroundColor "Green"
$existing_ip=(Get-NetAdapter -Name $lan_adapter_name | Get-NetIPAddress -AddressFamily IPv4).IPAddress

if("$existing_ip" -ne "$local_ip") {
    Write-host "Setting correct ipv4 settings:" -ForeGroundColor "Green"
    New-NetIPAddress -InterfaceAlias "$lan_adapter_name" -IPAddress "$local_ip" -PrefixLength $lan_prefix -DefaultGateway "$default_gateway"
}

# DNS van LAN van Alfa2 instellen op Hogent DNS servers:
# Eventueel commenten tijdens testen in demo omgeving
Set-DnsClientServerAddress -InterfaceAlias "$lan_adapter_name" -ServerAddress "172.18.1.66","172.18.1.67"

# Installeer de Active Directory Domain Services role om van de server een DC te kunnen maken:

# Set default password
$DSRM = ConvertTo-SecureString "Admin2019" -asPlainText -force

# Configure Administrator account
Set-LocalUser -Name Administrator -AccountNeverExpires -Password $DSRM -PasswordNeverExpires:$true -UserMayChangePassword:$true

# 6.2) Vanaf dat ik met red/administrator was ingelogd had ik het probleem dat ik geen permissie had om de netwerkadapters te wijzigen.
# De oplossing hiervoor is in gpedit.msc "User Account Control: Admin approval mode for the builtin Administrator account" te ENABLEN
# Dit doe je in powershell met volgende command die de juiste registry instelling zal wijzigen:
# De eerste command zorgt ervoor dat je je als admin niet steeds moet inloggen wanneer je wijzigingen wil doen:
# set-itemproperty -Path "REGISTRY::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System" `
#                 -name "ConsentPromptBehaviorAdmin" -value 0
# Set-ItemProperty -Path "REGISTRY::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System" `
#                 -Name "FilterAdministratorToken" -value 1

#------------------------------------------------------------------------------
# Install ADDS and promote to first domain controller of forest
#------------------------------------------------------------------------------
# 7) Aanmaken van ons nieuw domain:
#     Forestmode/DomainMode => 7 is = Windows Server 2016 (de oudste Windows Server versie in onze opstelling)
#     DNS role laten aanmaken en DNSdelegation uitzetten om later onze eigen DNS server in te stellen
#     Force forceert negeren van bevestigingen

$is_AD_domainservices_installed=(Get-WindowsFeature AD-Domain-Services).Installed
if ("$is_AD_domainservices_installed" -eq 'False') {
    Write-Host 'Installing AD-Domain-Services'
    Install-WindowsFeature AD-Domain-Services
}

$is_RSAT_admincenter_installed=(Get-WindowsFeature RSAT-AD-AdminCenter).Installed
if ("$is_RSAT_admincenter_installed" -eq 'False') {
    Write-Host 'Installing RSAT-AD-AdminCenter'
    Install-WindowsFeature RSAT-AD-AdminCenter
}

$is_RSAT_addstools_installed=(Get-WindowsFeature RSAT-ADDS-Tools).Installed
if ("$is_RSAT_addstools_installed" -eq 'False') {
    Write-Host 'Installing RSAT-ADDS-Tools'
    Install-WindowsFeature RSAT-ADDS-Tools
}

$domaincontroller_installed=nltest.exe /dsgetdc:$domain 2> $null
if (!"$domaincontroller_installed") {
    Write-Host 'Installing AD forest and adding Alfa2 as first DC'
    Import-Module ADDSDeployment

    install-ADDSForest -DomainName "red.local" `
                  -ForestMode 7 `
                  -DomainMode 7 `
                  -installDns:$true `
                  -createDNSDelegation:$false `
                  -NoRebootOnCompletion:$true `
                  -SafeModeAdministratorPassword $DSRM `
                  -force:$true

}
# Stop-Transcript
