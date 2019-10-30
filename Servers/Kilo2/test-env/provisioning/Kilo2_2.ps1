# Variables
$Domain = "red.local"

## authorization
$password = "Admin2019" | ConvertTo-SecureString -AsPlainText -Force
$username = "RED\Administrator"
$credential = New-Object System.Management.Automation.PSCredential($username, $password)

## dhcp values
$StartRange = "172.18.0.2"
$StopRange = "172.18.0.254"
$SubnetMask = "255.255.255.0"
$DHCPDnsServers = @("172.18.1.66", "172.18.1.67")
$ScopeID = "172.18.0.0"
$ScopeDG = "172.18.0.1"
$DHCPOption66Value = "papa2.$Domain"

# Creating security groups
Write-Host ">>> Creating security groups"
cmd.exe /c "netsh dhcp add securitygroups"
# Configureren van de Scopes op de DHCP Server

Write-Host ">>> Authorizing DHCP Server in background"
Start-Job -Name AuthorizeDHCP -Credential $credential -ScriptBlock {
    Write-Host ">>> Authorizing DHCP"
    Add-DhcpServerInDC
}

# --scope vlan 200--
Write-Host ">>> Creating DHCP Scope"
Add-DhcpServerV4Scope -Name "Vlan 200" -StartRange $StartRange -EndRange $StopRange -SubnetMask $SubnetMask -Type Both
# DNS, Router, Default Gateway en mogelijk andere zaken toevoegen

Write-Host ">>> Configuring Option Values"
Set-DhcpServerV4OptionValue -DnsServer $DHCPDnsServers -DnsDomain $Domain -Router $ScopeDG -ScopeId $ScopeID -Force
Set-DhcpServerV4OptionValue -OptionId 066 -Value $DHCPOption66Value # Value kan mogelijks nog veranderen
Set-DhcpServerV4OptionValue -OptionId 067 -Value "\smsboot\x64\wdsnbp.com" # Value kan mogelijks nog veranderen
# Lease time configureren

Write-Host ">>> Configuring Lease Duration"
Set-DhcpServerv4Scope -ScopeId $ScopeID -LeaseDuration (New-TimeSpan -Days 2)

Wait-Job -Name AuthorizeDHCP
Receive-Job -Name AuthorizeDHCP

# Restart DHCP Server
Restart-service dhcpserver