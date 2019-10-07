# Toevoegen aan domain

$domain = "red.local"
$password = "Admin2019" | ConvertTo-SecureString -AsPlainText -Force
$username = "Administrator"
$credential = New-Object System.Management.Automation.PSCredential($username, $password)

Add-Computer -DomainName $domain -Credential $credential -Restart -Force

# DHCP rol installeren

Install-WindowsFeature -Name DHCP -IncludeManagementTools

# Configureren van de Scopes op de DHCP Server

Add-DhcpServerV4Scope -Name "Vlan 200" -StartRange 172.18.0.2 -EndRange 172.18.0.254 -SubnetMask 255.255.255.0

# DNS, Router, Default Gateway en mogelijk andere zaken toevoegen

Set-DhcpServerV4OptionValue -DnsServer 172.18.1.66,172.18.1.67 -Router 172.18.0.1 -ScopeId 172.18.0.0

# Lease time configureren

Set-DhcpServerv4Scope -ScopeId 172.18.0.0 -LeaseDuration (New-TimeSpan -Days 2)

# Restart DHCP Server
Restart-service dhcpserver
