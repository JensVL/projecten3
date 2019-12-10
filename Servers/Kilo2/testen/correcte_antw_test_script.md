Volgende gegevens moeten aanwezig zijn na het runnen van test_script.ps1

# Check name and domain:
Variable | Value
---|---
Name | KILO2
Domain | red.local

# Check IP Address:
Variable | Value
---|---
IPAddress |172.18.1.1
PrefixLength | 26

# Check Default Gateway:
Variable | Value
---|---
NextHop | 172.18.1.7

# Check DNS Server Addresses:
Variable | Value
---|---
ServerAddresses |{172.18.1.66, 172.18.1.67}

# Check if DHCP in installed:
Variable | Value
---|---
Name | DHCP
InstallState | Installed

# Check security groups:
Variable | Value
---|---
Name | DHCP Administrator
Name | DHCP Users

# Check if scope is correct:
Variable | Value
---|---
ScopeId | 172.18.0.0
Name | Vlan 200
State | Active
SubnetMask | 255.255.255.0
StartRange | 172.18.0.2
EndRange |172.18.0.254
LeaseDuration | 2.00:00:00
Type | Both

# Check if correct options are configured:

Variable | Value
---|---
OptionID | 3
Name | Router
Value | {172.18.0.1}

Variable | Value
---|---
OptionID | 6
Name | DNS Servers
Value | {172.18.1.66, 172.18.1.67}

Variable | Value
---|---
OptionID | 15
Name | DNS Domain name
Value | {red.local}

Variable | Value
---|---
OptionID | 51
Name | Lease
Value | {172800}

Variable | Value
---|---
OptionID | 66
Name | Boot Server Host Name
Value | {papa2.red.local}

Variable | Value
---|---
OptionID | 67
Name | Bootfile Name
Value | {\boot\x64\wdsnbp.com}

# Check if server is authorized

Variable | Value
---|---
DnsName | kilo2.red.local
IPAddress | 172.18.1.1