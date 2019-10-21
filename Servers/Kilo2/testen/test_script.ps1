$InterfaceIndex = Get-NetIPAddress 172.18.1.1 | select -ExpandProperty InterfaceIndex
Write-Host 'Check IP Address:'
Write-Host (Get-NetIPAddress -InterfaceIndex $InterfaceIndex | select -ExpandProperty IPAddress)
Write-Host
Write-Host 'Check Default Gateway:'
Write-Host (Get-NetRoute -InterfaceIndex $InterfaceIndex | select -ExpandProperty NextHop)
Write-Host
Write-Host 'Check DNS Server Addresses:'
Write-Host (Get-DnsClientServerAddress -InterfaceIndex $InterfaceIndex | select -ExpandProperty ServerAddresses)
Write-Host
Write-Host 'Check Domain Name:'
$env:USERDNSDOMAIN
Write-Host
Write-Host 'Check if DHCP is installed:'
$DHCP = Get-WindowsFeature -Name DHCP 
$DHCPInstalled = $DHCP | select -ExpandProperty InstallState
$DHCPName = $DHCP | select -ExpandProperty Name
Write-Host "$DHCPName : $DHCPInstalled"
Write-Host
Write-Host 'Check security groups:'
Write-Host (Get-WmiObject win32_group -Filter "name='DHCP Users'" | select -ExpandProperty name)
Write-Host (Get-WmiObject win32_group -Filter "name='DHCP Administrators'" | select -ExpandProperty name)
Write-Host
Write-Host 'Check if scope is correct:'
$Scope = Get-DhcpServerV4Scope
$ScopeId = $Scope | select -ExpandProperty ScopeId
$Name = $Scope | select -ExpandProperty Name
$StartRange = $Scope | select -ExpandProperty StartRange
$EndRange = $Scope | select -ExpandProperty EndRange
$LeaseDuration = $Scope | select -ExpandProperty LeaseDuration
Write-Host "ScopeId: $ScopeId"
Write-Host "Name: $Name"
Write-Host "StartRange: $StartRange"
Write-Host "EndRange: $EndRange"
Write-Host "LeaseDuration: $LeaseDuration"
Write-Host
Write-Host 'Check if correct options are configured:'
Get-DhcpServerV4OptionValue
Write-Host
Write-Host 'Check if server is authorized:'
Get-DhcpServerInDC