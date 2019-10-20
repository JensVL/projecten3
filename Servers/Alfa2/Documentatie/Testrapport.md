# Testrapport alfa2: domeincontroller

(Een testrapport is het verslag van de uitvoering van het testplan door een teamlid (iemand anders dan de auteur van het testplan!). Deze noteert bij elke stap in het testplan of het bekomen resultaat overeenstemt met wat verwacht werd. Indien niet, dan is het belangrijk om gedetailleerd op te geven wat er misloopt, wat het effectieve resultaat was, welke foutboodschappen gegenereerd werden, enz. De tester kan meteen een Github issue aanmaken en er vanuit het testrapport naar verwijzen. Wanneer het probleem opgelost werdt, wordt een nieuwe test uitgevoerd, met een nieuw verslag.)

Auteur(s) testrapport: Kimberly De Clercq 

## Test DNS installatie en configuratie
Labo gemaakt door: 
Uitvoerder(s) test:   
Uitgevoerd op: 
Github commit:   

### Uit te voeren testen

### Opmerkingen



## Test ADstructuur en beleidsregels
Labo gemaakt door: Kimberly De Clercq
Uitvoerder(s) test:   
Uitgevoerd op: 
Github commit:   

### Uit te voeren testen Organizational Units

| Nr test | Wat moet er getest worden | In orde? | 
| :--- | :--- | :--- | 
 1 | Is de Active Directory geïnstalleerd? | Ja/Nee |
| 2 | Zijn de vijf afdelingen (groepen) aangemaakt? | Ja/Nee |
| 3 | Is er een duidelijk verschil tussen gebruikers, computers en groepen? | Ja/Nee |
| 4 | Bestaan de groepen `Directie`, `IT_Administratie`, `Administratie`, `Ontwikkeling` en `Verkoop`? | Ja/Nee |
| 5 | Is aan elke groep de juiste manager toegewezen (zie indeling)? | Ja/Nee |
| 6 | Bevat elke groep zijn members (zie indeling)? | Ja/Nee |
| 7 | Wordt elke groep gemanaged door de juiste persoon (zie indeling)? | Ja/Nee |
| 8 | Bestaan de OU's `Directie`, `IT_Administratie`, `Administratie`, `Ontwikkeling` en `Verkoop`? | Ja/Nee |
| 9 | Is aan elke OU de juiste manager toegewezen (zie indeling)? | Ja/Nee |
| 10 | Bevat elke OU zijn members (zie indeling)? | Ja/Nee |
| 11 | Wordt elke OU gemanaged door de juiste persoon (zie indeling)? | Ja/Nee |

### Uit te voeren testen Gebruikers

| Nr test | Wat moet er getest worden | In orde? | 
| :--- | :--- | :--- | 
| 1 | Zijn er enkele gebruikers aangemaakt? | Ja/Nee |
| 2 | Is er gewerkt met zwervende profielen (roaming profiles)? | Ja/Nee |
| 3 | Heeft elke gebruiker zijn eigen profile? | Ja/Nee |
| 4 | Bevindt elke gebruiker zich in de toegewezen afdeling (zie indeling)? | Ja/Nee |
| 5 | Heeft elke gebruiker een uniek `EmployeeID`? | Ja/Nee |
| 6 | Heeft elke gebruiker een uniek telefoonnummer? | Ja/Nee |
| 7 | Bevindt elke gebruiker zich in de juiste afdeling? Is het `path` juist? | Ja/Nee |
| 8 | Bevindt elke gebruiker zich in het juiste `Office` (zie indeling)| Ja/Nee |
| 9 | Heeft elke gebruiker een uniek `EmailAddress`? | Ja/Nee |
| 10 | Heeft elke gebruiker de juiste `initials`? | Ja/Nee |
| 11 | Heeft elke gebruiker een toepasselijke `SamAccountName`? | Ja/Nee |
| 12 | Is er aan elke afdeling een manager toegekend? | Ja/Nee |
| 13 | Heeft elke gebruiker een manager, behalve "Kimberly De Clercq"? | Ja/Nee |
| 14 | Heeft iedere afdeling de juiste manager toegekend (zie indeling)? | Ja/Nee |
| 15 | Is elke gebruiker unlocked? | Ja/Nee |
| 16 | Kan elke gebruiker inloggen met het password `Administrator2019`? | Ja/Nee |

### Uit te voeren testen Computers

| Nr test | Wat moet er getest worden | In orde? | 
| :--- | :--- | :--- | 
| 1 | Is er voor elke afdeling minstens 1 werkstation? | Ja/Nee |
| 2 | Zijn er minstens 5 werkstations? | Ja/Nee |
| 3 | Heeft elke gebruiker zijn werkstation? | Ja/Nee |

### Uit te voeren testen Beleidsregels

| Nr test | Wat moet er getest worden | In orde? |
| :--- | :--- | :--- |
| 1 | Heeft de `IT_Administratie` toegang tot het control panel? | Ja/Nee |
| 2 | Hebben de afdelingen `Verkoop`, `Ontwikkeling`, `Administratie` en `Directie` geen toegang tot het control panel? | Ja/Nee |
| 3 | Is het games link menu uit het start menu voor alle afdelingen verdwenen? | Ja/Nee |
| 4 | Hebben de afdelingen `IT_Administratie`, `Directie` en `Ontwikkeling` toegang tot de eigenschappen van de netwerkadapters? | Ja/Nee |
| 5 | Hebben de afdelingen `Administratie` en `Verkoop` geen toegang tot de eigenschappen van de netwerkadapters? | Ja/Nee |


### Opmerkingen


## Test AGDLP Permissions
Labo gemaakt door: 
Uitvoerder(s) test:   
Uitgevoerd op: 
Github commit:   

### Uit te voeren testen

### Opmerkingen


## Test Prepare AD for SCCM
Labo gemaakt door: 
Uitvoerder(s) test:   
Uitgevoerd op: 
Github commit:   

### Uit te voeren testen

### Opmerkingen

