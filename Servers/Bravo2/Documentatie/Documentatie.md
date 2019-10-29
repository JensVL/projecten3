## Documentatie Bravo 2

Auteurs: Levi Goessens en Arno Van Nieuwenhove

### Opzetten testomgeving
1. Download een Windows Server 2019 ISO file.
2. Maak 2 VM's aan in VirtualBox, Alfa 2 en Bravo 2.
3. Start de VM's en installeer de Guest Additions.
4. Toevoegen van een shared folder
	- Klik op **Apparaten** in het menu
	- Kies voor **Gedeelde mappen** en dan **Instellingen gedeelde mappen**
	- Selecteer **Voegt gedeelde map toe**
	- selecteer het **path** waar de script voor respectievelijk Alfa2 en Bravo2 staan
	- vink **Automatisch koppelen** en **Permanent maken** aan
	- Druk op ok, de folder is aangemaakt
5. Klik op File explorer en vervolgens op Network en sta Network Discovery toe. We zien nu de map VBOXSVR, met hierin onze scripts.

### Uitvoeren scripts
1. BELANGRIJK! Voer nu eerst voor Alfa 2 het script 1_RUNFIRST.ps1 uit door hierop met de rechtermuisknop te klikken en te kiezen voor 'Run with powershell'. Hierdoor worden ook automatisch de andere scripts (2_installDCDNS, 3_ConfigDCDNS en 4_ADstructure) uitgevoerd.
2. Aangezien Bravo 2 repliceert van Alfa 2, moeten deze scripts helemaal doorlopen zijn voor de scripts van Bravo 2 uitgevoerd mogen worden.
3. Eens de scripts van Alfa 2 doorlopen zijn, voer je in volgorde de scripts van Bravo 2 uit: 1_RUNFIRST.ps1, 2_InstallDCDNS.ps1 en ten slotte 3_ConfigDCDNS.ps1

### Vagrant
1. Ga naar de folder waar je de box wilt gebruiken.
2. Surf naar volgende website: https://app.vagrantup.com/gusztavvargadr/boxes/windows-server (hier vindt u informatie hoe de box moet worden geïnstalleerd).
3. Duw rechtermuisknop in de folder waar de box moet komen, nadien "Git Bash Here".
4. Geef `vagrant init gusztavvargadr/windows-server` in.
5. Wanneer stap 4 gelukt is, geef je `vagrant up` in. Dit kan even duren.
6. Voor de Vagrantfile, maak je best een lege file eerst aan. Zorg dat dit een "yaml" file is.
7. De inhoud werd gekopieerd uit een Vagrantfile van projecten2.
8. Waar er zeker op moet gelet worden is lijn 7, 12, 29, 104-107.
