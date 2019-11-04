# Testplan Zulu2

## Doel
### Installatie PfSense
- Download de PfSense Iso
- Maak de Virtualbox VM aan
- Installeer PfSense op de VM
### Configuratatie PfSense
- Stel de IPv4 interfaces in
- Navigeer naar de WebGUI
- Log in op de WebGUI
- Laad het PfSense configuratiebestand

## Te Testen

We testen deze firewall met behulp van een Virtualbox VM. Indien nodig kan extra informatie gevonden worden in de documentatie voor [installatie](Documentatie%20Installatie.md) en [configuratie.](Documentatie%20Configuratie.md)

### Installatie PfSense

1. Download de [PfSense](https://www.pfsense.org/download/) Iso file.
2. Maak een VM in Virtualbox met de juiste configuratie.
* Name : Zulu2
* Type : BSD 
* Version : FreeBSD (64-bit)
* Memory size en Hard disk(VDI): Default
* Storage: Dynamically Allocated  

*Verwacht*: de VM Zulu2 is aangemaakt.  

2.1 Configureer de netwerk settings.
* Voeg een Host-only adapter toe met ip 192.168.1.10/24, DHCP disabled
* Ga naar de netwerk settings van de VM en kies volgende adapters.
```
Adapter 1: NAT/Bridged Adapter (maakt niet uit, we gaan via de LAN interface op de WebGUI)
Adapter 2: Host-only Adapter (die je juist hebt gemaakt)
```
*Verwacht*: de netwerk settings op de VM zijn juist geconfigureerd.

3.1 Installeer PfSense op de VM
* Ga naar de storage settings van de VM en voeg de PfSense Iso file toe.
* Accepteer de eerste pop-up venster.
* Selecteer Install. 
* Kies keymap(be.iso.kb). 
* Ga door de installatie met default waarden.
* Je wenst geen manuele modificatie uit te voeren, selecteer No.  
* Reboot de VM en verwijder iso file uit Virtual Machine. 

*Verwacht*: PfSense is geïnstalleerd op de VM en de gebruiker staat op het menu.

### Configuratie PfSense

4. Zet IPv4 interfaces:  
```
LAN: 192.168.1.1/24 (geen DHCP/http kiezen)
WAN: 10.0.2.15 (NAT)
```
*Verwacht*: De LAN en WAN ip adressen zijn juist gezet voor deze PfSense testomgeving.    

5. Surf naar de WebGUI van je PfSense.  
```
https://192.168.1.1  
```  
*Verwacht*: De gebruiker ziet het login scherm van de PfSense WebGUI. De console output toont dat de gebruiker op de WebGUI is geconnecteerd. Ga naar stap 5.1 indien dit niet gaat.  

5.1. Voeg firewall regel toe voor access op WebGUI

* Open de VM, ga naar de Shell (8) en maak een firewall regel voor access op WebGUI.   
```
easyrule pass lan tcp 192.168.1.10 192.168.1.1 443  
```
* Indien dit niet werkt kan je heel de firewall tijdelijk disablen.
```
pfctl -d
```
*Verwacht*: firewall regel wordt toegevoegd, de gebruiker zou toegang hebben op de WebGUI.  

6. Log in de WebGUI en ga door de PfSense wizard. 
```
Username: admin  
Password: pfsense  
```
*Verwacht*: De gebruiker ziet het dashboard.  

7. Laad de configuratie file.  

* Ga naar Diagnostics -> Backup & Restore 
* Restore Area: All  
* Configuration file: [Zulu2.xml](/test-env/Zulu2.xml)
* Click restore configuration.

*Verwacht*: Het systeem wordt herstart en het systeem is volledig geconfigureerd.