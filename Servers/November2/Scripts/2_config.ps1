Write-Host 'Setting IP configuration'
#IP configuratie
$ip = "172.18.1.4"
$defaultgateway = "172.18.1.1"
$prefix = "26"
$ipalfa = "172.18.1.66"
$ipbravo = "172.18.1.67"

New-NetIPAddress -InterfaceAlias Ethernet0 -IPAddress $ip -DefaultGateway $defaultgateway -PrefixLength $prefix
Set-DnsClientServerAddress -InterfaceAlias Ethernet0 -ServerAddresses $ipalfa, $ipbravo

#Firewall
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False
#SQL toegang geven tot de firewall
New-NetFirewallRule -DisplayName "SQL port 1433" -Direction Inbound -LocalPort 1433 -Protocol TCP -Action Allow

#Domein joinen
Write-Host 'Trying to join domain red.local'
$DomainName = "red.local"
$SafeModeAdministratorPassword = "Admin2019" | ConvertTo-SecureString -AsPlainText -Force
$domain = "red"
$joindomainuser = "Administrator"
$credential = New-Object System.Management.Automation.PSCredential($joindomainuser,$SafeModeAdministratorPassword)
Add-Computer -DomainName $DomainName -Credential $credential
Restart-Computer
