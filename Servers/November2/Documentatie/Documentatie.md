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

1. Installeer Windows Server 2019/2016
2. Verander de hostnaam en ip-config.
   Hieronder de instellingen van November2:
   - Hostnaam: November2
   - Ip-address: 172.18.1.4
   - Subnet mask: 255.255.255.192 (/26)
   - Default gateway: 172.18.1.7
   - Preferred DNS (Alfa2) : 172.18.1.66
   - Alternate DNS (Bravo2) : 172.18.1.67
3. Voeg de server toe aan het domein red.local (Verander loginggegevens naar RED\Administrator, passwoord naar Admin2019)
4. Restart de server.
5. Installeer Microsoft Sql Server 2017 Entreprise Edition.
6. Installeer SSMS.
7. Restart de server.

Installatie voltooid.

### Configuratie Hostname en algemene configuratie (ip, gateway, domein)

De server kan juist geconfigureerd worden door de scripts 1_hostname.ps1 en 2_config.ps1 uit te voeren. Deze zal na het eerste script restarten.
Na het 2de script zal de server gerestart worden nadat het in het domein is toegevoegd.


### Installeer Microsoft SQL Server 2017

Voer het script 3_SQL.ps1 uit om Papa2 rechten te geven en SQL te installeren met juiste configuratie. Deze staat uitgeschreven in de code.
* LET OP: Ons basispad naar deze setup is via Desktop/Bureaublad.

Bij problemen kan je SQL handmatig installeren door de pdf te hanteren van het vak Windows Server.

### Installatie Microsoft SQL Server Management Studio

Voer het script 4_SSMS.ps1 uit om SQL Server Management Studio te installeren met de juiste configuratie.
Hierna zal de server een laatste keer restarten om de installaties te voltooien.
* LET OP: Ons basispad naar deze setup is via Desktop/Bureaublad.

Bij problemen kan je SSMS handmatig installeren door de pdf te hanteren van het vak Windows Server.


### Zeker na te kijken na installatie SQL en SSMS!

#### SQL Server Configuration Manager
- Open de SQL Server Configuration Manager.
- Kijk na of alle services runnnen.
- Normaal zou TCP/IP enabled moeten staan bij Client Protocols. Indien niet, enable deze dan.
- Rechtsklik bij SQL Services op 'SQL Server (MSSQLSERVER)' en selevcteer 'Properties'.
- Klik op 'FILESTREAM' en kijk of alle opties aangevinkt staan, ZEKER de allow remote acces.
- Klik dan op 'Service' en klik Automatic aan bij 'Start Mode'.
- Klik op OK en sluit de configuration manager.

#### SQL Server Management Studio
- Open SQL Server Management Studio.
- Verbind de SQL server met WIndows Authentication.
- Rechtsklik op de server en selecteer Properties en klik op Security.
- Bij Server Authentication kies je voor 'SQL Server and Windows Authentication Mode' indien dit nog niet het geval is.
- Klik op 'Connections' en selecteer 'Allow remote connections on this server'.
- Klik op 'OK' en sluit het venster.


### Aanmaken DB en User voor Delta2
- In "Microsoft SQL Server Management Studio", rechtsklik "Databases" en klik op "New Database".
- Vul bij de Database Name "Delta2" in klik op Ok.
![Afbeelding1](https://github.com/HoGentTIN/p3ops-1920-red/blob/November2/Servers/November2/images/1.png)
- Klik op "Security", rechtsklik op "Logins" en klik op "New Login".
- Vul bij "Login Name" "Delta2" in en selecteer "SQL Server Authentication". Kies als Password "Admin2019".
- Deselecteer "Enforce Password Policy" zodat SQL Server niet vraagt om nieuwe wachtwoord aan te maken bij login.
![Afbeelding3](https://github.com/HoGentTIN/p3ops-1920-red/blob/November2/Servers/November2/images/3.png)
- Klik links op "User Mapping" en selecteer het vakje naast de database "Delta2". Klik onderaan ook DB_OWNER aan!!!.
![Afbeelding4delta](https://github.com/HoGentTIN/p3ops-1920-red/blob/November2/Servers/November2/images/4%20delta.png)
- Klik op "OK" en de Gebruiker wordt aangemaakt.
- Deze gebruiker kan nu gebruikt worden door de Delta2 server!

### Aanmaken DB en User voor Mike2
- In "Microsoft SQL Server Management Studio", Klik op "Security".
- Rechtsklik op de domein user ex. RED\Administrator.
- Deselecteer "Enforce Password Policy" zodat SQL Server niet vraagt om nieuwe wachtwoord aan te maken bij login.
- Klik links op "User Mapping". Klik onderaan op DB_OWNER!
![Afbeelding4admin](https://github.com/HoGentTIN/p3ops-1920-red/blob/November2/Servers/November2/images/4%20admin%20red.png)
- Klik op "OK" en de Gebruiker wordt gewijzigd.
- Deze gebruiker kan nu gebruikt worden door de Mike2 server!

