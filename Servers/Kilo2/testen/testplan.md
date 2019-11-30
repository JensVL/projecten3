## Wat verwacht wordt van de Kilo2 server

*Is een member server van domein red.local
*Is een DHCP server voor de interne werkstations
*Server is hernoemt naar "Kilo2"
*Server bevindt zich op vlan 300


## Werkwijze testplan(stappenplan)
Open het stappenplan en volg de stappen.

### Zet een klein netwerk op:
Benodigdheden:
    - Kilo2
    - Alpha2
    - 2 clients

### Werkwijze
-Zet het netwerk op als volgt:

![Opstelling]()

-Configureer Alpha2 als een domeincontroller
-Configureer Kilo2 als een DHCP-server
-Voeg Kilo2 toe aan het domein van Alpha2
-Test Kilo2 volgens het stappenplan
-Controleer of client1 en client2 automatisch een ip hebben toegewezen gekregen van Kilo2
