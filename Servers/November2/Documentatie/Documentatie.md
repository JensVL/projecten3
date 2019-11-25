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
   - Default gateway: 172.18.1.7
   - Preferred DNS: 172.18.1.66
   - Alternate DNS: 172.18.1.67
3. Voeg de server toe aan het domein red.local (Verander loginggegevens naar RED\Administrator, passwoord naar Admin2019)
4. Restart de server.
5. Installeer Microsoft Sql Server 2017 Entreprise Edition.
6. Restart de server.
7. Installeer SSMS.
8. Restart de server.

Installatie voltooid.

### Configuratie Hostname en algemene configuratie (ip, gateway, domein)

De server kan juist geconfigureerd worden door de scripts 1_hostname.ps1 en 2_config.ps1 uit te voeren.
Hierdoor zal de server gerestart worden nadat het in het domein is toegevoegd.


### Installeer Microsoft SQL Server 2017

Voer het script 3_SQL.ps1 uit om Papa2 rechten te geven en SQL te installeren met juiste configuratie. Deze staat uitgeschreven in de code.
LET OP: Ons basispad naar deze setup is via Documents.

### Installatie Microsoft SQL Server Management Studio

Voer het script 4_SSMS.ps1 uit om SQL Server Management Studio te installeren met de juiste configuratie.


### Aanmaken DB en User voor Delta2
- In "Microsoft SQL Server Management Studio", rechtsklik "Databases" en klik op "New Database".
- Vul bij de Database Name "Website" in klik op Ok. De Database wordt aangemaakt.


- Klik op "Security", rechtsklik op "Logins" en klik op "New Login".
- Vul bij "Login Name" "Website" in en selecteer "SQL Server Authentication". Kies als Password "Admin2019".
- Deselecteer "Enforce Password Policy" zodat SQL Server niet vraagt om nieuwe wachtwoord aan te maken bij login.


- Klik links op "User Mapping" en selecteer het vakje naast de database "Website". Klik onderaan ook DB_OWNER aan!!!.

- Klik op "OK" en de Gebruiker wordt aangemaakt.
- Deze gebruiker kan nu gebruikt worden door de Delta2 server!

### Aanmaken DB en User voor Mike2
- In "Microsoft SQL Server Management Studio", Klik op "Security".
- Rechtsklik op de domein user ex. RED\Administrator.
- Deselecteer "Enforce Password Policy" zodat SQL Server niet vraagt om nieuwe wachtwoord aan te maken bij login.
- Klik links op "User Mapping". Klik onderaan op DB_OWNER, DBCreator!!
- Klik op "OK" en de Gebruiker wordt gewijzigd.
- Deze gebruiker kan nu gebruikt worden door de Mike2 server!

