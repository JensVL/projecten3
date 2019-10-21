# Configureren van de Scopes op de DHCP Server

# --scope vlan 200--
Write-Host "Configuring VLAN 200..."
Add-DhcpServerV4Scope -Name "Vlan 200" -StartRange 172.18.0.2 -EndRange 172.18.0.254 -SubnetMask 255.255.255.0 -Type Both

# DNS, Router, Default Gateway en mogelijk andere zaken toevoegen

Set-DhcpServerV4OptionValue -DnsServer 172.18.1.66 -Router 172.18.0.1 -ScopeId 172.18.0.0

# Lease time configureren

Set-DhcpServerv4Scope -ScopeId 172.18.0.0 -LeaseDuration (New-TimeSpan -Days 2)

Write-Host "VLAN 200 configured"
Write-Host "Authorizing DHCP server..."

$password = "vagrant" | ConvertTo-SecureString -AsPlainText -Force
$username = "Administrator"
$credential = New-Object System.Management.Automation.PSCredential($username, $password)

Start-Job -Name AuthorizeDHCP -Credential $credential -ScriptBlock {
    Add-DhcpServerInDC -DnsName "Kilo2.red.local"
}

Wait-Job -Name AuthorizeDHCP

Write-Host "DHCP server authorized"

# Restart DHCP Server
Restart-service dhcpserver