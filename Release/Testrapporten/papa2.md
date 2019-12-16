# Testrapport Papa2: SCCM deployment server

Auteur(s) testrapport: Arno Van Nieuwenhove en Levi Goessens

## Voorbereiding op SCCM installatie:
Labo gemaakt door: Laurens Blancquaert-Cassaer  
Uitvoerder(s) test: Arno Van Nieuwenhove en Levi Goessens  
Uitgevoerd op: 16/12/2019

### Uit te voeren testen
| Nr test | Wat moet er getest worden | In orde? |
| :--- | :--- | :--- |
| 1 | Is Papa2 aan het red.local domain toegevoegd? | Ja |
| 2 | Is Windows Assessment and Deployment Toolkit (ADK) geïnstalleerd?| Ja |
| 3 | Is de WindowsPE addon voor ADK geïnstalleerd? | Ja |
| 4 | Is Microsoft Deployment Toolkit (MDT) geïnstalleerd? | Ja |



## SCCM Installatie + configuratie:
Labo gemaakt door: Laurens Blancquaert-Cassaer  
Uitvoerder(s) test: Arno Van Nieuwenhove en Levi Goessens  
Uitgevoerd op: 16/12/2019 

### Uit te voeren testen
| Nr test | Wat moet er getest worden | In orde? |
| :--- | :--- | :--- |
| 1 | Is SCCM correct geïnstalleerd op de Papa2 Server? | Ja|
| 2 | Is de integratie tussen MDT en SCCM goed geconfigureerd? | Ja |
| 3 | Zijn de boundary groups correct aangemaakt in SCCM?| Ja |
| 4 | Is de SCCM network access account ingesteld? | Ja |
| 5 | Check of de discovery methods voor SCCM correct zijn ingesteld | Ja |
| 6 | Check of de PXE settings in SCCM correct zijn voor client Deployment | Ja|



## Windows 10 Client Deployment / Task Sequence
Labo gemaakt door: Ferre Verstichelen en Laurens Blancquaert-Cassaer
Uitvoerder(s) test:   
Uitgevoerd op: 16/12/2019

### 1. Stappen om software binnen SCCM te controleren:
| Nr test | Wat moet er getest worden | In orde? |
| :--- | :--- | :--- |
| 1 | Binnen "Application Management > Applications", zijn  Libre office, Java, Adobe Flash Player en Adobe Acrobat Reader DC aanwezig? | Ja |
| 2 | Binnen "Operating Systems > Operating  System Images", is "Windows 10 Enterprise Evaluation" aanwezig? | Ja |
| 3 | Binnen "Operating Systems > Boot Images", is er een boot image (x64) aanwezig? | Ja |
| 4 | Binnen "Operating Systems > Task Sequences", is er een Task Sequence aanwezig?| Ja |

### 2. Stappen om de Task Sequence te controleren:
| Nr test | Wat moet er getest worden | In orde? |
| :--- | :--- | :--- |
| 1 | Navigeer naar "State Restore > Install Applications > Install Application", staan hier onder de tab "Properties", de 4 applicaties? (Acrobat Reader DC, Flash Player, Java en LibreOffice) | Ja |
| 2 | Navigeer naar "Post Install > Auto Apply Drivers", is deze stap grijs (aka. uitgeschakeld)? | Ja |

### 3. Windows 10 deployment:
| Nr test | Wat moet er getest worden | In orde? |
| :--- | :--- | :--- |
| 1 | Kan de client de PXE / SCCM server Papa2 bereiken via PXE boot?| Ja/Nee |
| 2 | Wordt Windows 10 op de client geïnstalleerd via PXE boot? | Ja/Nee |
| 3 | Zijn de 4 applications (Libre office, java, Adobe Reader en Adobe Flash Player geïnstalleerd op de client? | Ja/Nee |
