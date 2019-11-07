#  Network Documentation

- Switch / Router console password: Console2019
- Switch / Router configuration password: Admin2019
- Switch / Router telnet(vty) password: Telnet2019
- No L3 switches available on site: replaced with router + L2 switch
- PINGS Won't work on Hogent environment
- OSPF needed
- Configure NAT on outside & inside interfaces
- Use PAT and ACL to ensure connectivity -> each network separate in ACL, no summarize
- Workaround for patch panel not working: insert cable on island from internetport to management port (eg 2 -> 14)
- DHCP on interface to ISP for getting IP address -> static IP from lecturer -> `172.22.192.10`
- Linuxteam IP to Router4: `172.16.2.1`
- Static route on every router to outside

## TODO

- Discuss VPN with Linuxteam

## DONE

- Complete topology in Packet Tracer
- Added firewall server
- Rearranged using L2 switches
- VLAN 200 + 300 + 500 created + assigned to interfaces
- Ping between clients & router in VLAN 200 OK
- Ping between servers & router in VLAN 300 OK
- Ping between servers & router in VLAN 500 OK
- Ping between VLAN 500 & VLAN 300 OK
- Ping between VLANs OK
- Ping to Linuxteam OK
- Overall pings OK
- Routers
  - Serial connections
  - Hostname
  - Console password
  - Configuration password
  - Telnet(VTY) lines password
  - Copy running config -> startup config (not in practice)
  - IPs on interfaces
  - OSPF
  - ACL on edge router
  - NAT configuration
  - Static default route
  - Ensure overall connection (physical testing needed) -> OK
- Switches
  - Hostname
  - Console password
  - Configuration password
  - Telnet(VTY) lines password
  - Copy running config -> startup config (not in practice)
  - VLANs
- Clients & Servers 
  - IP configuration (DHCP + static)
  - DNS configuration
  - Default Gateways
  - Enable kilo2 DHCP + add pool

## Documentation per device

### On every router:

- Set a hostname: 
    - `hostname RouterX`
- Add an elevated access password:  
    - `enable secret Admin2019`
- Secure console line: 
    - `line console 0`
    - `password Console2019`
    - `login`
- Secure VTY lines:
    - `line vty 0 15`
    - `password Telnet2019`
    - `login`
- Enable encryption of passwords:
    - `service password-encryption`

### Router 1

- Configure interface to Zulu2 firewall:
    - `int g0/0/0`
    - `ip address 172.18.1.105 255.255.255.252`
    - `no shut`
- Configure interface to Router 3:
    - `int s0/1/1`
    - `ip address 172.18.3.2 255.255.255.252`
    - `no shut`
- Add a static default route to allow traffic to WAN:
    - `ip route 0.0.0.0 0.0.0.0 s0/1/1`
- Configure OSPF with ID 10:
    - `router ospf 10`
- Give Router 1 a router ID:
    - `router-id 1.1.1.1`
    - `clear ip ospf process`
- Add connected networks to OSPF configuration:
    - `network 172.18.1.104 0.0.0.3 area 0`
    - `network 172.18.3.0 0.0.0.3 area 0`
    - `network 172.18.1.108 0.0.0.3 area 0`
- Optional configuration to bypass Zulu2 firewall:
    - `int s0/1/0`
    - `ip address 172.18.1.109 255.255.255.252`
    - `no shut`

### Router 3

- Configure interface to Router 4:
    - `int s0/1/0`
    - `ip address 172.18.2.2 255.255.255.252`
    - `no shut`
- Configure interface to Router 1:
    - `int s0/1/1`
    - `ip address 172.18.3.1 255.255.255.252`
    - `no shut`
- Configure interface to Router 2:
    - `int g0/0/0`
    - `ip address LINUX IP`
    - `no shut`
- Add a static default route to allow traffic to WAN:
    - `ip route 0.0.0.0 0.0.0.0 s0/1/0`
- Configure OSPF with ID 10:
    - `router ospf 10`
- Give Router 3 a router ID:
    - `router-id 3.3.3.3`
    - `clear ip ospf process`
- Add connected networks to OSPF configuration:
    - `network 172.18.2.0 0.0.0.3 area 0`
    - `network 172.18.3.0 0.0.0.3 area 0`
    - `network LINUX IP 0.0.0.3 area 0`

### Router 4

