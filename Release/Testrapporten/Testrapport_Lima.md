### Testplan Lima2

Getest door Aron Marckx en Cédric van Den Eede

## De server naam en domein

1. De server naam is Lima2.
2. Lima2 is het domein automatisch gejoined.

OK

## Controleren dat alle volumes aangemaakt zijn

Open Server Manager -> File and Storage Services -> Disks

Klik op de disk met nummer 0

- Controleren dat er 3 volumes aanwezig zijn op disk 0
- Optioneel volume: 'C:' -> Wordt aangemaakt bij de installatie van de Windows Server
- Controleren of volume 'D:' en 'E:' aangemaakt zijn op disk 0

OK

Klik op de disk met nummer 1

- Controleren dat er 6 volumes aangemaakt zijn op disk 1
- Controleren dat de volgende volumes aangemaakt zijn:
- H:
- F:
- P:
- Q:
- Y:
- G:

OK

## De File System Labels van de volumes controleren

Open Server Manager -> File and Storage Services -> Volumes

- Volume: 'H:' met File System Label: 'AdminData'
- Volume: 'F:' met File System Label: 'ITData'
- Volume: 'P:' met File System Label: 'ProfileDirs'
- Volume: 'Q:' met File System Label: 'ShareVerkoop'
- Volume: 'D:' met File System Label: 'VerkoopData'
- Volume: 'E:' met File System Label: 'OntwikkelingData'
- Volume: 'Y:' met File System Label: 'HomeDirs'
- Volume: 'G:' met File System Label: 'DirData'

OK

## Controleren dat alle shares aangemaakt zijn

Open Server Manager -> File and Storage Services -> Shares

- Controleren dat er 8 shares in totaal zijn
- Controleren dat de volgende shares aangemaakt zijn:
- AdminData
- DirData
- HomeDirs
- ITData
- OntwikkelingData
- ProfileDirs
- shareVerkoop
- VerkoopData

OK

## De dagelijske schaduw kopie

Open de Task Scheduler -> Task Scheduler (local) -> Task Scheduler Library

- Controleren dat een nieuwe task is toegevoegd met de naam 'ShadowCopy'
- Deze taak heeft een trigger die elke dag om 17:00 geactiveerd wordt
- Om een snellte test uit te voeren kan je op de taak klikken en deze manueel uitvoeren. Rechter muis klik op de taak en kies voor run.
- Controleer volume AdminData. Dit volume bevat een nieuwe schaduw kopie. Dit kan je nazien door naar AdminData te gaan -> Properties -> Shadow Copies.
- Het veld "Shadow copies of selected volume bevat een nieuw veld met de huidige tijd en datum.

nog niet OK, probleem met Capacity

## Share Permissies

1. Log in als gebruikder CedricD met wachtwoord Administrator2019

2. Ga naar bestanden -> Computer en ga naar de verschillende fileshares

3. Ga in de fileshare van de afdeling Ontwikkeling en probeer een nieuwe file aan te maken -> dit zou moeten lukken

4. Ga in de fileshare van homedir en probeer een nieuwe file aan te maken -> dit zou moeten lukken

5. ga in de fileshare van Directie en probeer een nieuwe file aan te maken -> dit zou NIET mogen lukken.

OK, misschien iets duidelijker met pad en waar de file aan te maken

## maximumcapaciteit share per user

1. neem een folder of bestand van 150MB en probeer het in de fileshare Ontwikkeling te zetten -> dit moet lukken

2. verwijder het 150MB bestand of folder

3. probeer nu een folder/bestand van 250MB in de fileshare Ontwikkeling te zetten -> dit mag NIET lukken.

OK, iets meer verduidelijking met pad
