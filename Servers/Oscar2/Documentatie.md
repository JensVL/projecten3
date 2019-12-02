# Technische documentatie

## Nodige software

Om de PRTG server op een correcte mannier te installeren hebben we verschillende programma's nodig:
1. Windows Server 2016 ISO: https://www.microsoft.com/en-us/evalcenter/evaluate-windows-server-2016?filetype=ISO
2. Virtualbox: https://www.virtualbox.org/wiki/Downloads

## Creatie windows server 2016

Open virtualbox en navigeer bovenaan naar `Machine` en klik op `Nieuw...`. Dan krijgt u een wizard te zien zoals in onderstaande schermopname.
Zorg er zeker voor dat uw machine minimum 2gb ram krijgt.

![Figure 1-1](Images/InstallatieWindows2016_1.png?raw=true)

Klik daarna dan op `Aanmaken`. Dan maak je een harde schrijf aan. Minimum 30 gb is nodig voor deze installatie. 

![Figure 1-2](Images/InstallatieWindows2016_2.png?raw=true)

Klik daarna op `Aanmaken`. Nu wordt een virtuele machine aangemaakt. Nu kan u de virtuele machine starten door op de groene knop `Starten` te drukken.

![Figure 1-3](Images/InstallatieWindows2016_3.png?raw=true)

Nu wordt de virtuele machine gestart. Je zal de vraag krijgen om een opstartschijf toe te voegen. Geef het pad op naar de Windows2016 ISO die je hebt gedownload.

![Figure 1-4](Images/InstallatieWindows2016_4.png?raw=true)

Daarna wordt de ISO gestart en krijg je de vraag naar taal en toetsenbord. Vul dit in zoals hieronder.

![Figure 1-5](Images/InstallatieWindows2016_5.png?raw=true)

Geef dan aan dat je de DesktopExperience wil installeren van WindowsServer 2016.

![Figure 1-6](Images/InstallatieWindows2016_6.png?raw=true)

Accepteer de License Terms

![Figure 1-7](Images/InstallatieWindows2016_7.png?raw=true)

Klik op `Custom Install`.

![Figure 1-8](Images/InstallatieWindows2016_8.png?raw=true)

Klik op `Next`

![Figure 1-9](Images/InstallatieWindows2016_9.png?raw=true)

Nu wordt WindowsServer2016 geinstalleerd. Dit kan enkele minuten duren. Je weet dat de installatie gedaan is als je de windows desktop kan zien. Kies een wachtwoord en log in. Nu is het aangeraden om de machine te updaten naar de laatste versie. Herstart de virtuele machine daarna.

## Toevoegen aan een domein (bestaat al)

Nu moeten we aan een domein toegevoegd worden. Indien u lokaal bezig bent dan zal u een 2de server moeten aanmaken en die een domeincontroller maken. Ga hiervoor naar de volgende stap. Indien er al een domein is binnen uw netwerk dan kan u zich toevoegen aan dat domein door server manager te open en te navigeren naar `Local Server` en klik op uw computernaam dan zou er een vester moeten openen zoals hieronder.

![Figure 1-10](Images/ToevoegenDomein.png?raw=true)

Klik dan op `Change...` en vul de naam en het domein in.

![Figure 1-11](Images/ToevoegenDomein_2.png?raw=true)

Vul dan de login gegevens in van uw domein. U kan de volgende stap overslaan.

## Toevoegen aan een domein (bestaat nog niet)

