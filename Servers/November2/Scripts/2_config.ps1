param(
     [string]$ip               = "172.18.1.4",
     [string]$defaultgateway   = "172.18.1.1",
     [int]$prefix              = 26,
     [string]$ipalfa           = "172.18.1.66",
     [string]$ipbravo          = "172.18.1.67",
     [string]$domain           = "red.local",
     [string]$domain_user      = "Administrator",
     [string]$domain_password  = "Admin2019",
     [string]$domain_netbios   = "RED",
     [string]$wan_adapter_name = "NAT",
     [string]$lan_adapter_name = "LAN"
)

Write-Host 'Setting IP configuration'
# IP config
# NOTE: The variables below are declared as parameters at the top of the script
# $ip = "172.18.1.4"
# $defaultgateway = "172.18.1.1"
# $prefix = "26"
# $ipalfa = "172.18.1.66"
# $ipbravo = "172.18.1.67"

# New-NetIPAddress -InterfaceAlias "Ethernet 2" -IPAddress $ip -DefaultGateway $defaultgateway -PrefixLength $prefix
# Set-DnsClientServerAddress -InterfaceAlias "Ethernet 2" -ServerAddresses $ipalfa, $ipbravo

# Adapter changes {{{
# NOTE: When using Vagrant, there will be 2 adapters, NAT and host-only.
#       This code block is to make it easier to switch between using Vagrant
#       and using Virtualbox to test the VM. When there is only 1 adapter present,
#       this will be used as the LAN adapter. When there are 2 adapters, 
#       the first will be the NAT adapter, which is used by Vagrant for the communication
#       with the VM. The next adapter will then act as the LAN adapter.
$adaptercount=(Get-NetAdapter | measure).count
if ($adaptercount -eq 1) {
    (Get-NetAdapter -Name "Ethernet") | Rename-NetAdapter -NewName $lan_adapter_name
} 
elseif ($adaptercount -eq 2) {
    (Get-NetAdapter -Name "Ethernet") | Rename-NetAdapter -NewName $wan_adapter_name
    (Get-NetAdapter -Name "Ethernet 2") | Rename-NetAdapter -NewName $lan_adapter_name
}

$existing_ip=(Get-NetAdapter -Name $lan_adapter_name | Get-NetIPAddress -AddressFamily IPv4).IPAddress
if ("$existing_ip" -ne "$local_ip") {
    Write-host ">>> Setting static ipv4 settings"
    New-NetIPAddress -InterfaceAlias "$lan_adapter_name" -IPAddress "$local_ip" -PrefixLength $lan_prefix -DefaultGateway "$default_gateway"
}

# Set DNS of LAN adapter
Write-Host ">>> Settings DNS of adapter $lan_adapter_name"
Set-DnsClientServerAddress -InterfaceAlias "$lan_adapter_name" -ServerAddresses($ipalfa,$ipbravo)
# }}}

# Default admin account changes {{{
# NOTE: Can't remember the exact reason but this was also done on
#       Alfa2, Bravo2 and Delta2. Your choice if you want to leave
#       this out.
# Set default password
Write-Host ">>> Setting default Administrator password"
$SafeModeAdministratorPassword = ConvertTo-SecureString $domain_password -AsPlainText -Force

# Configure Administrator account
Write-Host ">>> Configuring Administrator account"
Set-LocalUser -Name "Administrator" -AccountNeverExpires -Password $SafeModeAdministratorPassword -PasswordNeverExpires:$true -UserMayChangePassword:$true
# }}}


#Firewall
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False
#SQL toegang geven tot de firewall
New-NetFirewallRule -DisplayName "SQL port 1433" -Direction Inbound -LocalPort 1433 -Protocol TCP -Action Allow

#Domein joinen
Write-Host 'Trying to join domain red.local'
# $DomainName = "red.local"
# $SafeModeAdministratorPassword = $domain_password | ConvertTo-SecureString -AsPlainText -Force
# $domain = $domain_netbios
# $joindomainuser = $domain_user
$credential = New-Object System.Management.Automation.PSCredential("$domain_netbios\$domain_user",$SafeModeAdministratorPassword)

Add-Computer -DomainName $domain -DomainCredential $credential

# NOTE: When restarting the vm from inside the scripts,
#       vagrant gets bugged out and freezes. To prevent this,
#       this looks like 'node.vm.provision 'shell', reboot: true'
# Restart-Computer

#       we use the plugin 'vagrant-reload'. In the Vagrantfile