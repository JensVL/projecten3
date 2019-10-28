Check IP Address:
    output:
        fe80::95bb:9703:163b:5d9a%7 
        172.18.1.1 
        169.254.93.154

Check Default Gateway:
    output:
        0.0.0.0 0.0.0.0 0.0.0.0 0.0.0.0 0.0.0.0 172.18.1.66 :: :: ::

Check DNS Server Addresses:
    output:
        172.18.1.66

Check Domain Name:
    output:
#todo#######        

Check if DHCP is installed:
    output:
        DHCP : Installed

Check security groups:
    output:
        DHCP Users
        DHCP Administrators

Check if scope is correct:
    output:
        ScopeId: 172.18.0.0
        Name: Vlan 200
        StartRange: 172.18.0.2
        EndRange: 172.18.0.254
        LeaseDuration: 2.00:00:00

Check if correct options are configured:
    output:

OptionId   Name            Type       Value                VendorClass     User
                                                                           Clas
                                                                           s   
--------   ----            ----       -----                -----------     ----
66         Boot Server ... String     {172.18.1.6}                             
67         Bootfile Name   String     {\smsboot\x64\wds...                     

Check if server is authorized:
    output:
#todo#######
 