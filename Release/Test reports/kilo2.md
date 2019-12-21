# Testrapport: Kilo2
Auteur(s) testrapport:   

## Context

To avoid the known bug, mentioned in the script [](), I was informed to execute the script as Administrator and this fixed the problem in my case.

## Test script

The output of the entire script corresponds with the given output, provided in [correcte_antw_test_script.md](correcte_antw_test_script.md)

## Stappenplan

```Powershell
gsv -Name *dhcp* -ComputerName Kilo2

### OUTPUT:
### Status   Name               DisplayName
### ------   ----               -----------
### Running  Dhcp               DHCP Client
### Running  DHCPServer         DHCP Server
```

```Powershell
Get-DhcpServerv4Scope

### OUTPUT:
### ScopeId         SubnetMask      Name           State    StartRange      EndRange      LeaseDuration
###  -------         ----------      ----           -----    ----------      -------       -------------
### 172.18.0.0      255.255.255.0   Vlan 200       Active   172.18.0.2      172.18.0.254  2.00:00:00
```

```Powershell
Get-DhcpServerInDC

### OUTPUT:
### IPAddress            DnsName
### ---------            ------- 
### 172.18.1.2           kilo2.red.local
```

All the output matches according to the test plan.


## Conclusion

### Check name and domain:
Variable | Value
---|---
Name | KILO2
Domain | red.local

--> success

### Check IP Address:
Variable | Value
---|---
IPAddress |172.18.1.1
PrefixLength | 26

--> Success

### Check Default Gateway:
Variable | Value
---|---
NextHop | 172.18.1.7

--> Success

### Check DNS Server Addresses:
Variable | Value
---|---
ServerAddresses |{172.18.1.66, 172.18.1.67}

--> Success 

### Check if DHCP in installed:
Variable | Value
---|---
Name | DHCP
InstallState | Installed

--> Success

### Check security groups:
Variable | Value
---|---
Name | DHCP Administrator
Name | DHCP Users

--> Success

### Check if scope is correct:
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

--> Success

### Check if correct options are configured:

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

--> Success

### Check if server is authorized

Variable | Value
---|---
DnsName | kilo2.red.local
IPAddress | 172.18.1.1

--> Success


### Conclusion Tests

All succeeded as expected!
