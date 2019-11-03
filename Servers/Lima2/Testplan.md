### Testplan Lima2

## De server naam en domein

1. De server naam is Lima2.
2. Lima2 is het domein auotmatisch gejoined.

## Controleren dat alle volumes aangemaakt zijn

Open Server Manager -> File and Storage Services -> Volumes

Disk1:
1. 'C:' met label 'System'
2. 'D:' met label 'VerkoopData'
3. 'E:' met label 'OntwikkelingData'

Disk2:
1. 'F:' met label 'ITData'
2. 'G:' met label 'DirData'
3. 'H:' met label 'AdminData'
4. 'Y:' met label 'HomeDirs'
5. 'Z:' met label 'ProfileDirs'

* Alle volumes zijn 

## Controleren dat alle shares aangemaakt zijn

Open Server Manager -> File and Storage Services -> Shares

* Er zijn 6 shares
De shares:
1. AdminData
2. DirData
3. HomeDirs
4. ITData
5. ProfileDirs
6. ShareVerkoop

## De schaduw kopie

Open de Task Scheduler -> Task Scheduler (local) -> Task Scheduler Library

* Controleren dat een nieuwe task is toegevoegd met de huidige naam 'TEST10'.
* Deze taak heeft een trigger die om 5pm activeert en elke dag.
* Om een snellte test uit te voeren kan je op de taak klikken en deze manueel uitvoeren.
* Controleer volume AdminData. Dit volume bevat een nieuwe schaduw kopie. Dit kan je nazien door naar AdminData te gaan -> Properties -> Shadow Copies.
* Het veld "Shadow copies of selected volume bevat een nieuw veld met de huidige tijd en datum.

## Share Permissies

1. Log in als gebruikder CedricD met wachtwoord Administrator2019

2. Ga naar bestanden -> Computer en ga naar de verschillende fileshares

3. Ga in de fileshare van de afdeling Ontwikkeling en probeer een nieuwe file aan te maken -> dit zou moeten lukken

4. Ga in de fileshare van homedir en probeer een nieuwe file aan te maken -> dit zou moeten lukken

5. ga in de fileshare van Directie en probeer een nieuwe file aan te maken -> dit zou NIET mogen lukken.


## maximumcapaciteit share per user

1. neem een folder of bestand van 150MB en probeer het in de fileshare Ontwikkeling te zetten -> dit moet lukken

2. verwijder het 150MB bestand of folder

3. probeer nu een folder/bestand van 250MB in de fileshare Ontwikkeling te zetten -> dit mag NIET lukken.




