# Configureren van IP address van de DHCP Server
# TODO

# Toevoegen aan domain

$domain = ??????????????????????????????????
$password = "Admin2019" | ConvertTo-SecureString -AsPlainText -Force
$username = "Administrator"
$credential = New-Object System.Management.Automation.PSCredential($username, $password)

Add-Computer -DomainName $domain -Credential $credential -Restart -Force

# DHCP rol installeren

Install-WindowsFeature -Name DHCP -IncludeManagementTools

# Configureren van de Scopes op de DHCP Server

Add-DhcpServerV4Scope -Name "Vlan 200" -StartRange 172.18.0.2 -EndRange 172.18.0.254 -SubnetMask 255.255.255.0

# DNS, Router, Default Gateway en mogelijk andere zaken toevoegen
# TODO

# Lease time configureren
# TODO



# Restart DHCP Server
Restart-service dhcpserver
