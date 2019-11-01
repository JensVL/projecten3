# Documentatie : November2

Auteurs: Aron Marckx, Cédric Van den Eede

## Algemene info

Een member server in het domein red.local. Deze server is een Microsoft MS SQL-Server
voor mike2 (Sharepoint) en voor delta2 (publieke webserver).

Naam server: November2 <br>
Domeinnaam: red.local <br>
IP-adres: 172.18.1.4 <br>
Aangemaakte user: Administrator <br>
Wachtwoord: Admin2019 <br>
Domein user: RED\Administrator <br>
Domein wachtwoord: Admin2019 <br>

### Installatie procedure

1. Installeer Windows Server 2019
2. Verander de hostnaam en ip-config.
   Hieronder de instellingen van November2:
   - Hostnaam: November2
   - Ip-address: 172.18.1.4
   - Subnet mask: 255.255.255.192 (/26)
   - Default gateway: 172.18.1.1
   - Preferred DNS: 172.18.1.66
   - Alternate DNS: 172.18.1.67
3. Voeg de server toe aan het domein red.local (Verander loginggegevens naar RED\Administrator, passwoord naar Admin2019)
4. Restart de server.
5. Installeer Microsoft Sql Server 2017 Entreprise Edition.
6. Restart de server.
7. Installeer SSMS.
8. Restart de server.

Installatie voltooid.

#### Configuratie

De server kan juist geconfigureerd worden door de scripts 1_hostname.ps1 en 2_config.ps1 uit te voeren.
Hierdoor zal de server gerestart worden nadat het in het domein is toegevoegd.

### Installeer Microsoft SQL Server 2017

- Opmerking: Zorg ervoor dat November2 in het domein red.local zit voordat Sql en SSMS worden geïnstalleerd.

Zet de SQLServer2017.exe op het bureaublad (andere locatie werkt ook mits aanpassing in het script).
Voer het script 3_SQL.ps1 uit. Config kan aangepast worden via ConfigurationFile, bestandslocaties mogelijk ook.

### Installeer SQL Server Management Studio

Zet de SSMS.exe op het bureaublad (andere locatie werkt ook mits aanpassing in het script).
Voer het script 4_SSMS.ps1 uit. Bestandslocaties kunnen gewijzigd worden in het script.
