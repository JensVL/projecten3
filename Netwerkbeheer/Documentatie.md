#  Network Documentation [Packet Tracer]

- Switch / Router console password: Console2019
- Switch / Router configuration password: Admin2019
- Switch / Router telnet(vty) password: Telnet2019
- No L3 switches available on site: replaced with router + L2 switch
- PINGS WON'T WORK on Hogent environment
- OSPF needed
- Configure NAT on outside & inside interfaces
- Use PAT and ACL to ensure connectivity
- Workaround for patch panel not working: insert cable on island from internetport to management port (eg 2 -> 14)
- DHCP on interface to ISP for getting IP address -> getting static IP soon from lecturer
- Linuxteam IP to Router4: `172.16.2.1`

## TODO

- VLAN 600, 700 (need zulu2 server)
- Discuss Router4 with Linuxteam
- Routers
  - Ensure overall connection (physical testing needed)
  - Router1: Site to site VPN -> Router0 ?
  - Router4: ISP Google ?
  - Router3: ISP red.be ?

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
  - Add serial connections
  - Hostname
  - Console password
  - Configuration password
  - Telnet(VTY) lines password
  - Copy running config -> startup config (not in practice)
  - IPs on interfaces
  - OSPF
  - ACL on edge router
- Switches
  - Hostname
  - Console password
  - Configuration password
  - Telnet(VTY) lines password
  - Copy running config -> startup config (not in practice)
  - Disabled unused interfaces
  - VLANs
- Clients & Servers 
  - IP configuration (DHCP + static)
  - DNS configuration
  - Default Gateways
  - Enable kilo2 DHCP + add pool

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