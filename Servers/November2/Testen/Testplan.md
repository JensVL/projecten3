# Testplan november2

Auteur(s) testplan: Aron Marckx, Cédric Van den Eede

# Preconditie
- alfa2 en bravo2 juist opgesteld en actief.<br>
- Ingelogd op November2 met volgende gegevens: <br>
    User: RED\Administrator <br>
    Password: Admin2019 <br>
 
# Testing
## Naam server en domein
1. Ga naar de Servermanager en klik op local server. 
2. Controleer onderstaande instellingen:
   - Computer name: November2
   - Domain name: red.local

## Netwerksettings
1. Ga naar de Servermanager.
2. Klik op local server en klik daarna op de 'host-only' adapter. 
3. Klik 'Internet Protocol version 4' aan, en klik op properties.
4. De netwerkconfiguratie moet als volgt zijn: <br>
  - Ip-address: 172.18.1.4 <br>
  - Subnet mask: 255.255.255.192 <br>
  - Default gateway: 172.18.1.7 <br>
  - Preferred dns: 172.18.1.66 <br>
  - Alternate dns: 172.18.1.67  <br>

Alternatieve testmethode:
1. Open de cmd 
2. Voer het commando `ipconfig/all` uit
3. Controleer de netwerkconfiguratie zoals hierboven.

## Testen Firewall
1. Open 'Status van firewall' controleren in de zoekfunctie.
2. Kijk of deze is uitgeschakeld.  

## Nakijken correcte SQL Server installatie
1. Kijk de versie en installatiefolder na in 'Program Files'.
2. Indien 'Microsoft SQL Server' in de map staat, is het geïnstalleerd.
3. Open de cmd.
4. Typ het commando : `SQLCMD -S November2`
5. Typ het commando : `select @@version`
6. Typ het commando : `go`
7. Kijk na of het de juiste versie is. 

1. Open de cmd.
2. Typ het commando : `SQLCMD -S November2\MSSQLSERVER`
3. Typ het commando : `select @@version`
4. Typ `go`
5. Kijk na of het de juiste versie is. 

## Nakijken SQL Server instance name
1. Open de cmd.
2. Typ het commando : `services.msc`
3. Ga naar de entry beginnende met 'SQL'.
4. Kijk na of de entry naam overeenkomt met de instance naam.






   
 
