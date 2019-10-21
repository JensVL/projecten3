# Testplan alfa2: domeincontroller

(Een testplan is een *exacte* procedure van de handelingen die je moet uitvoeren om aan te tonen dat de opdracht volledig volbracht is en dat aan alle specificaties voldaan is. Een teamlid moet aan de hand van deze procedure in staat zijn om de tests uit te voeren en erover te rapporteren (zie testrapport). Geef bij elke stap het verwachte resultaat en hoe je kan verifiëren of dat resultaat ook behaald is. Kies zelf de structuur: genummerde lijst, tabel, secties, ... Verwijder deze uitleg als het plan af is.)

Auteur(s) testplan: Kimberly De Clercq en Laurens Blancquaert-Cassaer

## AD/DNS configuratie en installatie
### Uit te voeren stappen:
Checken of dat Alfa2 een domeincontroller is:
Server Manager > tools > Active Directory Users and Computers > Papa2.red.local > Domain Controllers (container)
Hierin zou Alfa2 als computerobject moeten staan

Checken of er een DNS primary zone geïnstalleerd is (met de naam red.local):
Server Manager > Tools > DNS Manager > forward lookup zone
Hier zou je "red.local" moeten zien staan

| Nr test | Wat moet er getest worden | In orde? |
| :--- | :--- | :--- |
| 1 | Is Alfa2 een domeincontroller? | Ja/Nee |
| 2 |Is DNS geïnstalleerd op de VM? | Ja/Nee |
| 3 | Is er een DNS primary zone geïnstalleerd op de VM? | Ja/Nee |
| 4 | Zijn alle DNS records correct aangemaakt volgens onderstaande tabel? | Ja/Nee |


##  DNS records tabel:
### Uit te voeren stappen:
Checken of de DNS records bestaan: 
Server manager > tools > DNS Manager >Forward Lookup Zones > red.local

    Let op: Alle records moeten een A record zijn behalve Alfa2 en Bravo2 deze zijn een NS record.
    De Exchange server Charlie2 bevat naast een A record ook een MX en Cname record.

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

## AD en DNS Replication tussen Alfa2 en Bravo2 (Tweede domeincontroller)
### Uit te voeren stappen:
Checken of de replicatie tussen Alfa2 en Bravo2 hun Active Directory goed werkt:
1) Open Powershell ISE als administrator.
2) Voer volgend commando in:

       repadmin /showrepl
4) De output hiervan moet bij alle lijnen successful weergeven

Checken of de primary DNS zone "red.local" ook op Bravo2 staat met alle records:
Dit moet je uiteraard op Bravo2 doen. Je kan Alfa2 en Bravo2 als VM in virtualbox met elkaar verbinden (Gewoon de scripts uitvoeren die de servers configureren)
Server manager > tools > DNS Manager >Forward Lookup Zones > red.local

    
| Nr test | Wat moet er getest worden | In orde? |
| :--- | :--- | :--- |
| 1 | Werkt de replicatie tussen Alfa2 en Bravo2 hun Active Directory zoals het hoort? | Ja/Nee |
| 2 | Staat de DNS primary zone "red.local" ook op Bravo2 met alle records? | Ja/Nee |

### Organizational Units

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

### Gebruikers

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

### Indeling Active Directory Organizational Units
| Afdeling | Naam | Is manager? | Gent/Aalst |
| :--- | :--- | :--- | :--- |
| Directie | Kimberly De Clercq | Ja | Gent |
| Directie | Arno Van Nieuwenhove | Nee | Aalst |
| IT Administratie | Laurens Blancquaert-Cassaer| Ja | Gent |
| IT Administratie | Ferre Verstichelen | Nee | Gent |
| IT Administratie | Levi Goessens | Nee | Aalst |
| IT Administratie | Aron Marckx | Nee | Aalst |
| IT Administratie | Jens Van Liefferinge | Nee | Gent |
| Administratie | Joachim Van de Keere | Ja | Gent |
| Administratie | Tibo Vanhercke | Nee | Gent |
| Administratie | Yngvar Samyn | Nee | Gent |
| Administratie | Tim Grijp | Nee | Gent |
| Administratie | Rik Claeyssens | Nee | Gent | 
| Ontwikkeling | Jannes Van Wonterghem | Ja | Gent |
| Ontwikkeling | Jonas Vandegehuchte | Nee | Gent |
| Ontwikkeling | Cédric Van den Eede | Nee | Aalst |
| Ontwikkeling | Cedric Detemmerman | Nee | Aalst |
| Ontwikkeling | Robin Van de Walle | Nee | Gent |
| Verkoop | Matthias Van de Velde | Ja | Gent |
| Verkoop | Robby Daelman | Nee | Aalst |
| Verkoop | Nathan Cammerman | Nee | Gent |
| Verkoop | Elias Waterschoot | Nee | Gent |
| Verkoop | Alister Adutwum | Nee | Gent |

### Indeling Active Directory Office

| Afdeling | Office | 
| :--- | :--- | 
| Directie | B0.00X | 
| Administratie | B4.002 | 
| IT_Administratie | B4.037 | 
| Verkoop | B0.015 | 
| Ontwikkeling | B1.018 | 

### Computers 

| Nr test | Wat moet er getest worden | In orde? | 
| :--- | :--- | :--- | 
| 1 | Is er voor elke afdeling minstens 1 werkstation? | Ja/Nee |
| 2 | Zijn er minstens 5 werkstations? | Ja/Nee |
| 3 | Heeft elke gebruiker zijn werkstation? | Ja/Nee |

## Beleidsregels
De beleidsregels moeten handmatig in de GUI ingesteld worden.   
Volg hiervoor eerst het stappenplan in het verslag onder `Stappenplan beleidsregels`.   

| Nr test | Wat moet er getest worden | In orde? |
| :--- | :--- | :--- |
| 1 | Heeft de `IT_Administratie` toegang tot het control panel? | Ja/Nee |
| 2 | Hebben de afdelingen `Verkoop`, `Ontwikkeling`, `Administratie` en `Directie` geen toegang tot het control panel? | Ja/Nee |
| 3 | Is het games link menu uit het start menu voor alle afdelingen verdwenen? | Ja/Nee |
| 4 | Hebben de afdelingen `IT_Administratie`, `Directie` en `Ontwikkeling` toegang tot de eigenschappen van de netwerkadapters? | Ja/Nee |
| 5 | Hebben de afdelingen `Administratie` en `Verkoop` geen toegang tot de eigenschappen van de netwerkadapters? | Ja/Nee |

## AGDLP (Account, Global, Domain Local, Permission)

