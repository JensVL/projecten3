# Testplan alfa2: domeincontroller

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
3) De output hiervan moet bij alle lijnen successful weergeven

Checken of de primary DNS zone "red.local" ook op Bravo2 staat met alle records:
Dit moet je uiteraard op Bravo2 doen. Je kan Alfa2 en Bravo2 als VM in virtualbox met elkaar verbinden (Gewoon de scripts uitvoeren die de servers configureren)  
Server manager > tools > DNS Manager >Forward Lookup Zones > red.local

    
| Nr test | Wat moet er getest worden | In orde? |
| :--- | :--- | :--- |
| 1 | Werkt de replicatie tussen Alfa2 en Bravo2 hun Active Directory zoals het hoort? | Ja/Nee |
| 2 | Staat de DNS primary zone "red.local" ook op Bravo2 met alle records? | Ja/Nee |

### Organizational Units
Ga naar Server Manager > Tools > Active Directory Users and Computers.  
Bekijk de vijf Organizational Units. Onder elke Organizational Unit zou een groep van deze OU moeten bestaan. Bekijk bij elke groep de "Members" en "Managed By". 

- Validatie OU: `Get-ADOrganizationalUnit "OU=Verkoop,DC=red,DC=local"`
- Validatie groep: `Get-ADGroup "Verkoop"`
- Validatie groepmembers: `Get-ADGroupMember -Identity Verkoop`
  
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
Open powershell en vul hierin telkens het commando `Get-ADUser "KimberlyDC"` voor elke gebruiker met zijn SamAccountName. De SamAccountName is telkens de voornaam en de initialen van de achternaam.   
Met dit commando kan je valideren of het account enabled is en in welke OU de gebruiker aanwezig is.  

- Validatie gebruiker: `Get-ADUser -Identity KimberlyDC -Properties *`
- Properties: `Get-ADUser -Identity KimberlyDC -Properties State, Office, SamAccountName, EmployeeID, DisplayName, DistinguishedName, Emailaddress, HomePhone, Office`


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
| 9 | Heeft elke gebruiker de juiste `initials`? | Ja/Nee |
| 10 | Heeft elke gebruiker een toepasselijke `SamAccountName`? | Ja/Nee |
| 11 | Is er aan elke afdeling een manager toegekend? | Ja/Nee |
| 12 | Heeft elke gebruiker een manager, behalve "Kimberly De Clercq"? | Ja/Nee |
| 13 | Heeft iedere afdeling de juiste manager toegekend (zie indeling)? | Ja/Nee |
| 14 | Is elke gebruiker unlocked? | Ja/Nee |
| 15 | Kan elke gebruiker inloggen met het password `Administrator2019`? | Ja/Nee |

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
| Verkoop | Sean Vancompernolle | Nee | Gent |

### Indeling Active Directory Office

| Afdeling | Office | 
| :--- | :--- | 
| Directie | B0.00X | 
| Administratie | B4.002 | 
| IT_Administratie | B4.037 | 
| Verkoop | B0.015 | 
| Ontwikkeling | B1.018 | 

### Computers 
Ga naar Server Manager > Tools > Active Directory Users and Computers > Computers.    
Bekijk van elke computer de "Location" en "Managed By". 

- Allemaal: `Get-ADComputer -Filter *`
- Afzonderlijk: `Get-ADComputer -Identity "CN=Verkoop_001,CN=Computers,DC=red,DC=local" -Properties ManagedBy, Location`

| Nr test | Wat moet er getest worden | In orde? | 
| :--- | :--- | :--- | 
| 1 | Is er voor elke afdeling minstens 1 werkstation? | Ja/Nee |
| 2 | Zijn er minstens 5 werkstations? | Ja/Nee |
| 3 | Heeft elke gebruiker zijn werkstation? | Ja/Nee |

## Beleidsregels
De beleidsregels werden handmatig in de GUI ingesteld worden.   
Ga naar Server Manager > Tools > Group Policy Management > Forest:red.local > Domains > red.local > Group Policy Objects.  
Bekijk de settings van `RemoveGameLink`, `DisableNetworkadapters` en `DisableControlPanel`.
- Bij `RemoveGameLink` zou "Remove Games link from Start Menu" enabled moeten zijn.
- Bij `DisableNetworkadapters` zou "Prohibit access to properties of a LAN connection" disabled moeten zijn. 
- Bij `DisableControlPanel` zou "Disable the Display Control panel" enabled moeten zijn. 
  
| Nr test | Wat moet er getest worden | In orde? |
| :--- | :--- | :--- |
| 1 | Heeft de `IT_Administratie` toegang tot het control panel? | Ja/Nee |
| 2 | Hebben de afdelingen `Verkoop`, `Ontwikkeling`, `Administratie` en `Directie` geen toegang tot het control panel? | Ja/Nee |
| 3 | Is het games link menu uit het start menu voor alle afdelingen verdwenen? | Ja/Nee |
| 4 | Hebben de afdelingen `IT_Administratie`, `Directie` en `Ontwikkeling` toegang tot de eigenschappen van de netwerkadapters? | Ja/Nee |
| 5 | Hebben de afdelingen `Administratie` en `Verkoop` geen toegang tot de eigenschappen van de netwerkadapters? | Ja/Nee |


## Prepare AD for SCCM:
### Uit te voeren stappen:
Checken of de System Management container (voor SCCM) correct aangemaakt is:
1) Server Manager > Tools > ADSIedit 
2) Rechtermuisknop op "ADSIedit" en doe "connect to.."
3) Laat default settings staan en druk op ok
4) Ga naar: Default naming context > DC=red, DC=local > CN=System
Hierin zou je de container "System Management moeten zien staan

De System Management container zijn permissies moeten allemaal kunnen beheerd worden door de Papa2 server dit check je zo:
1) Rechtermuisknop op System Management container en kies properties
2) Ga naar de "security" tab
3) In de lijst van groups/users moet je Papa2 zien staan en de permissies moeten op "Full Control" staan

Checken of de AD schema succesfully extended is:
Dit doe je best door de automatisch aangemaakte logfile te checken die je op vind in de volgende locatie:
De test is geslaagd als hier geen errors in staan

    C:\ExtADSch.log
    
| Nr test | Wat moet er getest worden | In orde? |
| :--- | :--- | :--- |
| 2 |Is de System Management container (voor SCCM) correct aangemaakt? | Ja/Nee |
| 3 | Is het AD schema succesfully extended? | Ja/Nee |
