#------------------------------------------------------------------------------
# Description
#------------------------------------------------------------------------------
# Installatiescript dat zorgt voor de initiële configuratie
# en de installatie van de ADDS role

#------------------------------------------------------------------------------
# Variables
#------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------
# VOOR INTEGRATIE:
$VBOXdrive = "C:\Scripts_ESXI\Alfa2"

# VOOR VIRTUALBOX TESTING:
#$VBOXdrive = "Z:"
# --------------------------------------------------------------------------------------------------------
    [string]$land             = "eng-BE"
    [string]$local_ip         = "172.18.1.66"
    [string]$secondary_dc_ip  = "172.18.1.67"
    [string]$default_gateway  = "172.18.1.65"
    [string]$lan_prefix       = "27"
    [string]$domain           = "red.local"
    [string]$wan_adapter_name = "NAT"
    [string]$lan_adapter_name = "LAN"

$username = "RED\Administrator"
$password = "Admin2019"

#------------------------------------------------------------------------------
# Initial config
#------------------------------------------------------------------------------
Start-Transcript "C:\ScriptLogs\2_InstallDCDNS.txt"


# Romance standard time = Brusselse tijd
# Eerste commando zal tijd naar 24uur formaat instellen
#   (eng zorgt dat taal op engels blijft maar regio komt op BE)
Write-host ">>> Setting correct timezone and time format settings"
Set-Culture -CultureInfo $land
set-timezone -Name "Romance Standard Time"

# NAT = de adapter die met het internet verbinding
# LAN = de adapter met static IP instellingen die alle servers met elkaar verbind.
Write-host ">>> Changing NIC adapter names"
# TODO: conditional that checks if adapter names already exists does
#       not correctly checks for equal strings
$adaptercount=(Get-NetAdapter | measure).count
if ($adaptercount -eq 1) {
    (Get-NetAdapter -Name "Ethernet") | Rename-NetAdapter -NewName $lan_adapter_name
}
elseif ($adaptercount -eq 2) {
    (Get-NetAdapter -Name "Ethernet") | Rename-NetAdapter -NewName $wan_adapter_name
    (Get-NetAdapter -Name "Ethernet 2") | Rename-NetAdapter -NewName $lan_adapter_name
}


# Prefixlength = CIDR notatie van subnet (in ons geval 255.255.255.224)
# Default gateway option stelt deze in op de Layer 3 switch van VLAN 500
Write-host "Setting correct ipv4 adapter settings (including DNS and Default gateway):" -ForeGroundColor "Green"
$existing_ip=(Get-NetAdapter -Name $lan_adapter_name | Get-NetIPAddress -AddressFamily IPv4).IPAddress
if ("$existing_ip" -ne "$local_ip") {
    Write-host ">>> Setting static ipv4 settings"
    New-NetIPAddress -InterfaceAlias "$lan_adapter_name" -IPAddress "$local_ip" -PrefixLength $lan_prefix -DefaultGateway "$default_gateway"
}

# Set DNS of LAN adapter
Write-Host ">>> Settings DNS of adapter $lan_adapter_name"
Set-DnsClientServerAddress -InterfaceAlias "$lan_adapter_name" -ServerAddresses($local_ip,$secondary_dc_ip)

# Set default password
Write-Host ">>> Setting default Administrator password"
$DSRM = ConvertTo-SecureString "Admin2019" -asPlainText -force

# Configure Administrator account
Write-Host ">>> Configuring Administrator account"
Set-LocalUser -Name Administrator -AccountNeverExpires -Password $DSRM -PasswordNeverExpires:$true -UserMayChangePassword:$true

#------------------------------------------------------------------------------
# Install ADDS and promote to first domain controller of forest
#------------------------------------------------------------------------------
# Aanmaken van ons nieuw domain:
#     Forestmode/DomainMode => 7 is = Windows Server 2016 (de oudste Windows Server versie in onze opstelling)
#     DNS role laten aanmaken en DNSdelegation uitzetten om later onze eigen DNS server in te stellen
#     Force forceert negeren van bevestigingen

$is_AD_domainservices_installed=(Get-WindowsFeature AD-Domain-Services).Installed
if ("$is_AD_domainservices_installed" -eq 'False') {
    Write-Host ">>> Installing AD-Domain-Services"
    Install-WindowsFeature AD-Domain-Services
}

$is_RSAT_admincenter_installed=(Get-WindowsFeature RSAT-AD-AdminCenter).Installed
if ("$is_RSAT_admincenter_installed" -eq 'False') {
    Write-Host ">>> Installing RSAT-AD-AdminCenter"
    Install-WindowsFeature RSAT-AD-AdminCenter
}

$is_RSAT_addstools_installed=(Get-WindowsFeature RSAT-ADDS-Tools).Installed
if ("$is_RSAT_addstools_installed" -eq 'False') {
    Write-Host ">>> Installing RSAT-ADDS-Tools"
    Install-WindowsFeature RSAT-ADDS-Tools
}

# Sla doman admin username/password op als credentials en voeg de nodige properties aan de registry toe
# om de sierver de mogelijkheid te geven een reboot te doen en daarna verder te gaan door het script:

#  Voeg het script toe als registry value:
# RunOnce verwijderd deze instelling automatisch nadat het script klaar is met runnen
Set-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce' -Name ResumeScript `
                -Value "C:\Windows\system32\WindowsPowerShell\v1.0\Powershell.exe -executionpolicy bypass -file `"$VBOXdrive\3_ConfigDCDNS.ps1`""

# Registry waardes voor username/password en autologin instellen:
# Deze zorgen ervoor dat het inloggen automatisch gebeurd met de credentials die in het vorige commando verzameld zijn.
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name DefaultUserName -Value $Username
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name DefaultPassword -Value $Password


$domaincontroller_installed=(Get-ADDomainController 2> $null)
if (!"$domaincontroller_installed") {
    Write-Host ">>> Installing AD forest and adding Alfa2 as first DC"
    Import-Module ADDSDeployment

    install-ADDSForest -DomainName $domain `
                  -ForestMode 7 `
                  -DomainMode 7 `
                  -installDns:$true `
                  -createDNSDelegation:$false `
                  -SafeModeAdministratorPassword $DSRM `
                  -force:$true
}

Stop-Transcript
