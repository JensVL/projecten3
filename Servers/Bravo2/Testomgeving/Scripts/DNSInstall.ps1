#------------------------------------------------------------------------------
# Description
#------------------------------------------------------------------------------
# Installatiescript dat zorgt voor de initiële configuratie
# en de installatie van de ADDS role

#------------------------------------------------------------------------------
# Variables
#------------------------------------------------------------------------------
param(
    [string]$land                = "eng-BE",
    [string]$local_ip            = "172.18.1.67",
    [string]$primary_dc_ip       = "172.18.1.66",
    [string]$primary_dc_hostname = "Alfa2",
    [string]$default_gateway     = "172.18.1.65",
    [int]$lan_prefix             = 27,
    [string]$domain              = "red.local",
    [string]$wan_adapter_name    = "NAT",
    [string]$lan_adapter_name    = "LAN"
)


#------------------------------------------------------------------------------
# Initial config
#------------------------------------------------------------------------------
# Romance standard time = Brusselse tijd
# Eerste commando zal tijd naar 24uur formaat instellen
Write-host ">>> Setting correct timezone and time format settings"
Set-Culture -CultureInfo $land
set-timezone -Name "Romance Standard Time"

# NAT = de adapter die met het internet verbinding
# LAN = de adapter met static IP instellingen die alle servers met elkaar verbind.
Write-host ">>> Changing NIC adapter names"
# TODO: conditional that checks if adapter names already exists does
#       not correctly checks for equal strings
# Ethernet0 is omdat op de Exsi server de Ethernet adapter, Ethernet0 heet.
$adaptercount=(Get-NetAdapter | measure).count
if ($adaptercount -eq 1) {
    #(Get-NetAdapter -Name "Ethernet0") | Rename-NetAdapter -NewName $lan_adapter_name
    (Get-NetAdapter -Name "Ethernet") | Rename-NetAdapter -NewName $lan_adapter_name
}


# Prefixlength = CIDR notatie van subnet (in ons geval 255.255.255.224)
$existing_ip=(Get-NetAdapter -Name $lan_adapter_name | Get-NetIPAddress -AddressFamily IPv4).IPAddress
if ("$existing_ip" -ne "$local_ip") {
    Write-host ">>> Setting static ipv4 settings"
    New-NetIPAddress -InterfaceAlias "LAN" -IPAddress $local_ip -PrefixLength $lan_prefix -DefaultGateway $default_gateway
}

# Set DNS of LAN adapter
Write-Host ">>> Settings DNS of adapter $lan_adapter_name"
Set-DnsClientServerAddress -InterfaceAlias "$lan_adapter_name" -ServerAddresses($primary_dc_ip,$local_ip)

# Set default password
Write-Host ">>> Setting default Administrator password"
$DSRM = ConvertTo-SecureString "Admin2019" -asPlainText -force

# Configure Administrator account
Write-Host ">>> Configuring Administrator account"
Set-LocalUser -Name Administrator -AccountNeverExpires -Password $DSRM -PasswordNeverExpires:$true -UserMayChangePassword:$true

# Firewall uitschakelen
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False

# Joinen van domein "red.local":

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

$domaincontroller_installed=(Get-ADDomainController 2> $null)
if (!"$domaincontroller_installed") {
    Write-Host ">>> Installing AD forest and adding Bravo2 as second DC"
    Import-Module ADDSDeployment

    $creds = New-Object System.Management.Automation.PSCredential ("RED\Administrator", (ConvertTo-SecureString "Admin2019" -AsPlainText -Force))
    install-ADDSDomainController -DomainName $domain `
                  -ReplicationSourceDC "$primary_dc_hostname.$domain" `
                  -credential $creds `
                  -installDns:$true `
                  -createDNSDelegation:$false `
                  -NoRebootOnCompletion:$true `
                  -SafeModeAdministratorPassword $DSRM `
                  -force:$true
}
Restart-Computer -Force
