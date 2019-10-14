# IP Configuraties

Write-Host "Configuring IP..."
$IP = "172.18.1.1"
$DefaultGateway = "172.18.1.66"
$DNS = "172.18.1.66"
$InterfaceIndex = Get-NetIPAddress -IPAddress $IP | select -ExpandProperty InterfaceIndex
Remove-NetIPAddress -InterfaceIndex $InterfaceIndex -Confirm:$false
Remove-NetRoute -InterfaceIndex $InterfaceIndex -Confirm:$false
Set-DnsClientServerAddress -InterfaceIndex $InterfaceIndex -ResetServerAddresses
New-NetIPAddress -InterfaceIndex $InterfaceIndex -IPAddress $IP -PrefixLength 24 -DefaultGateway $DefaultGateway
Set-DnsClientServerAddress -InterfaceIndex $InterfaceIndex -ServerAddresses $DNS
Write-Host "Ip Configured"

# Add delay to give the server time to adapt to new ip configurations
# If no delay is added the Machine will not be adapted to the new ip configurations and will fail to join the domain

Start-Sleep -s 5

# Toevoegen aan domain

$domain = "red.local"
$password = "Admin2019" | ConvertTo-SecureString -AsPlainText -Force
$username = "Administrator"
$credential = New-Object System.Management.Automation.PSCredential($username, $password)

Add-Computer -DomainName $domain -Credential $credential -Restart -Force

# DHCP rol installeren

Install-WindowsFeature -Name DHCP -IncludeManagementTools

# Configureren van de Scopes op de DHCP Server

# --scope vlan 200--
Add-DhcpServerV4Scope -Name "Vlan 200" -StartRange 172.18.0.2 -EndRange 172.18.0.254 -SubnetMask 255.255.255.0

# --scope vlan 300--
Add-DhcpServerV4Scope -Name "Vlan 300" -StartRange 172.18.1.1 -EndRange 172.18.1.62 -SubnetMask 255.255.255.192

# --scope vlan 400--
Add-DhcpServerV4Scope -Name "Vlan 400" -StartRange 172.18.1.97 -EndRange 172.18.1.98 -SubnetMask 255.255.255.252

# --scope vlan 500--
Add-DhcpServerV4Scope -Name "Vlan 500" -StartRange 172.18.1.65 -EndRange 172.18.1.94 -SubnetMask 255.255.255.224

# --scope vlan 600--
Add-DhcpServerV4Scope -Name "Vlan 600" -StartRange 172.18.1.101 -EndRange 172.18.1.102 -SubnetMask 255.255.255.252

# --scope vlan 700--
Add-DhcpServerV4Scope -Name "Vlan 700" -StartRange 172.18.1.105 -EndRange 172.18.1.106 -SubnetMask 255.255.255.252

# DNS, Router, Default Gateway en mogelijk andere zaken toevoegen

Set-DhcpServerV4OptionValue -DnsServer 172.18.1.66,172.18.1.67 -Router 172.18.0.1 -ScopeId 172.18.0.0

# Lease time configureren

Set-DhcpServerv4Scope -ScopeId 172.18.0.0 -LeaseDuration (New-TimeSpan -Days 2)

# Reservations
$ReservationsPath = $PSScriptRoot
$ReservationsPath += "./Reservations.csv"

Import-Csv -Path $ReservationsPath | Add-DhcpServerV4Reservation

# Restart DHCP Server
Restart-service dhcpserver
