#  Network Documentation [Packet Tracer]

- Switch / Router console password: Console2019
- Switch / Router configuration password: Admin2019
- Switch / Router telnet(vty) password: Telnet2019

- No L3 switches available on site: replaced with router + L2 switch
- PINGS WON'T WORK on Hogent environment
- Configure NAT on outside & inside interfaces
- Use PAT and ACL to ensure connectivity
- Workaround for patch panel not working: insert cable on island from internetport to management port (eg 2 -> 14)
- DHCP on interface to ISP for getting IP address

## TODO

- ACL lists
- VLAN 400, 600, 700
- Discuss Router4 with Linuxteam
- Routers
  - Configuration continued
  - Ensure overall connection
  - Router1: Site to site VPN -> Router0 ?
  - Router4: ISP Google ?
  - Router3: ISP red.be ?
  - EIGRP continued

- Switches
  - VLANs continued
  - ...

## DONE

- Basic provisional topology in Packet Tracer
- Added firewall server
- Rearranged using L2 switches
- VLAN 200 + 300 + 500 created + assigned to interfaces
- Ping between clients & router in VLAN 200 OK (NO DHCP yet - PC5 has static IP to test)
- Ping between servers & router in VLAN 300 OK
- Ping between servers & router in VLAN 500 OK
- Ping between VLAN 500 & VLAN 300 OK
- Routers
  - Add serial connections
  - Hostname
  - Console password
  - Configuration password
  - Telnet(VTY) lines password
  - Copy running config -> startup config
  - Provisional IPs on interfaces
  - EIGRP base

- Switches
  - Hostname
  - Console password
  - Configuration password
  - Telnet(VTY) lines password
  - Copy running config -> startup config
  - Disabled unused interfaces

- Clients & Servers 
  - IP configuration (DHCP + static)
  - DNS configuration
  - Default Gateways
  - Enable kilo2 DHCP + add pool