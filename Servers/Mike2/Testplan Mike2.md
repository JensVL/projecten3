# Testplan Server Mike2



Auteur(s) testplan: Tim Grijp, Elias Waterschoot

<<<<<<< Updated upstream
# Server Configuratie

Uit te voeren via script 'toevoegen domein.ps1'

## Controleer lan ip en dns ip
* Het lan ip moet 172.18.1.3 zijn
* Het dns ip moet 172.18.1.66 zijn
## Toevoegen aan het domein red hiervoor moet server alfa2 draaien
* Log in als administrator van domein red
* Kijk in server manager -> local server
* Controleer of de computername "mike2" noemt
* Controleer of de server toegevoegd is aan het domein red.local
## Controleer of firewall is uitgeschakeld
* De firewall zou uitgeschakeld moeten zijn


# SharePoint installatie

- Installatie windows features `roles.ps1`
- Installatie prerequisites via `prerequisites.ps1`
- Runnen van de setup `SPsetup.ps1`
- Creatie SharePoint Farm `SPfarm.ps1`

## Controleer of de installatie en configuratie van SharePoint correct verlopen is.
* Probeer sharepoint central administration te openen 

=======

## controleer lan ip en dns ip
* lan ip moet 172.18.1.3 zijn
* dns ip moet 172.18.1.66 zijn
## toevoegen aan het domein red hiervoor moet server alfa2 draaien
* log in als administrator van domein red
* kijk in server manager -> local server
* controleer of de computername "mike2" noemt
* controleer of de server toegevoegd is aan het domein red.local

## controleer sharepoint toegang en installatie

* probeer sharepoint central administration te openen 

>>>>>>> Stashed changes

