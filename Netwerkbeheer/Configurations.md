# Configurations & Commands per device

## Router 1
- ena
- conf t
- hostname Router1
- enable secret Admin2019
- line console 0
- password Console2019
- login
- exit
- line vty 0 15
- password Telnet2019
- login
- exit
- service password-encryption
- int g0/0/0
- ip address 172.18.1.100 255.255.255.252
- no shut
- int s0/1/1
- ip address 172.18.3.2 255.255.255.252
- no shut
- exit
- 


- without zulu2:
- int s0/1/0
- ip address 172.18.1.105 255.255.255.252
- no shut
- exit
- 
#
- router ospf 10
- router-id 1.1.1.1
- end
- clear ip ospf process
- y
- conf t
- router ospf 10
- network 172.18.1.100 0.0.0.3 area 0
- network 172.18.1.104 0.0.0.3 area 0
- network 172.18.3.0 0.0.0.3 area 0
- exit
- 
#### Deprecated
- ip route 172.18.1.64 255.255.255.224 g0/0
- ip route 172.18.1.100 255.255.255.252 g0/0
- ip route 172.18.1.0 255.255.255.192 g0/0
- ip route 172.18.0.0 255.255.255.0 g0/0
- ip route 0.0.0.0 0.0.0.0 s0/1/0
- 

## Router 3
- ena
- conf t
- hostname Router3
- enable secret Admin2019
- line console 0
- password Console2019
- login
- exit
- line vty 0 15
- password Telnet2019
- login
- exit
- service password-encryption
- int s0/1/0
- ip address 172.18.2.2 255.255.255.252
- no shut
- int s0/1/1
- ip address 172.18.3.1 255.255.255.252
- no shut
- exit
- 
#
- router ospf 10
- router-id 3.3.3.3
- end
- clear ip ospf process
- y
- conf t
- router ospf 10
- network 172.18.2.0 0.0.0.3 area 0
- network 172.18.3.0 0.0.0.3 area 0
- network 172.16.3.0 0.0.0.3 area 0
- exit
- 
#### Deprecated
- ip route 172.18.1.65 255.255.255.224 s0/1/0
- ip route 172.18.101.30 255.255.255.252 s0/1/0
- ip route 172.18.1.0 255.255.255.192 s0/1/0
- ip route 172.18.0.0 255.255.255.0 s0/1/0
- ip route 172.18.1.105 255.255.255.252 s0/1/0
- ip route 0.0.0.0 0.0.0.0 s0/1/1
- 

## Router 4
- ena
- conf t
- hostname Router4
- enable secret Admin2019
- line console 0
- password Console2019
- login
- exit
- line vty 0 15
- password Telnet2019
- login
- exit
- service password-encryption

### ! Internet on outside interface via DHCP -- NAT
(internal interface)
- int s0/1/0
- ip address 172.18.2.1 255.255.255.252
- ip nat inside
- no shut
- int s0/1/1
- ip address 172.16.2.1 255.255.255.252
- ip nat inside
- no shut
- 
(external interface)

- int g0/0/0
- ip address dhcp
- ip nat outside 
- no shut
- exit
- 
- access-list 1 permit 172.18.0.0 0.0.255.255
- ip nat inside source list 1 interface g0/0/0 overload
- 
- (do) show ip nat translations
#
- router ospf 10
- router-id 4.4.4.4
- end
- clear ip ospf process
- y
- conf t
- router ospf 10
- network 172.18.2.0 0.0.0.3 area 0
- network 172.16.2.0 0.0.0.3 area 0
- exit
- 
#### Deprecated
- ip route 172.18.1.64 255.255.255.224 s0/1/0
- ip route 172.18.1.100 255.255.255.252 s0/1/0
- ip route 172.18.1.0 255.255.255.192 s0/1/0
- ip route 172.18.0.0 255.255.255.0 s0/1/0
- ip route 172.18.1.104 255.255.255.252 s0/1/0
- ip route 172.18.3.0 255.255.255.252 s0/1/0
- ip route 0.0.0.0 0.0.0.0 s0/1/1
- 

