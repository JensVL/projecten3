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

### Configuratie

De server kan juist geconfigureerd worden door de scripts 1_hostname.ps1 en 2_config.ps1 uit te voeren.
Hierdoor zal de server gerestart worden nadat het in het domein is toegevoegd.

### Groupmember voor Papa2

De server Papa2 moet adminrechten krijgen dus voegen we een member Papa2 toe aan de admin groep.

### Basis configuratie
- Configureer de basis configuratie via de gui.

#### AUTOMATISATIE
- De basis configuratie van de server wordt geconfigureerd door scripts 1_hostname.ps1 en 2_settings.ps1


### Installeer Microsoft SQL Server Management Studio
- Voer de SMSS-ENU-setup.exe uit en installeer.

#### AUTOMATISATIE
- Voer het script SSMS.ps1 uit. Variablen kunnen verandert worden op basis van de file locaties.


### Installatie Microsoft SQL Server 2017
BELANGRIJK: November2 moet in het domein zitten voordat de sql geÃ¯nstalleerd wordt. 


Zet de SETUP.exe lokaal op de pc (Op het Documents bv). Hierna druk op setup en volg de pdf (van sql vak windows server).

Opmerkingen bij de installatie volgens de pdf van olod "Windows server":
- Feature Selection: Alleen database/analysis services zijn nodig
- Database Engine Configuration: Verwissel naar mixed mode -> Het passwoord is "Project2019"

#### AUTOMATISATIE (werkt nog niet)
- Installeer SQL Server met de ConfigurationFile.ini, dit bevat alles van een werkende SQL Server op het red.local domein. Open de setup.exe, ga naar de tab "Advanced" en kies "Install based on configuration file"

### SQL SETUP
- Open "SQL Server Configuration Manager" in het Start Menu.
- Zorg er zeker voor dat bij SQL Server Services al deze Services runnen!!!
- Zorg er voor dat TCP/IP en mogelijks andere protocols Enabled zijn!!! Bij SQL Native... Configuration, SQL Server.... Check dit zeker!

- Klik bij SQL Server Services rechts op SQL Server (MSSQLSERVER).
- Selecteer Properties.
- Selecteer de FILESTREAM tab en zorg ervoor dat alle opties aangevinkt staan.
- Bij het tablad "Services" duid je bij Start Mode "Automatic" aan.
- Klik op OK en sluit SQL Server Configuration Manager.


- Open "Microsoft SQL Server Management Studio" in het Start Menu.
- Verbind door Windows Authentication met je SQL Server.
- Bovenaan rechtsklik op je Server -> Properties.
- In het nieuwe venster klik op "Security".
- Zorg er zeker voor dat "SQL Server and Windows Authentication Mode" is gekozen!!!


- Klik op "Connection" en selecteer "Allow remote connections on this server".
- Sla deze instellingen op.

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

