# **Testplan Bravo 2**

Een tweede Domain controller die eveneens dienst doet als tweede DNS-servervoor het domein. De buitenwereld kent deze server als “ns2”.

## Checklist
	- Vagrant Windows box
	- DNSInstall script
	- DNSConfig script


### Vagrant Windows box (Indien deze nog niet geïnstalleerd is)

1. Zorg dat je de "gusztavvargadr/windows-server" box hebt van Vagrant. Verdere informatie over deze box kan je vinden op volgende link https://app.vagrantup.com/gusztavvargadr/boxes/windows-server

2. Ga naar de directory van waar de server zou moeten booten. In ons geval is dit "C:\GitHub\p3ops-1920-red\Servers\Bravo2\Testomgeving".

3. Open een "Git Bash" in deze folder. Kan via rechtermuisklik, Git Bash here.

4. Geef het volgende in, in volgorde: `vagrant init gusztavvargadr/windows-server` `vagrant up`

5. De box is nu aangemaakt, nu de vagrant-hosts.yml en de Vagrantfile. Let op, voor de extensie! vagrant-hosts.yml dus yml bestand.

6. In die vagrant-hosts is het van groot belang dat de box bij "1." hier ook aangeduid staat: "box: gusztavvargadr/windows-server". Voor name hebben we dns2. Dit omdat dns2 naar de buitenwereld moet zichtbaar zijn.

7. In de Vagrantfile, zie je dat de Windows box nog eens terugkomt. "DEFAULT_BASE_BOX = 'gusztavvargadr/windows-server'". Onderaan worden de scripts aangeroepen, na eerste script wordt er een reboot gedaan.

8. Om aanpasseningen door te sturen wordt er gebruik gemaakt van `vagrant provision`. Soms kan een `vagrant reload` ook van pas komen. Dit zorgt voor een halt en een up achtereen.

## Voer het script DNSInstall uit

Het script gaat het volgende doen:

1. Het script past de tijdzone aan. 
    - **Get-TimeZone:**
        - Id: Romance Standard Time
    - **Get-Culture**
        - Name: eng-BE       
        
Bovenstaande kan getest worden via de gui of "ipconfig /all".

2. De adapternaam zou "LAN" moeten zijn. Dit kan getest worden door in Powershell het volgende in te geven:   
  C:\> Get-NetAdapter -Name "*"

3. Netwerkinstellingen. 
    - **ipconfig:**
        - IP-address: 172.18.1.67
        - Subnetmask: 255.255.255.224
        - Default Gateway: 172.18.1.98
        - DNS: - 172.18.1.66
               - 172.18.1.67
 
 4. De DNS controleren.   
      Via volgend commando: **Get-DnsClientServerAddress**   
      - De IPv4 adressen van DNS dat je zou moeten uitkomen zijn:
         - 172.18.1.66, 172.18.1.67 en 127.0.0.1
 
 5. ADDS controleren gaat als volgt. Onderstaande commando gaat testen of er wordt aangemeld met administrator, DNS geïnstalleerd is en of DSRM goed is ingesteld.   
      Commando: **Test-ADDSDomainControllerInstallation -InstallDns -Credential (Get-Credential) -DomainName (Read-Host "Domain to promote into")**
 
 6. Controle of firewall uitstaat. Deze zou op "off" moeten staan.   
      Commando: **netsh advfirewall show private|public|domain**
 
 7. Controle of domein "red.local" gejoind is.   
      Commando: **Get-WmiObject -Class Win32_ComputerSystem**

##  Voer het script DNSConfig uit
1. Kijken of DNS repliceert:   
     Commando: **Get-WMIObject –namespace “Root\MicrosoftDNS” –class MicrosoftDNS_Zone | Format-List Name**
     Nadien commando: **Get-WMIObject –namespace “Root\MicrosoftDNS” –class MicrosoftDNS_Zone | Where-Object {$_.Name –eq “red.local”}**
  
