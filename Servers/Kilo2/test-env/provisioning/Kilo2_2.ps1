param(
    [string]$hostname    = "Kilo2",
    [string]$domain      = "red.local",
    [string]$domain_user = "Administrator",
    [string]$domain_pw   = "Admin2019"
)

$j = @()
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

$password = $domain_pw | ConvertTo-SecureString -AsPlainText -Force
$username = "RED\$domain_user"
$credential = New-Object System.Management.Automation.PSCredential($username, $password)

Wait-Job -Name AuthorizeDHCP
Receive-Job -Name AuthorizeDHCP

# Restart DHCP Server
Restart-service dhcpserver
