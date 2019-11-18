# Testrapport Papa2: SCCM deployment server

(Een testrapport is het verslag van de uitvoering van het testplan door een teamlid (iemand anders dan de auteur van het testplan!). Deze noteert bij elke stap in het testplan of het bekomen resultaat overeenstemt met wat verwacht werd. Indien niet, dan is het belangrijk om gedetailleerd op te geven wat er misloopt, wat het effectieve resultaat was, welke foutboodschappen gegenereerd werden, enz. De tester kan meteen een Github issue aanmaken en er vanuit het testrapport naar verwijzen. Wanneer het probleem opgelost werdt, wordt een nieuwe test uitgevoerd, met een nieuw verslag.)

Auteur(s) testrapport: Laurens Blancquaert-Cassaer

## Voorbereiding op SCCM installatie:
Labo gemaakt door: Laurens Blancquaert-Cassaer
Uitvoerder(s) test:   
Uitgevoerd op:   
Github commit:   

### Uit te voeren testen
| Nr test | Wat moet er getest worden | In orde? |
| :--- | :--- | :--- |
| 1 | Is Papa2 aan het red.local domain toegevoegd? | Ja/Nee |
| 2 | Is Windows Assessment and Deployment Toolkit (ADK) geïnstalleerd?| Ja/Nee |
| 3 | Is de WindowsPE addon voor ADK geïnstalleerd? | Ja/Nee |
| 4 | Is Microsoft Deployment Toolkit (MDT) geïnstalleerd? | Ja/Nee |



## SCCM Installatie + configuratie:
Labo gemaakt door: Laurens Blancquaert-Cassaer
Uitvoerder(s) test:   
Uitgevoerd op:   
Github commit:   

### Uit te voeren testen
| Nr test | Wat moet er getest worden | In orde? |
| :--- | :--- | :--- |
| 1 | Is SCCM correct geïnstalleerd op de Papa2 Server? | Ja/Nee |
| 2 | Is de integratie tussen MDT en SCCM goed geconfigureerd? | Ja/Nee |
| 3 | Zijn de boundary groups correct aangemaakt in SCCM?| Ja/Nee |
| 4 | Is de SCCM network access account ingesteld? | Ja/Nee |
| 5 | Check of de discovery methods voor SCCM correct zijn ingesteld | Ja/Nee |
| 6 | Check of de PXE settings in SCCM correct zijn voor client Deployment | Ja/Nee |



## Windows 10 Client Deployment / Task Sequence
Labo gemaakt door: Ferre Verstichelen en Laurens Blancquaert-Cassaer
Uitvoerder(s) test:   
Uitgevoerd op:   
Github commit:   

### Uit te voeren testen
| Nr test | Wat moet er getest worden | In orde? |
| :--- | :--- | :--- |
| 1 | Kan de client de PXE / SCCM server Papa2 bereiken via PXE boot?| Ja/Nee |
| 2 | Wordt Windows 10 op de client geïnstalleerd via PXE boot? | Ja/Nee |
| 3 | Zijn de 3 applications (Libre office, java en Adobe Flash Player geïnstalleerd op de client? | Ja/Nee |
