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

## DNSInstall

De commando's om alles te checken staan aangegeven.
Deze zijn afgestemd op Windows PowerShell.
Daaronder staat het verwachte resultaat.
Na het runnen van het script, geef volgende in:

1. Het script past de tijdzone aan. <br/>
     `Get-TimeZone` <br/>
        - DisplayName: (UTC+01:00) Brussel, Kopenhagen, Madrid, Parijs <br/>
     `Get-Culture` <br/>
        - LCID: 2067 <br/>
        - Name: nl-BE <br/>
        - DisplayName: Nederlands (België) <br/>       

2. De adapternaam wordt gewijzigd. Zowel voor LAN als NAT. Op deze server is het de bedoeling dat er alleen een host-only adapter is (LAN):<br/>   
     `Get-NetAdapter -Name "*"`<br/>
    	- LAN<br/>
		- NAT wanneer deze zichtbaar is, zal het commando om de adapter te disablen uit commentaar moeten gehaald worden uit het DNSConfig script.<br/>

3. Netwerkinstellingen controleren. Kijk hiervoor naar de LAN adapter. <br/>
     `ipconfig`<br/>
        - IP-address: 172.18.1.67 <br/>
        - Subnetmask: 255.255.255.224 <br/>
        - Default Gateway: 172.18.1.98 <br/>
        - DNS:<br/>
            - 172.18.1.66<br/>
            - 172.18.1.67<br/>
 
 4. De DNS controleren.  
	 `Get-DnsClientServerAddress` <br/>
        - 172.18.1.66, 172.18.1.67 <br/>
 
 5. Firewall status. <br/>
	 `netsh advfirewall show private|public|domain` <br/>
		- Verwachte uitkomst is "off" want er is een firewall geconfigureerd op het domein. <br/>
 
 6. ADDS controle. Gaat testen of er wordt aangemeld met administrator, DNS geïnstalleerd is en of DSRM goed is ingesteld.  
     `Test-ADDSDomainControllerInstallation -InstallDns -Credential (Get-Credential) -DomainName (Read-Host "Domain to promote into")` <br/>
		- Er gaat gevraagd worden om de credentials in te geven. <br/>
		- Nadien zal er gevraagd worden "Domain to promote into:". Met andere woorden hier gaat men het domein opgeven. In ons geval "red.local". <br/>
 
 7. Controle of domein "red.local" gejoind is.  
     `Get-WmiObject -Class Win32_ComputerSystem` <br/>
	 	- Domain: red.local <br/>
		- Name: ns2 <br/>

##  DNSConfig

 1. Kijken of DNS goed is geconfigureerd. <br/>
	 `Get-DnsClientServerAddress` <br/>
	 	- Hier zouden de adapters moeten komen met het adres. <br/>

 2. Met het volgende commando gaat men de forward servers overlopen. Omdat het hier over meerdere gaat namelijk de Hogent servers, gaan we dit wegschrijen in een "txt" file. <br/>
	 `Get-Content C:\scripts\servers.txt | Foreach-Object {get-dnsserverforwarder -computer $_}` <br/>
		- De servernamen van Hogent worden in dit script verwacht.
