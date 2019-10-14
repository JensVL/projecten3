# Lastenboek

Naam leden: Laurens Blancquaert-Cassaer en Kimberly De Clercq

Taak team: Alfa2 server

## Opdrachtomschrijving
Alfa2 is de hoofd Domain Controller van het windows red domein. Alfa2 is ook de Master DNS server van heel het domein.
Alle userauthenticatie gebeurd via Active Directory. Dit betekent dat werkstations geen eigen users kunnen aanmaken. Dit gebeurt allemaal in de Domain Controller. We zorgen er ook voor dat er beleidsregels en speciale permissies voor de fileserver (lima2) worden gemaakt.

## Overzicht deeltaken:
| TeamLid                     | Deeltaak          | Time Estimated | Time spent  |
| --------------              | --------------    | -------------- | --------------|
| Laurens Blancquaert-Cassaer | Opzoekingswerk AD/DNS   | 3        |               |
| Laurens Blancquaert-Cassaer | AD/DNS installatie + config   |  6 |      7         |
| Laurens Blancquaert-Cassaer | documentatie maken AD/DNS  |  2    |               |
| Laurens Blancquaert-Cassaer | Opzoekingswerk AGDLP permissies | 3 |              |
| Laurens Blancquaert-Cassaer | AGDLP permissies implementeren  | 4 |      4        |
| Laurens Blancquaert-Cassaer | Documentatie maken AGDLP permissies | 2 |          |
| Laurens Blancquaert-Cassaer | AD voorbereiden op SCCM install script + opzoekingswerk | 4 |    2      |
| Kimberly De Clercq | Opzoekingswerk AD Structuur | 2  | 1h50   |
| Kimberly De Clercq | Opzoekingswerk Beleidsregels | 3 | 2h30   |
| Kimberly De Clercq | AD Structuur installatie + configuratie | 8 |  4 |
| Kimberly De Clercq | Beleidsregels installatie + configuratie | 12 |  3h30  |
| Laurens Blancquaert-Cassaer  | Testplan opstellen (+ zelf testen) alfa2 server | 4 |  1.5 |
| Kimberly De Clercq  | Testplan opstellen (+ zelf testen) alfa2 server | 4  | 2  |

Tests van de ALFA2 server wordt gedaan door: **TEAMLID_DIE_TESTRAPPORT_ALFA2_DOET_HIER**

## Vragen
Waarvoor staat "ns1" ?   => Name Server 1 = DNS  

Group Policies (GPO) in Powershell?   
1. Group Policy Management Editor > DisablingGameLink > User Configuration > Policies > Administratieve Templates: Policy definitions > Control Panel > Display > `Disable the Display Control Panel`
2. Group Policy Management Editor > DisablingGameLink > User Configuration > Policies > Administratieve Templates: Policy definitions > Start Menu and Taskbar > `Remove Games link from Start Menu`
3. Group Policy Management Editor > DisableNetwerkadapters > User Configuration > Policies > Administratieve Templates: Policy definitions > Network > Network Connections > `Prohibit access to properties of a LAN connection`
