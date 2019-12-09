## Test plan

### Controleer lan ip en dns ip
* Het lan ip moet 172.18.1.3 zijn
* Het dns ip moet 172.18.1.66 zijn

### Controleren van naam en domein
* Log in als administrator van domein red
* Kijk in server manager -> local server
* Controleer of de computername "mike2" noemt
* Controleer of de server toegevoegd is aan het domein red.local

### Controleer of firewall is uitgeschakeld
* De firewall zou uitgeschakeld moeten zijn

### Controleer of de installatie en configuratie van SharePoint correct verlopen is.
* Probeer sharepoint central administration te openen 


### controleer sharepoint toegang en installatie
* probeer sharepoint central administration te openen 

## Procedure/Documentation

### Installeren benodigde servers
1) Alfa2
2) November2
3) Mike2

Ik heb ervoor gezorgd dat ze elk een toegang hebben tot de shared folder met alle scripts op mijn host pc.

### uitvoeren scripts Mike2
1) toevoegen domein.ps1
2) roles.ps1
3) prerequisites.ps1
4) SPsetup.ps1
5) SPFarm.ps1

## Test report

### output scripts
#### toevoegen domein.ps1
Geen errors, computer herstarten is nodig.

#### roles.ps1
Geen errors

#### prerequisites.ps1
Geen errors, heb het pad naar de .exe moeten aanpassen naargelang de locatie mijn folder zich bevond

#### SPsetup.ps1
Script runt vlot tot hij vraagt voor de database server, na het ingeven van "November2" heb ik de knop "Retrieve Database Names" gedrukt.
Dit gaf een error na een korte tijd laden.

Error: Failed to connect to the database server. Ensure the database server exists, is a Sql server, and that you have the appropriate permissions to access the server. ...