- Configure inside interface Windowsteam (NAT/PAT) to Router 3:
    - `int s0/1/0`
    - `ip address 172.18.2.1 255.255.255.252`
    - `ip nat inside`
    - `no shut`
- Configure inside interface Linuxteam (NAT/PAT) to Router 2:
    - `int s0/1/1`
    - `ip address 172.16.2.1 255.255.255.252`
    - `ip nat inside`
    - `no shut`
- Configure outside interface using DHCP (NAT/PAT) to WAN:
    - `int g0/0/0`
    - `ip address dhcp`
    - `ip nat outside`
    - `no shut`
- Add a static default route to allow traffic to WAN:
    - `ip route 0.0.0.0 0.0.0.0 g0/0/0`
- Configure an access list which permits all LAN networks to connect to the internet via the outside interface:
    - `access-list 1 permit 172.18.2.0 0.0.0.3`
    - `access-list 1 permit 172.16.2.0 0.0.0.3`
    - `access-list 1 permit 172.18.1.0 0.0.0.63`
    - `access-list 1 permit 172.18.0.0 0.0.0.255`
    - `access-list 1 permit 172.18.1.96 0.0.0.3`
    - `access-list 1 permit 172.18.1.100 0.0.0.3`
    - `access-list 1 permit 172.18.1.64  0.0.0.31`
    - `access-list 1 permit 172.18.1.104 0.0.0.3`
    - `access-list 1 permit 172.18.1.108 0.0.0.3`
- Assign the access list to the outside interface (PAT usage):
    - `ip nat inside source list 1 interface g0/0/0 overload`
- Verify the NAT configuration:
    - `show ip nat translations`
    - `show ip nat statistics`
- Configure OSPF with ID 10:
    - `router ospf 10`
- Give Router 4 a router ID:
    - `router-id 4.4.4.4`
    - `clear ip ospf process`
- Add connected networks to OSPF configuration:
    - `network 172.18.2.0 0.0.0.3 area 0`
    - `network 172.16.2.0 0.0.0.3 area 0`
    - `network 172.22.0.0 0.0.255.255 area 0`

### Router 5 (Formerly L3 Switch5)

- Configure interface to Switch 5:
    - `int g0/0/0`
    - `ip address 172.18.1.7 255.255.255.192`
    - `no shut`
- Configure interface to Switch 4:
    - `int g0/0/1`
    - `ip address 172.18.0.1 255.255.255.0`
    - `no shut`
- Configure interface to Router 6:
    - `int s0/1/0`
    - `ip address 172.18.1.97 255.255.255.252`
    - `no shut`
- Add a static default route to allow traffic to WAN:
    - `ip route 0.0.0.0 0.0.0.0 s0/1/0`
- Configure OSPF with ID 10:
    - `router ospf 10`
- Give Router 5 a router ID:
    - `router-id 5.5.5.5`
    - `clear ip ospf process`
- Add connected networks to OSPF configuration:
    - `network 172.18.1.0 0.0.0.63 area 0`
    - `network 172.18.0.0 0.0.0.255 area 0`
    - `network 172.18.1.96 0.0.0.3 area 0`
- Configure passive interfaces to surpress OSPF updates to switches:
    - `passive-interface g0/0/0`
    - `passive-interface g0/0/1`

### Router 6 (Formerly L3 Switch 6)

- Configure interface to Switch 7:
    - `int g0/0/0`
    - `ip address 172.18.1.65 255.255.255.224`
    - `no shut`
- Configure interface to Zulu2 firewall:
    - `int g0/0/1`
    - `ip address 172.18.1.101 255.255.255.252`
    - `no shut`
- Configure interface to Router 5:
    - `int s0/1/0`
    - `ip address 172.18.1.98 255.255.255.252`
    - `no shut`
- Add a static default route to allow traffic to WAN:
    - `ip route 0.0.0.0 0.0.0.0 g0/0/1`
- Optional configuration to bypass Zulu2 firewall:
    - `int s0/1/1`
    - `ip address 172.18.1.110 255.255.255.252`
    - `no shut`
    - `ip route 0.0.0.0 0.0.0.0 s0/1/1`
- Configure OSPF with ID 10:
    - `router ospf 10`
- Give Router 6 a router ID:
    - `router-id 6.6.6.6`
    - `clear ip ospf process`
- Add connected networks to OSPF configuration:
    - `network 172.18.1.100 0.0.0.3 area 0`
    - `network 172.18.1.64 0.0.0.31 area 0`
    - `network 172.18.1.96 0.0.0.3 area 0`
    - `network 172.18.1.108 0.0.0.3 area 0`

