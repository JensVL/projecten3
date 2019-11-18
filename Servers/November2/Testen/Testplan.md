# Testplan november2

Auteur(s) testplan: Aron Marckx, Cédric Van den Eede

# Preconditie
- alfa2 en bravo2 zijn correct geconfigureerd en operationeel.<br>
- Ingelogd op November2 met onderstaande gegevens: <br>
    User: RED\Administrator <br>
    Password: Admin2019 <br>
 
# Testing

## Naam server en domein
1. Ga naar de Servermanager (open het manueel als het niet automatisch is gebeurd)
2. Klik op local server. 
3. Controleer onderstaande instellingen:
   - Computer name: November2
   - Domain name: red.local

## Netwerksettings
1. Ga naar de Servermanager (open het manueel als het niet automatisch is gebeurd)
2. Klik op local server en klik daarna op de 'host-only' adapter. 
3. Klik 'Internet Protocol version 4' aan, en klik op properties.
4. De netwerkconfiguratie moet als volgt zijn: <br>
  - Ip-address: 172.18.1.4 <br>
  - Subnet mask: 255.255.255.192 <br>
  - Default gateway: 172.18.1.7 <br>
  - Preferred dns: 172.18.1.66 <br>
  - Alternate dns: 172.18.1.67  <br>

Alternatieve testmethode:
1. Open de command line 
2. Voer het commando `ipconfig/all` uit
3. Controleer of alles hetzelfde is als hierboven.
  
## Nakijken correcte SQL Server installatie

1. Kijk de versie en installatiefolder na in "Program Files".
2. Indien de folder "Microsoft SQL Server" aanwezig is, is het geinstalleerd.
3. Open het cmd venster.
4. Typ het commando : `SQLCMD -S November2`
5. Typ het commando : `select @@version`
6. Typ het commando : `go`
7. Controleer of deze overeenkomt met de juiste versie. 

## Nakijken correcte SQL Server installatie

1. Open het cmd venster.
2. Typ het commando : `SQLCMD -S November2\MSSQLSERVER`
3. Typ het commando : `select @@version`
4. Bij het 2 > prompt, typ `go`
5. Controleer of deze overeenkomt met de juiste versie. 

## (Optioneel) Nakijken SQL Server instance name

1. Open het cmd venster.
2. Typ het commando : `services.msc`
3. Zoek naar een entry die begint met "SQL".
4. Kijk of de entry name overeenkomt met de gebruikte instance name.

## Testen Firewall
1. Open het cmd venster.
2. Typ het commando : `wf.msc`
3. inbound rules
4. Controleer of de rule **SQL port 1433** staat.




   
 
