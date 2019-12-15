# Documentatie Kilo2
## Algemene informatie
Kilo2 is een DHCP server die ervoor gaat zorgen dat er via PXI-boot clients kunnen worden aangemaakt. De clients kunnen een IP-Address krijgen binnen VLAN 200.

## Configuratie VM Virtual Box

* OS: Windows Server 2016 / Windows Server 2019
* Netwerkadapter: Host-only adapter ; subnet: `172.18.1.0/26`
* Storage: 40GB

Na het installeren van Windows Server moeten de bestanden met de scripts op de VM komen. Virtualbox guest additions kan hiervoor geïnstalleerd worden en hierna kan een shared folder gemaakt worden. Dit gaat ervoor zorgen dat de bestand beschikbaar zijn in de VM.
### Scripts
Een korte uitleg over wat in welke script te vinden is
#### Kilo2_1
Hierin wordt de ip-addressen geconfigureerd en wordt de naam `Kilo2` gegeven aan de server.
#### Kilo2_2
Hierin wordt de server toegevoegd aan het domein
#### Kilo2_3
Hierin wordt de DHCP feature geïnstalleerd. In dit script wordt ook de DHCP server geconfigureerd.

## Configuratie Server
### Netwerk configuratie

Op Kilo2 is er maar één adapter aanwezig. De configuratie van deze adapter is hetvolgende:
* Naam: `LAN`
* IP-Adres: `172.18.1.1`
* Subnetmask: `255.255.255.192`
* Default Gateway: `172.18.1.7`
* DNS Servers: `172.18.1.66` en `172.18.1.67`

Na het hernoemen van de DHCP Server naar Kilo2 moet de server herstart worden voordat `Kilo2_2.ps1` gerunt kan worden. Na het runnen van `Kilo2_2.ps1` is de Server toegevoegd aan het domein `red.local`. Na het runnen van `Kilo2_2.ps1` moet de server weer herstart worden.

### DHCP Configuratie

In Kilo2_3 wordt heel de DHCP geïnstalleerd en geconfigureerd.
Er wordt één scope gemaakt voor de clients die in vlan 200 komen. De scope heeft volgende configuratie
* Naam: `Vlan 200`
* Startrange: `172.18.0.2`
* Stoprange: `172.18.0.254`
* Subnetmasker: `255.255.255.0`
* Default Gateway: `172.18.0.1`
* DNS Servers: `172.18.1.66` en `172.18.1.67`
* Value option 66: `papa2.red.local`
* Value option 67: `\boot\x64\wdsnbp.com`
* Lease Duration: `2 Dagen`

Voor de DHCP worden er security groepen gemaakt namelijk `DHCP Administrators` en `DHCP Users`. Tenslotte wordt ook de DHCP Server geauthorizeerd zodat deze leases mag uitdelen binnen het domein `red.local`.