- Configure passive interfaces to surpress OSPF updates to switch:
    - `passive-interface g0/0/0`

### On every switch:

- Set a hostname: 
    - `hostname SwitchX`
- Add an elevated access password:  
    - `enable secret Admin2019`
- Secure console line: 
    - `line console 0`
    - `password Console2019`
    - `login`
- Secure VTY lines:
    - `line vty 0 4`
    - `password Telnet2019`
    - `login`
- Enable encryption of passwords:
    - `service password-encryption`

### Switch 4

- Create a new VLAN with ID 200:
    - `vlan 200`
    - `name vlan200`
- Assign VLAN 200 to interfaces:
    - `int range f0/1-6`
    - `switchport mode access`
    - `switchport access vlan 200`

### Switch 5

- Create a new VLAN with ID 300:
    - `vlan 300`
    - `name vlan300`
- Assign VLAN 300 to interfaces:
    - `int range f0/1-7`
    - `switchport mode access`
    - `switchport access vlan 300`

### Switch 7

- Create a new VLAN with ID 500:
    - `vlan 500`
    - `name vlan500`
- Assign VLAN 500 to interfaces:
    - `int range f0/1-6`
    - `switchport mode access`
    - `switchport access vlan 500`

## Resources

### OSPF Configuration
- https://www.cisco.com/c/en/us/td/docs/ios-xml/ios/iproute_ospf/configuration/xe-16/iro-xe-16-book/iro-cfg.html

### DHCP on WAN
- https://www.cisco.com/c/en/us/td/docs/ios/12_2sb/12_2sba/feature/guide/sbaandhp.pdf
- https://community.cisco.com/t5/routing/configure-router-with-dynamic-ip-from-isp/td-p/2833165
- https://community.cisco.com/t5/switching/dhcp-on-outside-interface-with-nat/td-p/1748357
- https://study-ccna.com/configure-cisco-router-as-a-dhcp-client/

### Gateway of last resort (static routing)
- https://www.cisco.com/c/en/us/support/docs/ip/routing-information-protocol-rip/16448-default.html
- https://community.cisco.com/t5/switching/changing-gateway-of-last-resort/td-p/2187625

### NAT / PAT
- https://www.networkstraining.com/configuring-nat-on-cisco-routers/
- https://www.cisco.com/c/en/us/support/docs/ip/network-address-translation-nat/13773-2.html
- https://community.cisco.com/t5/security-documents/pat/ta-p/3114711
- https://www.computernetworkingnotes.com/ccna-study-guide/configure-pat-in-cisco-router-with-examples.html

### VLAN
- https://www.cisco.com/c/en/us/td/docs/switches/lan/catalyst4500/12-2/25ew/configuration/guide/conf/vlans.html
- https://www.cisco.com/c/en/us/td/docs/switches/datacenter/nexus5000/sw/configuration/guide/cli/CLIConfigurationGuide/VLANs.html
- https://www.ccnablog.com/inter-vlan-routing/

### Static routing
- https://community.cisco.com/t5/networking-documents/static-routes-with-next-hop-as-an-exit-interface-or-an-ip/ta-p/3146984
- https://www.cisco.com/c/en/us/support/docs/dial-access/floating-static-route/118263-technote-nexthop-00.html
- https://nurhariawanbulu.wordpress.com/2012/11/05/2-8-1-basic-static-route-configuration-lab/
- https://www.learncisco.net/courses/icnd-1/ip-routing-technologies/static-routing.html

### ACL
- https://www.cisco.com/c/en/us/td/docs/switches/lan/catalyst2960/software/release/12-2_52_se/configuration/guide/2960scg/swacl.html
- https://www.cisco.com/c/en/us/support/docs/security/ios-firewall/23602-confaccesslists.html
- https://www.orbit-computer-solutions.com/access-control-lists/
- https://www.certificationkits.com/cisco-certification/cisco-ccna-640-802-exam-certification-guide/cisco-ccna-acl-part-iv/

### Internet Access
- https://www.yourictmagazine.com/howtos/434-basics-to-configure-a-cisco-router-to-connect-to-internet.html
- https://www.cisco.com/c/en/us/support/docs/ip/domain-name-system-dns/24182-reversedns.html
- https://deltaconfig.com/cisco-router-initial-internet-access/
- CCNA Routing & Switching Course