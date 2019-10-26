
## Documentatie Bravo 2

Auteurs: Levi Goessens en Arno Van Nieuwenhove

### Opzetten testomgeving
    1. Download een Windows Server 2019 ISO file.
    2. Maak 2 VM's aan in VirtualBox, Alfa 2 en Bravo 2.
    3. Start de VM's en installeer de Guest Additions.
    4. Na de reboot voegen we een shared folder toe. Klik in het menu op 'Apparaten', vervolgens kiezen we voor 'Instellingen gedeelde mappen' bij 'Gedeelde mappen'. Klik op 'voegt gedeelde map toe', 
    geef vervolgens het pad mee waar de scripts voor respectievelijk Alfa 2 of Bravo 2 staan en vink zowel 'Automatisch koppelen' als 'Permanent maken' aan. Wanneer we nu op 'OK' duwen is de shared folder aangemaakt.
    5. Klik op File explorer en vervolgens op Network en sta Network Discovery toe. We zien nu de map VBOXSVR, met hierin onze scripts.

### Uitvoeren scripts
    1. BELANGRIJK! Voer nu eerst voor Alfa 2 het script 1_RUNFIRST.ps1 uit door hierop met de rechtermuisknop te klikken en te kiezen voor 'Run with powershell'. Hierdoor worden ook automatisch de andere scripts (2_installDCDNS, 3_ConfigDCDNS en 4_ADstructure) uitgevoerd.
    2. Aangezien Bravo 2 repliceert van Alfa 2, moeten deze scripts helemaal doorlopen zijn voor de scripts van Bravo 2 uitgevoerd mogen worden.
    3. Eens de scripts van Alfa 2 doorlopen zijn, voer je in volgorde de scripts van Bravo 2 uit: 1_RUNFIRST.ps1, 2_InstallDCDNS.ps1 en ten slotte 3_ConfigDCDNS.ps1

### Toepassen beleidsregels
