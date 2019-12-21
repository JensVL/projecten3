# TestRapport Netwerkopstelling

datum: 09/12/2019

## Voorbereiding

Benodigdheden: 3 pc's

1. Zet de wificonnectie op elke pc uit.
2. Steek pc1 in Switch 7 en configureer Ethernetadapter met volgende gegevens:

- IP: 172.18.1.70
- Subnetmask: 255.255.255.224
- Default gateway: 172.18.1.65
- DNS: 8.8.8.8

3. Steek pc2 in Switch 5 en configureer Ethernetadapter met volgende gegevens:

- IP: 172.18.1.8
- Subnetmask: 255.255.255.192
- Default gateway: 172.18.1.7
- DNS: 8.8.8.8

4. Steek pc3 in Switch 4 en configureer Ethernetadapter met volgende gegevens:

- IP: 172.18.0.20
- Subnetmask: 255.255.255.0
- Default gateway: 172.18.0.1
- DNS: 8.8.8.8

## Testen

### Connectiviteit

1. Ping van pc1 naar pc2: open een command prompt op pc1 en voer `ping 172.18.1.8` uit. Dit is gelukt.
2. Ping van pc2 naar pc1: open een command prompt op pc2 en voer `ping 172.18.1.70` uit. Dit is gelukt.
3. Ping van pc1 naar pc3: open een command prompt op pc1 en voer `ping 172.18.0.20` uit. Dit is gelukt.
4. Ping van pc3 naar pc1: open een command prompt op pc3 en voer `ping 172.18.1.70` uit. Dit is gelukt.
5. Ping van pc2 naar pc3: open een command prompt op pc2 en voer `ping 172.18.0.20` uit. Dit is gelukt.
6. Ping van pc3 naar pc2: open een command prompt op pc3 en voer `ping 172.18.1.8` uit. Dit is gelukt.

### Internet

1. Test internetconnectiviteit op pc1: open een webbrowser op pc1 en surf naar een willekeurige pagina. Dit is gelukt.
2. Test internetconnectiviteit op pc2: open een webbrowser op pc2 en surf naar een willekeurige pagina. Dit is gelukt.
3. Test internetconnectiviteit op pc3: open een webbrowser op pc3 en surf naar een willekeurige pagina. Dit is gelukt.
