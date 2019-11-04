# Testrapport alfa2: domeincontroller

(Een testrapport is het verslag van de uitvoering van het testplan door een teamlid (iemand anders dan de auteur van het testplan!). Deze noteert bij elke stap in het testplan of het bekomen resultaat overeenstemt met wat verwacht werd. Indien niet, dan is het belangrijk om gedetailleerd op te geven wat er misloopt, wat het effectieve resultaat was, welke foutboodschappen gegenereerd werden, enz. De tester kan meteen een Github issue aanmaken en er vanuit het testrapport naar verwijzen. Wanneer het probleem opgelost werdt, wordt een nieuwe test uitgevoerd, met een nieuw verslag.)

Auteur(s) testrapport: Kimberly De Clercq 

## Test AD/DNS installatie en configuratie
Labo gemaakt door:   
Uitvoerder(s) test: Sean Vancompernolle
Uitgevoerd op: 04/11/2019  
Github commit: 48bd2c308d9217179250cf3abcc191ed5af65bd8 

### Uit te voeren testen
| Nr test | Wat moet er getest worden | In orde? |
| :--- | :--- | :--- |
| 1 | Is Alfa2 een domeincontroller? | **Ja** |
| 2 |Is DNS geïnstalleerd op de VM? | **Ja** |
| 3 | Is er een DNS primary zone geïnstalleerd op de VM? | **Ja** |
| 4 | Zijn alle DNS records correct aangemaakt volgens onderstaande tabel? | **Ja** |

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

**Opmerking:** Charlie2 heeft als namen `mail` en `owa` in plaats van `Charlie2`.

Tijdens uitvoeren opzetten server werd volgende error weergegeven bij deze stage, alhoewel bovenstaande testen slagen:

```
Alfa2: >>> Installing AD forest and adding Alfa2 as first DC
Alfa2: Get-ADDomainController : Unable to find a default server with Active Directory Web Services running.
Alfa2: At C:\tmp\vagrant-shell.ps1:103 char:30
Alfa2: + $domaincontroller_installed=(Get-ADDomainController 2> $null)
Alfa2: +                              ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Alfa2:     + CategoryInfo          : ResourceUnavailable: (:) [Get-ADDomainController], ADServerDownException
Alfa2:     + FullyQualifiedErrorId : ActiveDirectoryServer:1355,Microsoft.ActiveDirectory.Management.Commands.GetADDomainCont
Alfa2:    roller
```

## Test AD en DNS Replication tussen Alfa2 en Bravo2 (Tweede domeincontroller)

**Niet getest.**

## Test ADstructuur en beleidsregels
Labo gemaakt door: Kimberly De Clercq  
Uitvoerder(s) test: Sean Vancompernolle
Uitgevoerd op: 04/11/2019  
Github commit: 48bd2c308d9217179250cf3abcc191ed5af65bd8  

### Uit te voeren testen Organizational Units

| Nr test | Wat moet er getest worden | In orde? | 
| :--- | :--- | :--- | 
 1 | Is de Active Directory geïnstalleerd? | **Ja** |
| 2 | Zijn de vijf afdelingen (groepen) aangemaakt? | **Ja** |
| 3 | Is er een duidelijk verschil tussen gebruikers, computers en groepen? | **Ja** |
| 4 | Bestaan de groepen `Directie`, `IT_Administratie`, `Administratie`, `Ontwikkeling` en `Verkoop`? | **Ja** |
| 5 | Is aan elke groep de juiste manager toegewezen (zie indeling)? | **Ja** |
| 6 | Bevat elke groep zijn members (zie indeling)? | **Nee** |
| 7 | Wordt elke groep gemanaged door de juiste persoon (zie indeling)? | **Ja** |
| 8 | Bestaan de OU's `Directie`, `IT_Administratie`, `Administratie`, `Ontwikkeling` en `Verkoop`? | **Ja** |
| 9 | Is aan elke OU de juiste manager toegewezen (zie indeling)? | **Ja** |
| 10 | Bevat elke OU zijn members (zie indeling)? | **Ja** |
| 11 | Wordt elke OU gemanaged door de juiste persoon (zie indeling)? | **Nee** |

 - Groep `Ontwikkeling` bevat geen members
 - Member `Cédric` van `Ontwikkeling` heeft geen manager
 
Tijdens uitvoeren opzetten server werden volgende errors weergegeven bij deze stage:

```
Alfa2: Add-ADGroupMember : Directory object not found
Alfa2: At C:\tmp\vagrant-shell.ps1:205 char:1
Alfa2: + Add-ADGroupMember -Identity "CN=Ontwikkeling,OU=Ontwikkeling,DC=red,D ...
Alfa2: + ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Alfa2:     + CategoryInfo          : ObjectNotFound: (CN=CAcdric,OU=O...DC=red,DC=local:ADPrincipal) [Add-ADGroupMember], ADI
Alfa2:    dentityNotFoundException
Alfa2:     + FullyQualifiedErrorId : SetADGroupMember.ValidateMembersParameter,Microsoft.ActiveDirectory.Management.Commands.
Alfa2:    AddADGroupMember
```

