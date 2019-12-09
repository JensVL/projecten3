$IP = "172.18.1.1"
$lan_prefix = 26
$DefaultGateway = "172.18.1.7"
$primary_dns = "172.18.1.66"
$secondary_dns = "172.18.1.67"

# Configuring IP

Write-Host ">>> Configuring IP"
$InterfaceAlias = "LAN"

## Renaming ethernet adapter
Get-NetAdapter -Name "Ethernet" | Rename-NetAdapter -NewName $InterfaceAlias

## Removing IP-address and default gateway
Remove-NetIPAddress -InterfaceAlias $InterfaceAlias -Confirm:$false
Remove-NetRoute -InterfaceAlias $InterfaceAlias -Confirm:$false

## Creating new IP-address
New-NetIPAddress -InterfaceAlias $InterfaceAlias -IPAddress $IP -PrefixLength $lan_prefix -DefaultGateway $DefaultGateway
Set-DnsClientServerAddress -InterfaceAlias $InterfaceAlias -ServerAddresses($primary_dns, $secondary_dns)

# Configuring hostname

Rename-Computer -NewName "Kilo2"