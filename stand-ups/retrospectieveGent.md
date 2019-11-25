# Retrospectieve Team Red - Gent

## Wat ging goed?
- Goede planning, tijds- en taakverdeling
- Goede organisatie
- Iedereen hielp elkaar, teamwork
- Netwerk heeft het probleem opgelost met virtualbox (bridged adapter) -> maar host-only adapters zie je niet meer
- Communicatie met Aalst verliep goed
- Zo goed als iedereen was op tijd aanwezig

## Wat ging minder goed?
- Meer testen op voorhand, troubleshooten
- Esxi-server op voorhand niet getest en werkte niet (enkel Alfa2 en Bravo2)
- Bij Firewall was het op voorhand niet duidelijk dat er gerouteerd moest worden. Dit moest op de productie zelf nog gebeuren.
- Firewall: Op de first-release zelf met het netwerk testen, waardoor er nog problemen waren met OSPF 
- Na een bepaalde tijd deed iedereen wat hij/zij wou
- November2 zou eerder moeten afgewerkt worden, was niet klaar voor de first-release
- Linux had geen tijd, waardoor netwerk niet kon integreren
- Tijd op de post-its klopte niet (door probleem met esxi-server)
- Linux heeft de kabels van Windows uitgetrokken en heeft dit niet met Windows gecommuniceerd
- Mike2: Error met IIS Server (opgelost na kabels opnieuw instoppen)

## Wat heb je geleerd?
- JOLIET: wanneer je iets in het iso-bestand zet, behoudt dit de naam
- Op voorhand testen, integratietesten op voorhand
- Dingen die noodzakelijker zijn, zouden eerder moeten afgewerkt worden
- Wanneer iets niet werkt, beslissing rapper nemen. Hiervoor zou een korte stand-up moeten gehouden worden om deze beslissing te nemen
- Oscar2: Installatie van prtg moet na het domein joinen geïnstalleerd worden
- Firewall: Oplossing = statische routering
- Op release met intern netwerk werken als de esxi-server niet werkt (alles op hetzelfde netwerk zetten)

## Waar heb je nog problemen mee?
- Communicatie onderhouden
- Testplannen en testrapporten stonden niet allemaal op de release-branch -> Iedereen zou slack op voorhand moeten lezen
- Netwerk - Linux
- Bij Kilo2 was het moeilijk om de DHCP-server te autoriseren
- Kilo2 kon geen clients in een ander VLAN een IP geven
- Zulu2 kon OSPF niet gebruiken
- Charlie2: probleem met PrepareADSchema
- Alfa2: Clients 
- November2 zegt dat hun server werkt, maar blijkt niet te werken voor Delta2
  
## Hoe moeten we de problemen oplossen?
- Esxi-server 
- Netwerk: Statische routes toevoegen voor Zulu2; ACL's toevoegen
- Netwerk: VPN -> Linux (afwachten op Linux)
- Clients: Kunnen nooit inloggen op een domeincontroller 
- Charlie2: PrepareADScheme
- Delta2: Deploy
- Iemand die de planning in het oog houdt
- Laatste startmoment op de post-its vermelden
- Post-it overzichtelijker verdelen (horizontale en verticale lijnen) 
  
## Teamevaluatie
Staat voorlopig nog allemaal op niet bekwaam. Zijn er nog evaluatiepunten die moeten toegevoegd worden voor het team?  
- Netwerk + services als geheel
  - [ ] Nog niet bekwaam: ...
- Troubleshooting
  - [ ] Nog niet bekwaam: ...
- Technische documentatie
  - [ ] Nog niet bekwaam: ...  
