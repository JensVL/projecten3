# Documentatie : November2

## Algemene info

Een member server in het domein red.local. Deze server is een Microsoft MS SQL-Server 
voor mike2 (Sharepoint) en voor delta2 (publieke webserver).

Naam server: November2 <br>
Domeinnaam: red.local <br>
IP-adres: 172.18.1.4 <br>
Aangemaakte user: Administrator <br>
Wachtwoord: Admin2019 <br>

### Installatie procedure

1. Installeer Windows Server 2019
2. Verander de hostnaam en ip-instellingen.
November2 heeft volgende instellingen:
   - Hostnaam: November 2
   - Ip-address: 172.18.1.4
   - Subnet mask: 255.255.255.192 
   - Default gateway: 172.18.1.1
   - Preferred DNS: 172.18.1.66
   - Alternate DNS: 172.18.1.67
 3. Installeer SSMS
 4. Voeg de server toe aan het domein red.local (Verander loginggegevens naar RED\Administrator, passwoord Admin2019)
 5. Restart de server.
 6. Installeer Microsoft Sql Server 2017
 7. Restart de server.
   
 #### Configuratie
- De basis configuratie van de server kan juist geconfigureerd worden door de scripts 1_hostname.ps1 en 2_settings.ps1 uit te voeren.

### Installeer Microsoft SQL Server Management Studio
- Voer het script SSMS.ps1 uit. Variablen kunnen verandert worden op basis van de file locaties.



