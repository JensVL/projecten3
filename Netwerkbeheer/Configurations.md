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
- ip address 172.18.1.105 255.255.255.252
- no shut
- int s0/1/1
- ip address 172.18.3.2 255.255.255.252
- no shut
- exit
- ip route 0.0.0.0 0.0.0.0 s0/1/1
- ip route 172.18.0.0 255.255.0.0 g0/0/0 172.18.1.106
- exit
-
- without zulu2:
- int s0/1/0
- ip address 172.18.1.109 255.255.255.252
- no shut
- exit
-
- router ospf 10
- router-id 1.1.1.1
- end
- clear ip ospf process
- y
- conf t
- router ospf 10
- network 172.18.1.108 0.0.0.3 area 0
- network 172.18.1.104 0.0.0.3 area 0
- network 172.18.3.0 0.0.0.3 area 0
- exit

### VPN

- int Tunnel0
- tunnel mode gre ip
- ip address 172.17.4.2 255.255.255.252
- tunnel source 172.18.3.2
- tunnel destination 172.16.1.109
- router ospf 10
- network 172.17.4.0 0.0.0.3 area 0
- ip route 172.16.1.108 255.255.255.252  s0/1/1
- network 172.18.6.1 0.0.0.3 area 0
- ip route 172.16.0.0 255.255.0.0 tunnel0

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
- int g0/0/0
- ip address 172.16.3.2 255.255.255.252
- no shut
- ip route 0.0.0.0 0.0.0.0 s0/1/0
- ip route 172.18.0.0 255.255.0.0 s0/1/1 172.18.3.2
-
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

### Internet on outside interface via DHCP -- NAT

(internal interface)

- int s0/1/0
- ip address 172.18.2.1 255.255.255.252
- ip nat inside
- no shut
- int s0/1/1
- ip address 172.16.2.1 255.255.255.252
- ip nat inside
- no shut

(external interface)

- int g0/0/0
- ip address dhcp
- ip nat outside
- no shut
- exit
- ip route 0.0.0.0 0.0.0.0 g0/0/0
- ip route 172.18.0.0 255.255.0.0 s0/1/0 172.18.2.2
- ip route 172.16.0.0 255.255.0.0 s0/1/1 172.16.2.2
- access-list 1 permit 172.18.2.0 0.0.0.3
- access-list 1 permit 172.18.1.0 0.0.0.63
- access-list 1 permit 172.18.0.0 0.0.0.255
- access-list 1 permit 172.18.1.96 0.0.0.3
- access-list 1 permit 172.18.1.100 0.0.0.3
- access-list 1 permit 172.18.1.64  0.0.0.31
- access-list 1 permit 172.18.1.104 0.0.0.3
- access-list 1 permit 172.18.1.108 0.0.0.3
- access-list 1 permit 172.16.0.0 0.0.0.255
- access-list 1 permit 172.16.1.0 0.0.0.63
- access-list 1 permit 172.16.1.96 0.0.0.3
- access-list 1 permit 172.16.1.64 0.0.0.31
- access-list 1 permit 172.16.1.100 0.0.0.3
- access-list 1 permit 172.16.1.104 0.0.0.3
- access-list 1 permit 172.16.2.0 0.0.0.3
- ip nat inside source list 1 interface g0/0/0 overload
-
- (do) show ip nat translations
-
- router ospf 10
- router-id 4.4.4.4
- end
- clear ip ospf process
- y
- conf t
- router ospf 10
- network 172.18.2.0 0.0.0.3 area 0
- network 172.16.2.0 0.0.0.3 area 0
- network 172.22.0.0 0.0.255.255 area 0
- exit

#### Backup comms

- ip nat pool pool1 172.22.192.10 172.22.192.10 prefix 16
- ip nat inside source list 1 pool pool1 overload

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
- ip helper-address 172.18.1.1
- no shut
- int s0/1/0
- ip address 172.18.1.97 255.255.255.252
- no shut
- exit
- ip route 0.0.0.0 0.0.0.0 s0/1/0
- exit
- conf t
- access-list 10 permit 172.18.1.64 0.0.0.31
-
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
- ip route 0.0.0.0 0.0.0.0 g0/0/1
- exit
-
- without zulu2:
- int s0/1/1
- ip address 172.18.1.110 255.255.255.252
- no shut
- exit
- no ip route 0.0.0.0 0.0.0.0 g0/0/1
- ip route 0.0.0.0 0.0.0.0 s0/1/1
-
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
- network 172.18.1.108 0.0.0.3 area 0
- passive-interface g0/0/0
- exit

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
- exit

### VLAN 200

- conf t
- vlan 200
- name vlan200
- exit
- int range f0/1-10
- switchport mode access
- switchport access vlan 200
- int vlan 200

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
- exit

### VLAN 300

- conf t
- vlan 300
- name vlan300
- exit
- int range f0/1-10
- switchport mode trunk
- switchport trunk allowed vlan 200,300,500

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
- exit

### VLAN 500

- conf t
- vlan 500
- name vlan500
- exit
- int range f0/1-5
- switchport mode trunk
- switchport trunk allowed vlan 200,300,500

## End devices

- IP: Check [IP table](https://github.com/HoGentTIN/p3ops-1920-red/blob/network/Netwerkbeheer/IP%20Table.md)
- DNS: 172.18.1.66
- Secondary DNS: 172.18.1.67
- Default Gateway: [Check IP table](https://github.com/HoGentTIN/p3ops-1920-red/blob/network/Netwerkbeheer/IP%20Table.md)
