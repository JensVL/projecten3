# **Testrapport November2**

Auteurs: Arno Van Nieuwenhove & Levi Goessens

## Testplan

### Resultaten naam server en domein

- Naam van server is aangepast naar "November2" maar domein joinen werkt niet. Dit kan liggen aan het feit dat November2 in een ander subnet zit. Hiervoor de router nodig etc., code ziet er nochtans oké uit voor te kunnen joinen.  

![FoutenDomain](images/domain.PNG)    
![FoutenDomain](images/domain1.png)  

### Resultaten Netwerksettings
1. Ip-address: 172.18.1.4  
2. Subnet mask: 255.255.255.192 
3. Default Gateway: 172.18.1.7 (Moet dit niet 172.18.1.1 zijn?)
4. Preferred dns: 172.18.1.66
5. Alternate dns: 172.18.1.67 
  
Alternatieve testmethode:  

- Werkt, is OK!   
  
### Resultaten correcte SQL Server Installatie

- Kan niet getest worden omdat domein niet kan worden gejoind.
  
### Resultaten testen firewall

- Firewall staat uit!  
![Firewall](images/firewall.PNG)  

## TestConfigNovember2 (powershell)
### Check-name, Check-ip-settings, Check-firewall

![AutomatedTests](images/testen.PNG)  
In de automatische test, staat er dat Subnet mask een /27 moet zijn.
Moet een /26 zijn, is wel goed ingevuld op de VM maar de automatische test klopt niet.  
Test default gateway faalt ook omdat de voorwaarde een 192.18.1.1 is en op de VM staat de default gateway ingesteld als 192.18.1.7, in beide gevallen zal het dus waarschijnlijk aan de automatische testen liggen.
