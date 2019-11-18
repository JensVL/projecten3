# Testplan Papa2: SCCM server

(Een testplan is een *exacte* procedure van de handelingen die je moet uitvoeren om aan te tonen dat de opdracht volledig volbracht is en dat aan alle specificaties voldaan is. Een teamlid moet aan de hand van deze procedure in staat zijn om de tests uit te voeren en erover te rapporteren (zie testrapport). Geef bij elke stap het verwachte resultaat en hoe je kan verifiëren of dat resultaat ook behaald is. Kies zelf de structuur: genummerde lijst, tabel, secties, ... Verwijder deze uitleg als het plan af is.)

Auteur(s) testplan: Laurens Blancquaert-Cassaer en ...

# BELANGRIJK:
Indien je om Papa2 op te stellen een error krijgt bij het opzetten van de Server met Vagrant op Windows **(Met een Linux host werkt Vagrant perfect)** dan moet je het volgende doen om de server te kunnen opzetten om hem te testen: 
(De error in kwestie gebeurt net nadat de hostname wordt ingesteld en de VM reboot. Het is een lange WSMANERROR)

         1) Doe Vagrant up zoals je normaal doet.
         2) Wanneer de error voorkomt en vagrant stopt open de VM manueel in Virtualbox (er is een GUI dus je kan hem gebruiken zoals een normale Windows Server VM)
         3) Aangezien de hostname al succesvol is aangepast moeten we RUNFIRST.ps1 niet meer uitvoeren. 
         4) Op de Papa2 Windows Server VM moet je nu inloggen met username: vagrant password: vagrant (LET OP IS IN QUERTY!)
         5) De Vagrant error gebeurde voor de Shared folders correct werden ingesteld. Dit moeten we nu dus doen. Open This PC en open de network tab. Je krijgt een message dat "Device Discovery" aan moet staan. Zet dit aan.
         6) In de network tab (van this PC) klik op VBOXSVR dan op \\VBOXSVR\vagrant en kopieer alle bestanden in deze map naar "C:\Vagrant" (maak de directory aan indien hij nog niet bestaat) 
         5) Open PowerShell ISE als administrator en voer het volgende commando uit:
         
                  Set-ExecutionPolicy Unrestricted
         
         6) Klik in Powershell ISE op "open script" en ga naar "C:\Vagrant" en voer het script 2_BasicConfig.ps1 uit
         7) Restart server
         8) Als dit klaar is voer 3_SCCMPrereqInstall.ps1 uit.
         9) Papa2 is nu correct opgesteld (Task sequence moet manueel gemaakt worden met GUI zie documentatie van Ferre)

**VOOR ALLE TESTS MOET JE INGELOGD ZIJN ALS: RED\Administrator**

## Voorbereiding op SCCM installatie:
### Uit te voeren stappen:
Is Papa2 aan het red.local domain toegevoegd?
1) Server Manager > local server
2) Check of er onder "Computer name", "Domain = red.local" staat

Checken of ADK, WindowsPE en MDT geïnstalleerd zijn:
1) Ga naar de zoekbalk en geef "apps" in. Open hierna "Add or remove programs"
2) Sorteer volgens "size". Je zou ADK, WindowsPE en MDT vanboven moeten zien staan.

| Nr test | Wat moet er getest worden | In orde? |
| :--- | :--- | :--- |
| 1 | Is Papa2 aan het red.local domain toegevoegd? | Ja/Nee |
| 2 | Is Windows Assessment and Deployment Toolkit (ADK) geïnstalleerd?| Ja/Nee |
| 3 | Is de WindowsPE addon voor ADK geïnstalleerd? | Ja/Nee |
| 4 | Is Microsoft Deployment Toolkit (MDT) geïnstalleerd? | Ja/Nee |



##  SCCM Installatie + configuratie:
### Uit te voeren stappen:
Is SCCM correct geïnstalleerd op de Papa2 Server?
Ga naar de zoekbalk en voer "console" in. Open "Configuration Manager Console". Als deze correct opent is SCCM geïnstalleerd.

