# Testrapport alfa2: domeincontroller

(Een testrapport is het verslag van de uitvoering van het testplan door een teamlid (iemand anders dan de auteur van het testplan!). Deze noteert bij elke stap in het testplan of het bekomen resultaat overeenstemt met wat verwacht werd. Indien niet, dan is het belangrijk om gedetailleerd op te geven wat er misloopt, wat het effectieve resultaat was, welke foutboodschappen gegenereerd werden, enz. De tester kan meteen een Github issue aanmaken en er vanuit het testrapport naar verwijzen. Wanneer het probleem opgelost werdt, wordt een nieuwe test uitgevoerd, met een nieuw verslag.)

Auteur(s) testrapport: Kimberly De Clercq 

## Test AD/DNS installatie en configuratie
Labo gemaakt door:   
Uitvoerder(s) test: Sean Vancompernolle  
Uitgevoerd op: 28/10/2019
Github commit: c0a4dc8619989c4e20ad079de246890827188e13

**Test kan niet worden uitgevoerd. Kan "Active Directory Users and Computers" niet openen. Faalt met volgende error:**

```
To manage users and groups on this computer, use Local Users and Groups.
To manage users, groups and computers in a domain, log on as a user with domain administration rights.
```

**Kan dus onderstaande gegevens niet nachecken. Scripten zijn wel uitgevoerd zonder enige errors in de shell.**

### Uit te voeren testen
| Nr test | Wat moet er getest worden | In orde? |
| :--- | :--- | :--- |
| 1 | Is Alfa2 een domeincontroller? | Ja/Nee |
| 2 |Is DNS geïnstalleerd op de VM? | Ja/Nee |
| 3 | Is er een DNS primary zone geïnstalleerd op de VM? | Ja/Nee |
| 4 | Zijn alle DNS records correct aangemaakt volgens onderstaande tabel? | Ja/Nee |

### Opmerkingen
| Device | Soort DNS record | IP-address | 
| :--: | :--: | :--: | 
| alfa2 | NS | 172.18.1.66 | 
| bravo2 | NS | 172.18.1.67 (zie je pas na installatie Bravo2 server) | 
| charlie2 | A + MX + Cname |172.18.1.68  | 
| delta2 | A | 172.18.1.69 | 
| kilo2 | A | 172.18.1.1 | 
| lima2 | A | 172.18.1.2 | 
| mike2 | A | 172.18.1.3 | 
| november2 | A | 172.18.1.4 | 
| oscar2 | A | 172.18.1.5 | 
| papa2 | A | 172.18.1.6 | 


## Test AD en DNS Replication tussen Alfa2 en Bravo2 (Tweede domeincontroller)

**Niet uitgevoerd vanwege Bravo2 niet beschikbaar.**

## Test ADstructuur en beleidsregels
Labo gemaakt door: Kimberly De Clercq  
Uitvoerder(s) test: Sean Vancompernolle  
Uitgevoerd op: 28/10/2019
Github commit: c0a4dc8619989c4e20ad079de246890827188e13

**Kan beleidsregels niet aanpassen. Group Policy Management faalt omdat niet op het domein kan worden ingelogd, dus enkel lokale policies kunnen worden aangepast.

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

**Niet uitgevoerd want testplan niet compleet.**

## Test Prepare AD for SCCM
Labo gemaakt door:  
Uitvoerder(s) test: Sean Vancompernolle  
Uitgevoerd op: 28/10/2019
Github commit: c0a4dc8619989c4e20ad079de246890827188e13

**Test kan niet worden uitgevoerd. Kan "Active Directory Users and Computers" niet openen. Zelfde reden als in test 1.**   

### Uit te voeren testen
| Nr test | Wat moet er getest worden | In orde? |
| :--- | :--- | :--- |
| 1 | Is de SCCM admin useraccount aangemaakt en zit hij in de domain admin group? | Ja/Nee |
| 2 |Is de System Management container (voor SCCM) correct aangemaakt? | Ja/Nee |
| 3 | Is het AD schema succesfully extended? | Ja/Nee |