```
Alfa2: Set-ADUser : Directory object not found
Alfa2: At C:\tmp\vagrant-shell.ps1:237 char:1
Alfa2: + Set-ADUser -Identity "CN=CAcdric,OU=Ontwikkeling,DC=red,DC=local" -Ma ...
Alfa2: + ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Alfa2:     + CategoryInfo          : ObjectNotFound: (CN=CAcdric,OU=O...DC=red,DC=local:ADUser) [Set-ADUser], ADIdentityNotFo
Alfa2:    undException
Alfa2:     + FullyQualifiedErrorId : ActiveDirectoryCmdlet:Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException,M
Alfa2:    icrosoft.ActiveDirectory.Management.Commands.SetADUser
```

### Uit te voeren testen Gebruikers

| Nr test | Wat moet er getest worden | In orde? | 
| :--- | :--- | :--- | 
| 1 | Zijn er enkele gebruikers aangemaakt? | **Ja** |
| 2 | Is er gewerkt met zwervende profielen (roaming profiles)? | **Nee** |
| 3 | Heeft elke gebruiker zijn eigen profile? | **Ja** |
| 4 | Bevindt elke gebruiker zich in de toegewezen afdeling (zie indeling)? | **Ja** |
| 5 | Heeft elke gebruiker een uniek `EmployeeID`? | **Ja** |
| 6 | Heeft elke gebruiker een uniek telefoonnummer? | **Ja** |
| 7 | Bevindt elke gebruiker zich in de juiste afdeling? Is het `path` juist? | **Nee** |
| 8 | Bevindt elke gebruiker zich in het juiste `Office` (zie indeling)| **Ja** |
| 9 | Heeft elke gebruiker de juiste `initials`? | **Ja** |
| 10 | Heeft elke gebruiker een toepasselijke `SamAccountName`? | **Ja** |
| 11 | Is er aan elke afdeling een manager toegekend? | Ja/Nee |
| 12 | Heeft elke gebruiker een manager, behalve "Kimberly De Clercq"? | **Nee** |
| 13 | Heeft iedere afdeling de juiste manager toegekend (zie indeling)? | **Ja** |
| 14 | Is elke gebruiker unlocked? | **Nee** |
| 15 | Kan elke gebruiker inloggen met het password `Administrator2019`? | **Nee** |

 - Zoals hierboven beschreven bevinden de members van OU `Ontwikkeling` zich niet in de groep `Ontwikkeling`, en hebben dus geen `path`
 - Zoals hierboven beschreven heeft gebruiker `Cédric` geen manager
 - Account van `Cédric` is niet enabled
 - Kan niet inloggen met gebruikers, geeft volgende error:
 
```
The sign-in method you're trying to use isn't allowed. For more info, contact your network administrator.
```
 
Tijdens uitvoeren opzetten server werd volgende waarschuwing weergegeven bij deze stage:

```
Alfa2: WARNING: User CAcdric does not exists (skipping)
```

### Uit te voeren testen Computers

| Nr test | Wat moet er getest worden | In orde? | 
| :--- | :--- | :--- | 
| 1 | Is er voor elke afdeling minstens 1 werkstation? | **Ja** |
| 2 | Zijn er minstens 5 werkstations? | **Ja** |
| 3 | Heeft elke gebruiker zijn werkstation? | **Nee** |

 - Gebruiker `Cédric` heeft geen werkstation
 
Tijdens uitvoeren opzetten server werd volgende error weergegeven bij deze stage:

```
Alfa2: New-ADComputer : Identity info provided in the extended attribute: 'ManagedBy' could not be resolved. Reason: 'Director
Alfa2: y object not found'.
Alfa2: At C:\tmp\vagrant-shell.ps1:394 char:1
Alfa2: + New-ADComputer "Ontwikkeling_003" -SamAccountName "Ontwikkeling003" - ...
Alfa2: + ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Alfa2:     + CategoryInfo          : InvalidData: (CN=Ontwikkeling...DC=red,DC=local:String) [New-ADComputer], ADIdentityReso
Alfa2:    lutionException
Alfa2:     + FullyQualifiedErrorId : ActiveDirectoryCmdlet:Microsoft.ActiveDirectory.Management.ADIdentityResolutionException
Alfa2:    ,Microsoft.ActiveDirectory.Management.Commands.NewADComputer
```

### Uit te voeren testen Beleidsregels

**Kan niet testen, want kan niet inloggen op gebruikers.**

| Nr test | Wat moet er getest worden | In orde? |
| :--- | :--- | :--- |
| 1 | Heeft de `IT_Administratie` toegang tot het control panel? | Ja/Nee |
| 2 | Hebben de afdelingen `Verkoop`, `Ontwikkeling`, `Administratie` en `Directie` geen toegang tot het control panel? | Ja/Nee |
| 3 | Is het games link menu uit het start menu voor alle afdelingen verdwenen? | Ja/Nee |
| 4 | Hebben de afdelingen `IT_Administratie`, `Directie` en `Ontwikkeling` toegang tot de eigenschappen van de netwerkadapters? | Ja/Nee |
| 5 | Hebben de afdelingen `Administratie` en `Verkoop` geen toegang tot de eigenschappen van de netwerkadapters? | Ja/Nee |


### Opmerkingen


## Test AGDLP Permissions

**Testplan niet compleet voor deze test.**

## Test Prepare AD for SCCM

**Niet getest, want Bravo2 niet getest.**