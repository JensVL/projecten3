# Testplan Papa2: SCCM server

(Een testplan is een *exacte* procedure van de handelingen die je moet uitvoeren om aan te tonen dat de opdracht volledig volbracht is en dat aan alle specificaties voldaan is. Een teamlid moet aan de hand van deze procedure in staat zijn om de tests uit te voeren en erover te rapporteren (zie testrapport). Geef bij elke stap het verwachte resultaat en hoe je kan verifiëren of dat resultaat ook behaald is. Kies zelf de structuur: genummerde lijst, tabel, secties, ... Verwijder deze uitleg als het plan af is.)

Auteur(s) testplan: Laurens Blancquaert-Cassaer en ...

# BELANGRIJK:
Indien je om Papa2 op te stellen een error krijgt bij het opzetten van de Server met Vagrant op Windows **(Met een Linux host werkt Vagrant perfect)** dan moet je het volgende doen om de server te kunnen opzetten om hem te testen: 
(De error in kwestie gebeurt net nadat de hostname wordt ingesteld en de VM reboot. Het is een lange WSMANERROR)

         1) Doe Vagrant up zoals je normaal doet.
         2) Wanneer de error voorkomt en vagrant stopt open de VM manueel in Virtualbox (er is een GUI dus je kan hem gebruiken zoals een normale Windows Server VM)
         3) Aangezien de hostname al succesvol is aangepast moeten we RUNFIRST.ps1 niet meer uitvoeren. 
         4) Op de Papa2 Windows Server VM moet je nu inloggen met username: vagrant password: vagrant (LET OP IS IN QUERTY!)
         5) De Vagrant error gebeurde voor de Shared folders correct werden ingesteld. Dit moeten we nu dus doen. Open This PC en open de network tab. Je krijgt een message dat "Device Discovery" aan moet staan. Zet dit aan.
         6) In de network tab (van this PC) klik op VBOXSVR dan op \\VBOXSVR\vagrant en kopieer alle bestanden in deze map naar "C:\Vagrant" (maak de directory aan indien hij nog niet bestaat) 
         5) Open PowerShell ISE als administrator en voer het volgende commando uit:
         
                  Set-ExecutionPolicy Unrestricted
         
         6) Klik in Powershell ISE op "open script" en ga naar "C:\Vagrant" en voer het script 2_BasicConfig.ps1 uit
         7) Restart server
         8) Als dit klaar is voer 3_SCCMPrereqInstall.ps1 uit.
         9) Papa2 is nu correct opgesteld (Task sequence moet manueel gemaakt worden met GUI zie documentatie van Ferre)


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
