## Testrapport mike2

Auteur(s) testrapport:   

### Controleer lan ip en dns ip
* Het lan ip moet 172.18.1.3 zijn
* Het dns ip moet 172.18.1.66 zijn

--> Success
### Controleren van naam en domein
* Log in als administrator van domein red
* Kijk in server manager -> local server
* Controleer of de computername "mike2" noemt
* Controleer of de server toegevoegd is aan het domein red.local

--> Success
### Controleer of firewall is uitgeschakeld
* De firewall zou uitgeschakeld moeten zijn

--> Success
### Controleer of de installatie en configuratie van SharePoint correct verlopen is.
* Probeer sharepoint central administration te openen 

-->Success

### controleer sharepoint toegang en installatie
* probeer sharepoint central administration te openen 

--> Success
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

# Controleren scripts

## Controleer lan ip en dns ip
* Het lan ip moet 172.18.1.3 zijn
* Het dns ip moet 172.18.1.66 zijn

--> Success
## Controleren van naam en domein
* Log in als administrator van domein red
* Kijk in server manager -> local server
* Controleer of de computername "mike2" noemt
* Controleer of de server toegevoegd is aan het domein red.local

--> Success
## Controleer of firewall is uitgeschakeld
* De firewall zou uitgeschakeld moeten zijn

--> Success
# Controleren SharePoint
## Controleer of de installatie en configuratie van SharePoint correct verlopen is.
* Probeer sharepoint central administration te openen 
* Dit kan door te surfen naar: ´http://mike2:11111´ (poort nr kan verschillend zijn, zal gemeld worden indien dit zo is)

--> Success
## controleer sharepoint webapplicatie/site collectie
* probeer eigen sharepoint webapplicatie te openen
* Dit kan door te surfen naar: ´http://mike2:8080´ (poort nr kan verschillend zijn, zal gemeld worden indien dit zo is)
* Deze pagina bevat de documentatie van het project

--> Success