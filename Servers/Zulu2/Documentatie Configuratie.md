# Documentatie Configuratie PfSense: 
### Inhoudsopgave
1. [Intro](#Intro)  
2. [Algemene configuratie](#Algemeen)  
3. [Vlans](#Vlan)  
4. [Firewall Regels](#Firewall)    
5. [Automatisatie](#Automatisatie)
6. [Bronnen](#Bronnen)  
 
## 1. Intro <a name="Intro"></a>  
Voor we beginnen met het configureren van deze firewall moeten we eerst weten hoe PfSense werkt en wat we precies willen doen met PfSense.  

PfSense is een [Stateful](https://en.wikipedia.org/wiki/Stateful_firewall) firewall. Bij default zal PfSense al het verkeer tegenhouden die door de WAN interface gaat. Dit betekent dat als er bijvoorbeeld verkeer komt van een ander netwerk of het internet door de firewall, zal PfSense deze packets bij default tegenhouden door een impliciete firewall regel op de WAN interface.  

Als je host systeem bijvoorbeeld op de LAN bevindt en naar google.com gaat, controleert PfSense de LAN interface regels en staat het verkeer toe door de default LAN regels. Het creëert dan een staat. Een staat is wat de firewall vertelt wat er aan de hand is met elke verbinding die met succes tot stand is gebracht. De firewall houdt ze allemaal bij in een statustabel.  

Bij elke status onthoudt de firewall een hoop informatie over die verbinding. Het weet dat een bepaalde PC verbinding heeft gemaakt met  website google.com door een bepaalde poort. Als PfSense vervolgens een antwoord van google.com ontvangt zal PfSense dit verkeer toelaten naar de PC. Staten duren niet te lang en zullen vervallen nadat ze inactief zijn.

![stateful](img/stateful.jpg)  

In dit project heeft onze firewall de volgende taken:
* zulu2 bevindt zich tussen VLANs 600 en 700.
* OS: De meest recente stabiele versie van PFSense.
* Deze Firewall heeft NAT uitgeschakeld! NAT is actief op de router Router1.
* Configureer deze firewall zodanig dat enkel die poorten openstaan die echtnodig zijn binnen uw netwerk.
* Configureer deze firewall zodanig dat je vanuit elk subnet van je netwerk/LAN(zowel de VLANs als de router subnets) kan communiceren met het internet.

*In de volgende secties zullen we PfSense stap voor stap configureren zodat het elke taak wordt gerealiseerd.*


## 2. Algemene configuatie <a name="Algemeen"></a>  




## 3. Vlans <a name="Vlan"></a>  


## 4. Firewall regels <a name="Firewall"></a>  


 
## 5. Automatisatie <a name="Automatisatie"></a>  

       

## 6. Bronnen <a name="Bronnen"></a>  
<http://pfsensesetup.com/ip-spoofing-and-defenses/>
<https://docs.netgate.com/pfsense/en/latest/nat/index.html>
<https://docs.netgate.com/pfsense/en/latest/book/config/pfsense-xml-configuration-file.html>
<https://docs.netgate.com/pfsense/en/latest/config/manually-editing-the-pfsense-configuration.html>
<https://docs.netgate.com/pfsense/en/latest/usermanager/locked-out-of-the-webgui.html>
<https://nguvu.org/pfsense/pfsense-baseline-setup/>
<https://docs.netgate.com/pfsense/en/latest/book/firewall/firewall-fundamentals.html>
