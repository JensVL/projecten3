# Testplan PfSense:

#### Opmerking: Er wordt veronderstelt dat de gebruiker PfSense juist heeft geinstalleerd met de juiste netwerk adapters volgens de [Installatie documentatie](https://github.com/HoGentTIN/p3ops-1920-red/blob/master/Servers/Zulu2/Documentatie%20Installatie.md).

1. Zet IPv4 interfaces:  
```
LAN: 172.18.1.102
WAN: 192.168.0.177 (dhcp)
```
*Verwacht*: de LAN en WAN ip adressen zijn juist gezet voor deze PfSense testomgeving.    

2. Maak een firewall regel voor access op WebGUI met x -> host IP address.    
```
easyrule pass wan tcp 192.168.0.x 192.168.0.177 443  
```
*Verwacht*: firewall regel wordt toegevoegd zonder error output.  

3. Surf naar de WebGUI van je PfSense.  
```
https://192.168.0.177  
```  
*Verwacht*: De gebruiker ziet het login scherm van de PfSense WebGUI. De console output toont dat de gebruiker op de WebGUI is geconnecteerd.  

4. Log in en ga door de PfSense wizard. 
```
Username: admin  
Password: pfSense  
```
*Verwacht*: De gebruiker ziet het dashboard.  

5. Voeg VLans Toe  

*Verwacht*: Vlans 600 en 700 zijn aangemaakt en verbonden met interface.  

6. Voeg firewall regels Toe.  

*Verwacht*: De firewall regels zijn toegevoegd voor al de servers in het netwerk.  

7. Disable NAT.  

*Verwacht*: De Outbound NAT is disabled.  

8. Maak een backup.  

*Verwacht*: De gebruiker heeft een backup gekregen van de configuratie van PfSense in XML formaat.  

9. Laad een backup configuratie.  

*Verwacht*: Het systeem wordt herstart en de configuratie is juist veranderd.  
