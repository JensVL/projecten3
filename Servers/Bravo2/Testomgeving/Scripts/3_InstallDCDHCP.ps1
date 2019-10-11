## Static IP address
New-NetIPAddress -InterfaceIndex 2 -IPAddress 172.18.1.67 -PrefixLength 24 -DefaultGateway 192.168.64.1
Install-WindowsFeature DHCP -IncludeManagementTools
## DHCP scope
Add-DHCPServerv4Scope -Name “Employee Scope” -StartRange 192.168.64.10 -EndRange 192.168.64.30 -SubnetMask 255.255.255.0 -State Active
## Lease, wat groter nemen zodat je even verder kan
Set-DhcpServerv4Scope -ScopeId 192.168.64.0 -LeaseDuration 1.00:00:00
## DHCP authorizen
Set-DHCPServerv4OptionValue -ScopeID 192.168.64.0 -DnsDomain corp.momco.com -DnsServer 192.168.64.2 -Router 192.168.64.1
## DHCP Server toevoegen aan DC
Add-DhcpServerInDC -DnsName corp.momco.com -IpAddress 192.168.64.2
Restart-service dhcpserver
Stop-Transcript