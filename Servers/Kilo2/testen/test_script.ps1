$InterfaceIndex = Get-NetIPAddress 172.18.1.1 | select -ExpandProperty InterfaceIndex
Write-Host 'IP Address:'
Write-Host (Get-NetIPAddress -InterfaceIndex $InterfaceIndex | select -ExpandProperty IPAddress)
Write-Host
Write-Host 'Default Gateway:'
Write-Host (Get-NetRoute -InterfaceIndex $InterfaceIndex | select -ExpandProperty NextHop)
Write-Host
Write-Host 'DNS Server Addresses:'
Write-Host (Get-DnsClientServerAddress -InterfaceIndex $InterfaceIndex | select -ExpandProperty ServerAddresses)
Write-Host
Write-Host 'Domain Name:'
$env:USERDNSDOMAIN
Write-Host
Write-Host 'Check if DHCP is installed:'
$DHCP = Get-WindowsFeature -Name DHCP 
$DHCPInstalled = $DHCP | select -ExpandProperty InstallState
$DHCPName = $DHCP | select -ExpandProperty Name
Write-Host "$DHCPName : $DHCPInstalled"
Write-Host
Write-Host 'Get security groups:'
Write-Host (Get-WmiObject win32_group -Filter "name='DHCP Users'" | select -ExpandProperty name)
Write-Host (Get-WmiObject win32_group -Filter "name='DHCP Administrators'" | select -ExpandProperty name)