## Router 5 (Formerly L3 Switch5)
- ena
- conf t
- hostname Router5
- enable secret Admin2019
- line console 0
- password Console2019
- login
- exit
- line vty 0 15
- password Telnet2019
- login
- exit
- service password-encryption
- int g0/0/0
- ip address 172.18.1.7 255.255.255.192
- no shut
- int g0/0/1
- ip address 172.18.0.1 255.255.255.0
- no shut
- int s0/1/0
- ip address 172.18.1.97 255.255.255.252
- no shut
- exit
- 
#
- router ospf 10
- router-id 5.5.5.5
- end
- clear ip ospf process
- y
- conf t
- router ospf 10
- network 172.18.1.0 0.0.0.63 area 0
- network 172.18.0.0 0.0.0.255 area 0
- network 172.18.1.96 0.0.0.3 area 0
- passive-interface g0/0/0
- passive-interface g0/0/1
- exit
- 
#### Deprecated
- ip route 172.18.1.65 255.255.255.224 s0/1/0
- ip route 172.18.1.100 255.255.255.252 s0/1/0
- ip route 0.0.0.0 0.0.0.0 s0/1/0
- 

## Router 6 (Formerly L3 Switch6)
- ena
- conf t
- hostname Router6
- enable secret Admin2019
- line console 0
- password Console2019
- login
- exit
- line vty 0 15
- password Telnet2019
- login
- exit
- service password-encryption
- int g0/0/0
- ip address 172.18.1.65 255.255.255.224
- no shut
- int g0/0/1
- ip address 172.18.1.101 255.255.255.252
- no shut
- int s0/1/0
- ip address 172.18.1.98 255.255.255.252
- no shut
- exit
- 
- without zulu2:
- int s0/1/1
- ip address 172.18.1.106 255.255.255.252
- no shut
- exit
- 
#
- router ospf 10
- router-id 6.6.6.6
- end
- clear ip ospf process
- y
- conf t
- router ospf 10
- network 172.18.1.100 0.0.0.3 area 0
- network 172.18.1.64 0.0.0.31 area 0
- network 172.18.1.96 0.0.0.3 area 0
- network 172.18.1.104 0.0.0.3 area 0
- passive-interface g0/0/0
- exit
- 
#### Deprecated
- ip route 172.18.1.0 255.255.255.192 s0/1/0
- ip route 172.18.0.0 255.255.255.0 s0/1/0
- ip route 0.0.0.0 0.0.0.0 g0/1
- 

## L2 Switch 4
- ena
- conf t
- hostname Switch4
- enable secret Admin2019
- line console 0
- password Console2019
- login
- exit
- line vty 0 4
- password Telnet2019
- login
- exit
- service password-encryption
- int range f0/6-f0/24
- shutdown
- exit
- 

### VLAN

- vlan 200
- name vlan200
- exit
- int range f0/1-f0/5
- switchport mode access
- switchport access vlan 200
- int g0/1
- switchport mode access
- switchport access vlan 200
- 

## L2 Switch 5
- ena
- conf t
- hostname Switch5
- enable secret Admin2019
- line console 0
- password Console2019
- login
- exit
- line vty 0 4
- password Telnet2019
- login
- exit
- service password-encryption
- int range f0/7-f0/24
- shutdown
- exit
- 

### VLAN

- vlan 300
- name vlan300
- exit
- int range f0/1-f0/6
- switchport mode access
- switchport access vlan 300
- int g0/1
- switchport mode access
- switchport access vlan 300
- 

## L2 Switch 7
- ena
- conf t
- hostname Switch7
- enable secret Admin2019
- line console 0
- password Console2019
- login
- exit
- line vty 0 4
- password Telnet2019
- login
- exit
- service password-encryption
- int range f0/5-f0/24
- shutdown
- exit
- 

### VLAN

- vlan 500
- name vlan500
- exit
- int range f0/1-f0/5
- switchport mode access
- switchport access vlan 500
- int g0/1
- switchport mode access
- switchport access vlan 500
- 

## End devices
- IP: Check IP table
- DNS: 172.18.1.66
- Default Gateway: Check IP table