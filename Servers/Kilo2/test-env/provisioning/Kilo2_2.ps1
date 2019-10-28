$j = @()
# Creating security groups
$j += Start-Job -Name SecurityGroups -ScriptBlock {
    Write-Host "Creating security groups..."
    cmd.exe /c "netsh dhcp add securitygroups"
    Write-Host "Security Groups created"
}
# Configureren van de Scopes op de DHCP Server

# --scope vlan 200--
$j += Start-Job -Name CreateScope -ScriptBlock {
    Add-DhcpServerV4Scope -Name "Vlan 200" -StartRange 172.18.0.2 -EndRange 172.18.0.254 -SubnetMask 255.255.255.0 -Type Both
}
Wait-Job -Name CreateScope
# DNS, Router, Default Gateway en mogelijk andere zaken toevoegen
$j += Start-Job -Name SettingOptionValues -ScriptBlock {
    Set-DhcpServerV4OptionValue -DnsServer 172.18.1.66, 172.18.1.67 -DnsDomain "red.local" -Router 172.18.0.1 -ScopeId 172.18.0.0 -Force
    Set-DhcpServerV4OptionValue -OptionId 066 -Value 172.18.1.6 # Value kan mogelijks nog veranderen
    Set-DhcpServerV4OptionValue -OptionId 067 -Value "\smsboot\x64\wdsnbp.com" # Value kan mogelijks nog veranderen
}
# Lease time configureren
$j += Start-Job -Name SettingLease -ScriptBlock {
    Set-DhcpServerv4Scope -ScopeId 172.18.0.0 -LeaseDuration (New-TimeSpan -Days 2)
}

$password = "vagrant" | ConvertTo-SecureString -AsPlainText -Force
$username = "RED\Administrator"
$credential = New-Object System.Management.Automation.PSCredential($username, $password)

$j += Start-Job -Name AuthorizeDHCP -Credential $credential -ScriptBlock {
    Add-DhcpServerInDC -DnsName "Kilo2.red.local"
}

Wait-Job -Job $j
Receive-Job -Job $j

# Restart DHCP Server
Restart-service dhcpserver