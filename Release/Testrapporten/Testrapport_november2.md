# **Testrapport November2**

Auteurs: Arno Van Nieuwenhove & Levi Goessens

## Testplan

### Resultaten naam server en domein

- Naam van server: November2
- Domein: red.local

### Resultaten Netwerksettings
- Naam: Ethernet
- Ip: 172.18.1.4
- Subnet: 255.255.255.192
- Default gateway: 172.18.1.7
- Preferred DNS server: 172.18.1.66
- Alternate DNS server: 172.18.1.67
  
Alternatieve testmethode:  

- Ok!
  
### Resultaten correcte SQL Server Installatie
1. Aanwezig in "Program Files".  
2. Folder "Microsoft SQL Server" is aanwezig.
3. Versie 2017 - 14.0.1000.169 
4. Services van SQL draaien.
  
### Resultaten testen firewall

- Firewall staat uit. 

## TestConfigNovember2 (powershell)
### Check-name, Check-ip-settings, Check-firewall

- √Computernaam is correct geconfigureerd
- √IP Address is correct geconfigureerd
- √Subnet Mask is correct geconfigureerd
- √Default Gateway is correct geconfigureerd
- √ALFA2 is goed geconfigureerd als DNS Server
- √BRAVO2 is goed geconfigureerd als backup DNS Server
- √Private firewall is disabled
- √Domain firewall is disabled
- √Public firewall is disabled
- 9 test(s) passes, 0 test(s) failed: