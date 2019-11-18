
$hostname = "Kilo2"
$domain = "red.local"
$domain_user = "Administrator"
$domain_pw = "Admin2019"
$primary_dns = "172.18.1.66"
$secondary_dns = "172.18.1.67"

# Variables

$ScopeID = "172.18.0.0"
$StartRange = "172.18.0.2"
$StopRange = "172.18.0.254"
$SubnetMask = "255.255.255.0"
$DnsServersOptionValue = @($primary_dns, $secondary_dns)
$ScopeDG = "172.18.0.1"
$DHCPOption66Value = "papa2.$domain"
$DHCPOption67Value = "\smsboot\x64\wdsnbp.com"

# Creating security groups
Write-Host ">>> Creating security groups"
cmd.exe /c "netsh dhcp add securitygroups"

# Authorizeren van de dhcp server

$password = $domain_pw | ConvertTo-SecureString -AsPlainText -Force
$username = "RED\$domain_user"
$credential = New-Object System.Management.Automation.PSCredential($username, $password)

Write-Host ">>> Authorizing DHCP Server in background"
Start-Job -Name AuthorizeDHCP -Credential $credential -ScriptBlock {
    Write-Host ">>> Authorizing DHCP"
    Add-DhcpServerInDC
}

Wait-Job -Name AuthorizeDHCP | Receive-Job

# Configureren van de Scopes op de DHCP Server

# --scope vlan 200--
Write-Host ">>> Creating DHCP Scope"
Add-DhcpServerV4Scope -Name "Vlan 200" -StartRange $StartRange -EndRange $StopRange -SubnetMask $SubnetMask -Type Both

# DNS, Router, Default Gateway en mogelijk andere zaken toevoegen
Write-Host ">>> Configuring Option Values"
Set-DhcpServerV4OptionValue -DnsServer $DnsServersOptionValue -DnsDomain $domain -Router $ScopeDG -ScopeId $ScopeID -Force
Set-DhcpServerV4OptionValue -OptionId 066 -Value $DHCPOption66Value # Value kan mogelijks nog veranderen
Set-DhcpServerV4OptionValue -OptionId 067 -Value $DHCPOption67Value # Value kan mogelijks nog veranderen

# Lease time configureren
Write-Host ">>> Configuring Scope Lease"
Set-DhcpServerv4Scope -ScopeId $ScopeID -LeaseDuration (New-TimeSpan -Days 2)

# Restart DHCP Server
Restart-service dhcpserver
