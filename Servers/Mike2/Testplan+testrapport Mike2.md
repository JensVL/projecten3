# Testplan Server Mike2



Auteur(s) testplan: Tim Grijp, Elias Waterschoot


## Voor je begint met het uitvoeren van scripts:

- Download sharepoint iso file: https://www.microsoft.com/en-us/download/details.aspx?id=57462
- Er moet een Active Directory opstaan met domein `red.local`
- De AD moet ip address `172.18.1.66` hebben
- Voor de zekerheid controleren onder tools -> AD users and computers of Mike2 er niet al staat (indien ja, verwijderen!)
- Het kan zijn dat als je met snapshots werkt in virtualbox dat hij een fatale error geeft. 
- Voor de configuratie van sharepoint moet er een sql server zijn genaamd november2, die het account Red\Administrator de rechten geeft om een databank aan te maken en te wijzigen. Dit is niet nodig voor de installatie. 

## Aanmaken Mike2

Maak de Mike 2 server aan in VirtualBox
- paswoord: `Admin2019`
- Zorg ervoor dat de 'host-only adapter' als 'ethernet 2' staat (dit is normaal de tweede adapter in virtualbox) , de andere is dan voor NAT (kan je controleren door in VirtualBox cable connected uit te vinken)
- Voor de Mike2 server kan er niet gewerkt worden met snapshots, dit zorgt voor een fatale error
- Maak een shared folder aan met een map 'scripts voor mike2' en een map 'sharepoint'
- De scripts moeten hier staan: `Z:/scripts voor mike2`
- Sharepoint iso file moet uitgepakt (rechtermuisknop - uitpakken) worden in: `Z:/sharepoint`


## Uitvoeren scripts

De scripts zijn zo ingsteld dat er automatisch opnieuw wordt opgestart en dat het volgende script automatisch start na uitvoeren van het huidige script
- Voer script `toevoegen domein` uit
    - deze zorgt voor de Mike2 instellingen en voegt het toe aan domein `red.local`
    - er kan in het begin een foutmelding verschijnen maar deze kan je negeren
    - computer start automatisch opnieuw op en logt automatisch in
- Script `prerequisites` wordt uitgevoerd
    - installatie van de prerequisites
    - restart automatisch
- Script `SPsetup` wordt uitgevoerd
    - installatie van SharePoint via `SPinstallation`
    - Database account wordt gevraagd
    - dit scherm kan je sluiten de installatie is hier compleet.
- Voor de configuratie voer je het script `SPFarm` uit. Hiervoor moet je kunnen connecteren met sql server `november2` 
- Voer SPWebApp.ps1 uit. Dit maakt de Site aan met documentatie.

# Testrapport Mike2
* zorg dat je ingelogd ben als administrator van het domein RED
## Controleer lan ip en dns ip
* Het lan ip moet 172.18.1.3 zijn met subnet 255.255.255.192
* Het dns ip moet 172.18.1.66 zijn met subnet 255.255.255.252
|Is dit in orde?|
|:---|
| Ja/Nee |
## Controleren van naam en domein
* Kijk in server manager -> local server
* Controleer of de computername "mike2" noemt
* Controleer of de server toegevoegd is aan het domein red.local
|Is dit in orde?|
|:---|
| Ja/Nee |
## Controleer of firewall is uitgeschakeld
* De firewall zou uitgeschakeld moeten zijn.
* Dit kan je bekijken in de windows defender firewall
|Is dit in orde?|
|:---|
| Ja/Nee |
# Controleren SharePoint
## Controleer of de installatie en configuratie van SharePoint correct verlopen is.
* Probeer sharepoint central administration te openen 
* Dit kan door te surfen naar: `http://mike2:11111` (poort nr kan verschillend zijn, zal gemeld worden indien dit zo is)
|Is dit in orde?|
|:---|
| Ja/Nee |
## controleer sharepoint webapplicatie/site collectie
* probeer eigen sharepoint webapplicatie te openen
* Dit kan door te surfen naar: `http://mike2:8080` (poort nr kan verschillend zijn, zal gemeld worden indien dit zo is)
* Deze pagina bevat de documentatie van het project
|Is dit in orde?|
|:---|
| Ja/Nee |
