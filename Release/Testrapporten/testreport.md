# Test report: Kilo2

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

All tests succeded!
