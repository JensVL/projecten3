# Testplan Papa2: SCCM server

Auteur(s) testplan: Laurens Blancquaert-Cassaer, Ferre Verstichelen


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

### 1. Uit te voeren stappen:
Na de Papa2 scripts moet je de instructies volgen in: **Papa2_technische_documentatie.md** om de task sequence aan te maken.

### 2. Stappen om software binnen SCCM te controleren:
1. Start Configuration Manager Console  
2. Navigeer via het menu links-onder naar "Software Library".  


| Nr test | Wat moet er getest worden | In orde? |
| :--- | :--- | :--- |
| 1 | Binnen "Application Management > Applications", zijn  Libre office, Java, Adobe Flash Player en Adobe Acrobat Reader DC aanwezig? | Ja/Nee |
| 2 | Binnen "Operating Systems > Operating  System Images", is "Windows 10 Enterprise Evaluation" aanwezig? | Ja/Nee |
| 3 | Binnen "Operating Systems > Boot Images", is er een boot image (x64) aanwezig? | Ja/Nee |
| 4 | Binnen "Operating Systems > Task Sequences", is er een Task Sequence aanwezig?| Ja/Nee |

### 3. Stappen om de Task Sequence te controleren:
1. Start Configuration Manager Console  
2. Navigeer naar "Software Library > Operating Systems > Task Sequences"
3. Right-click de Task Sequence en selecteer "View"

| Nr test | Wat moet er getest worden | In orde? |
| :--- | :--- | :--- |
| 1 | Navigeer naar "State Restore > Install Applications > Install Application", staan hier onder de tab "Properties", de 4 applicaties? (Acrobat Reader DC, Flash Player, Java en LibreOffice) | Ja/Nee |
| 2 | Navigeer naar "Post Install > Auto Apply Drivers", is deze stap grijs (aka. uitgeschakeld)? | Ja/Nee |

### 4. VM aanmaken: De eerste stap is een nieuwe virtuele machine aanmaken in Virtualbox met volgende specificaties:

                  Name: CLIENT1
                  Windows 10 (64-bit)
                  2048mb RAM
                  1 hard drive (50gb)
                  Netwerkadapters: 1 = LAN
                  In Virtualbox in je nieuwe client VM ga naar system > motherboard > boot order en stel hard disk                             als eerste in en network als tweede.

### 5. Windows 10 deployment: 
1. Start de VM in Virtualbox

2. Druk op F12 wanneer erom gevraagd wordt

3. In het eerste venster van de task sequence wizard druk op next en selecteer “Windows 10 PRO”

4. Laat de deployment lopen (alles gebeurt automatisch)

5. Wanneer de deployment klaar is meld je op de client aan als BLANCQUAERT\Administrator (Het scherm zal 10-15min op “welkom” blijven staan)
    
| Nr test | Wat moet er getest worden | In orde? |
| :--- | :--- | :--- |
| 1 | Kan de client de PXE / SCCM server Papa2 bereiken via PXE boot?| Ja/Nee |
| 2 | Wordt Windows 10 op de client geïnstalleerd via PXE boot? | Ja/Nee |
| 3 | Zijn de 4 applications (Libre office, java, Adobe Reader en Adobe Flash Player geïnstalleerd op de client? | Ja/Nee |