$password = "Admin2019" | ConvertTo-SecureString -AsPlainText -Force
$username = "RED\Administrator"
$credential = New-Object System.Management.Automation.PSCredential($username, $password)
Start-Job -Name Test -Credential $credential -ScriptBlock {
    $DHCP = Get-WindowsFeature -Name DHCP 
    'Check name and domain:'
    Get-WmiObject Win32_ComputerSystem | Select-Object -Property Name, Domain | Format-List | Out-String    
    'Check IP Address:'
    Get-NetIPAddress -AddressFamily IPv4 | Select-Object -Property InterfaceAlias, IPAddress, PrefixLength | Format-List | Out-String
    'Check Default Gateway:'
    Get-NetRoute -AddressFamily IPv4 -DestinationPrefix "0.0.0.0/0" | Select-Object -Property InterfaceAlias, NextHop | Format-List | Out-String
    'Check DNS Server Addresses:'
    Get-DnsClientServerAddress -AddressFamily IPv4 | Select-Object -Property InterfaceAlias, ServerAddresses | Format-List | Out-String
    'Check if DHCP is installed:'
    $DHCP | Select-Object -Property Name, InstallState | Format-List | Out-String
    'Check security groups:'
    Get-WmiObject win32_group -Filter "name LIKE 'DHCP%'" | Select-Object -Property Name | Format-List | Out-String
    'Check if scope is correct:'
    $Scope = Get-DhcpServerV4Scope | Select-Object -Property ScopeID, Name, State, SubnetMask, StartRange, EndRange, LeaseDuration, Type
    $Scope | Format-List | Out-String
    'Check if correct options are configured:'
    $Options = Get-DhcpServerv4OptionValue -ScopeId 172.18.0.0 | Select-Object -Property OptionID, Name, Value
    $Options += (Get-DhcpServerv4OptionValue -OptionId 66,67 | Select-Object -Property OptionID, Name, Value)
    $Options | Sort-Object -Property OptionID | Format-List | Out-String
    'Check if server is authorized:'
    Get-DhcpServerInDC | Select-Object -Property DnsName, IPAddress | Format-List | Out-String
}
Wait-Job -Name Test
Receive-Job -Name Test