Is de integratie tussen MDT en SCCM goed geconfigureerd?
1) Ga naar de zoekbalk en voer "integration" in. Open "Configure ConfigMgr Integration".
2) Als je de checkmark automatisch op "Remove MDT extension for Configuration Manager" ziet staan is de integratie correct. 

Zijn de boundary groups correct aangemaakt in SCCM?|
1) Ga naar de zoekbalk en voer "console" in. Open "Configuration Manager Console".
2) Navigeer naar: Administration > Hierarchy configuration > boundary groups
3) Indien je hier een group "ADsite" ziet staan met member count 1 zijn de groups correct aangemaakt.

Is de SCCM network access account ingesteld?
1) Ga naar de zoekbalk en voer "console" in. Open "Configuration Manager Console".
2) Navigeer naar: Administration > overview > site configuration > sites
3) Hier zie je de "RED" site. Selecteer de RED site (maar open hem niet) en klik nu vanboven in de toolbar op "settings" daarna "configure site components" en tenslotte software distribution.
4) Ga naar de network access account tab. Hier zou je RED\Administrator moeten zien staan.

Check of de discovery methods voor SCCM correct zijn ingesteld:
1) Ga naar de zoekbalk en voer "console" in. Open "Configuration Manager Console".
2) Navigeer naar: Administration > Hierarchy configuration > Discovery method
3) Check of alle 6 de discovery methods hun status op "enabled" staat

Check of de PXE settings in SCCM correct zijn voor client Deployment:
1) Ga naar de zoekbalk en voer "console" in. Open "Configuration Manager Console".
2) Navigeer naar Administration > Overview > Site configuration > Servers and site System roles
3) Selecteer "Papa2.red.local". 
4) Rechtermuisknop op "Distribution point" en kies properties
5) Ga naar de PXE tab. 
6) Check volgende opties:
"Enable PXE support for clients" moet aan staan
"Allow this distribution point to respond to incoming PXE requests" moet aan staan
"Enable unknown computer support" moet aan staan
"Respond to PXE requests on all network interfaces" moet aangevinkt zijn

| Nr test | Wat moet er getest worden | In orde? |
| :--- | :--- | :--- |
| 1 | Is SCCM correct geïnstalleerd op de Papa2 Server? | Ja/Nee |
| 2 | Is de integratie tussen MDT en SCCM goed geconfigureerd? | Ja/Nee |
| 3 | Zijn de boundary groups correct aangemaakt in SCCM?| Ja/Nee |
| 4 | Is de SCCM network access account ingesteld? | Ja/Nee |
| 5 | Check of de discovery methods voor SCCM correct zijn ingesteld | Ja/Nee |
| 6 | Check of de PXE settings in SCCM correct zijn voor client Deployment | Ja/Nee |




## Windows 10 Client Deployment / Task Sequence
### Uit te voeren stappen:
VM aanmaken: De eerste stap is een nieuwe virtuele machine aanmaken in Virtualbox met volgende specificaties:
                           
                  Name: CLIENT1
                  Windows 10 (64-bit)
                  2048mb RAM
                  1 hard drive (50gb)
                  Netwerkadapters: 1 = LAN
                  In Virtualbox in je nieuwe client VM ga naar system > motherboard > boot order en stel hard disk                             als eerste in en network als tweede.

Windows 10 deployment: 
a. Start de VM in Virtualbox

b. Druk op F12 wanneer erom gevraagd wordt

c. In het eerste venster van de task sequence wizard druk op next en selecteer “Windows 10 PRO”

d. Laat de deployment lopen (alles gebeurt automatisch)

e. Wanneer de deployment klaar is meld je op de client aan als BLANCQUAERT\Administrator (Het scherm zal 10-15min op “welkom” blijven staan)
    
| Nr test | Wat moet er getest worden | In orde? |
| :--- | :--- | :--- |
| 1 | Kan de client de PXE / SCCM server Papa2 bereiken via PXE boot?| Ja/Nee |
| 2 | Wordt Windows 10 op de client geïnstalleerd via PXE boot? | Ja/Nee |
| 3 | Zijn de 3 applications (Libre office, java en Adobe Flash Player geïnstalleerd op de client? | Ja/Nee |
