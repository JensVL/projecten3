# Documentatie Kilo2
## Algmene informatie
### Locaties
De locaties van de scripts die gebruikt moeten worden staan in `test-env/provisioning/`. Er is een test-script aanwezig alsook de verwachte resultaten. Deze bevinden zich in `testen/`. Het testscript heet `test_script.ps1` en de verwachte resultaten heet `correcte_antw_test_script.md`.
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
* Value option 67: `\smsboot\x64\wdsnbp.com`
* Lease Duration: `2 Dagen`

Voor de DHCP worden er security groepen gemaakt namelijk `DHCP Administrators` en `DHCP Users`. Tenslotte wordt ook de DHCP Server geauthorizeerd zodat deze leases mag uitdelen binnen het domein `red.local`.