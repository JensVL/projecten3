# Testrapport alfa2: domeincontroller

Auteur(s) testrapport: Kimberly De Clercq 

## Test AD/DNS installatie en configuratie
Labo gemaakt door: Laurens Blancquaert-Cassaer  
Uitvoerder(s) test: Elias Waterschoot
Uitgevoerd op: 16/12/2019

### Uit te voeren testen
| Nr test | Wat moet er getest worden | In orde? |
| :--- | :--- | :--- |
| 1 | Is Alfa2 een domeincontroller? | Ja |
| 2 |Is DNS geïnstalleerd op de VM? | Ja |
| 3 | Is er een DNS primary zone geïnstalleerd op de VM? | Ja |
| 4 | Zijn alle DNS records correct aangemaakt volgens onderstaande tabel? | Ja |

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
Labo gemaakt door: Laurens Blancquaert-Cassaer  
Uitvoerder(s) test: Elias Waterschoot
Uitgevoerd op: 16/12/2019  

### Uit te voeren testen
| Nr test | Wat moet er getest worden | In orde? |
| :--- | :--- | :--- |
| 1 | Werkt de replicatie tussen Alfa2 en Bravo2 hun Active Directory zoals het hoort? | Ja |
| 2 | Staat de DNS primary zone "red.local" ook op Bravo2 met alle records? | Ja |


## Test ADstructuur en beleidsregels
Labo gemaakt door: Kimberly De Clercq  
Uitvoerder(s) test: Elias Waterschoot
Uitgevoerd op: 16/12/2019   

### Uit te voeren testen Organizational Units

| Nr test | Wat moet er getest worden | In orde? | 
| :--- | :--- | :--- | 
 1 | Is de Active Directory geïnstalleerd? | Ja |
| 2 | Zijn de vijf afdelingen (groepen) aangemaakt? | Ja |
| 3 | Is er een duidelijk verschil tussen gebruikers, computers en groepen? | Ja|
| 4 | Bestaan de groepen `Directie`, `IT_Administratie`, `Administratie`, `Ontwikkeling` en `Verkoop`? | Ja |
| 5 | Is aan elke groep de juiste manager toegewezen (zie indeling)? | Ja |
| 6 | Bevat elke groep zijn members (zie indeling)? | Ja |
| 7 | Wordt elke groep gemanaged door de juiste persoon (zie indeling)? | Ja |
| 8 | Bestaan de OU's `Directie`, `IT_Administratie`, `Administratie`, `Ontwikkeling` en `Verkoop`? | Ja |
| 9 | Is aan elke OU de juiste manager toegewezen (zie indeling)? | Ja |
| 10 | Bevat elke OU zijn members (zie indeling)? | Ja |
| 11 | Wordt elke OU gemanaged door de juiste persoon (zie indeling)? | Ja |

### Uit te voeren testen Gebruikers

| Nr test | Wat moet er getest worden | In orde? | 
| :--- | :--- | :--- | 
| 1 | Zijn er enkele gebruikers aangemaakt? | Ja |
| 2 | Is er gewerkt met zwervende profielen (roaming profiles)? | Ja |
| 3 | Heeft elke gebruiker zijn eigen profile? | Ja |
| 4 | Bevindt elke gebruiker zich in de toegewezen afdeling (zie indeling)? | Ja |
| 5 | Heeft elke gebruiker een uniek `EmployeeID`? | Ja |
| 6 | Heeft elke gebruiker een uniek telefoonnummer? | Ja |
| 7 | Bevindt elke gebruiker zich in de juiste afdeling? Is het `path` juist? | Ja |
| 8 | Bevindt elke gebruiker zich in het juiste `Office` (zie indeling)| Ja |
| 9 | Heeft elke gebruiker de juiste `initials`? | Ja |
| 10 | Heeft elke gebruiker een toepasselijke `SamAccountName`? | Ja |
| 11 | Is er aan elke afdeling een manager toegekend? | Ja |
| 12 | Heeft elke gebruiker een manager, behalve "Kimberly De Clercq"? | Ja |
| 13 | Heeft iedere afdeling de juiste manager toegekend (zie indeling)? | Ja |
| 14 | Is elke gebruiker unlocked? | Ja |
| 15 | Kan elke gebruiker inloggen met het password `Administrator2019`? | Ja |

### Uit te voeren testen Computers

| Nr test | Wat moet er getest worden | In orde? | 
| :--- | :--- | :--- | 
| 1 | Is er voor elke afdeling minstens 1 werkstation? | Ja |
| 2 | Zijn er minstens 5 werkstations? | Ja |
| 3 | Heeft elke gebruiker zijn werkstation? | Ja |

### Uit te voeren testen Beleidsregels

| Nr test | Wat moet er getest worden | In orde? |
| :--- | :--- | :--- |
| 1 | Heeft de `IT_Administratie` toegang tot het control panel? | Ja |
| 2 | Hebben de afdelingen `Verkoop`, `Ontwikkeling`, `Administratie` en `Directie` geen toegang tot het control panel? | Ja |
| 3 | Is het games link menu uit het start menu voor alle afdelingen verdwenen? | Ja |
| 4 | Hebben de afdelingen `IT_Administratie`, `Directie` en `Ontwikkeling` toegang tot de eigenschappen van de netwerkadapters? | Ja |
| 5 | Hebben de afdelingen `Administratie` en `Verkoop` geen toegang tot de eigenschappen van de netwerkadapters? | Ja |


## Test Prepare AD for SCCM
Labo gemaakt door:  Laurens Blancquaert-Cassaer  
Uitvoerder(s) test: Elias Waterschoot  
Uitgevoerd op: 16/12/2019  

### Uit te voeren testen
| Nr test | Wat moet er getest worden | In orde? |
| :--- | :--- | :--- |
| 2 |Is de System Management container (voor SCCM) correct aangemaakt? | Ja |
| 3 | Is het AD schema succesfully extended? | Ja |

