#  Network Documentation [Packet Tracer]

- Switch / Router console password: Console2019
- Switch / Router configuration password: Admin2019
- Switch / Router telnet(vty) password: Telnet2019

- No L3 switches available on site: replaced with router + L2 switch

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
  - ...

- Switches
  - VLANs continued
  - ...

- Make pings between VLANs work
- ...

## DONE

- Basic provisional topology in Packet Tracer
- Added firewall server
- Rearranged using L2 switches
- VLAN 200 + 300 + 500 created + assigned to interfaces
- Ping between clients & router in VLAN 200 OK (NO DHCP yet PC5 has static IP to test)
- Ping between servers & router in VLAN 300 OK
- Ping between servers & router in VLAN 500 OK
- Routers
  - Add serial connections
  - Hostname
  - Console password
  - Configuration password
  - Telnet(VTY) lines password
  - Copy running config -> startup config
  - Provisional IPs on interfaces

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