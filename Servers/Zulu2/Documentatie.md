# Technische documentatie Firewall:  

## AchtergrondInformatie:  

PfSense is een open source firewall die draait op FreeBSD, een OS gebaseerd op UNIX. De software staat wereldwijd bekend omdat het heel gebruiksvriendelijk en gratis is.  
We kunnen PfSense laten werken op een PC of VM. De configuratie gebeurd op de shell zelf of via een web-interface. In deze documentatie gaan we gebruik maken van VirtualBox (testomgeving) om de installatiestappen gemakkelijk uit te leggen.  
In de productie omgeving moeten we echter hyperV gebruiken maar dit duurt een beetje langer.  

## Installatie:  

1. Downloaden ISO file  
    1. Ga naar de download page van [PfSense](https://www.pfsense.org/download/) .  
    2. Kies:  
	   Architecture > AMD64(64-bit)  
       Installer > CD Image(ISO) Installer  
       Mirror > Frankfurt, Germany  
    3. Download (664mb)  
	

## VirtualBox:  

1. Create FreeBSD Virtual Machine  
   1. Type > BSD , Version > FreeBSD(64bit), Default settings  
   2. Settings > Network:  
      Adapter 1 > Bridged Adapter  
	  Adapter 1 > Internal Network  
   
   3. Mount disk > pfSense-CE-2.4.4-RELEASE-p3-amd64  
   4. Start VM > Doe de Installatie > Reboot en Unmount de ISO file  

PfSense staat nu op de hardeschijf met de [Defaultconfiguration](https://docs.netgate.com/pfsense/en/latest/install/installing-pfsense.html#pfsense-default-configuration) .We moeten nu de firewall verder configureren via de shell menu of de WebGUI.  


## Webconfig:  


## Bronnen:  

<https://docs.netgate.com/pfsense/en/latest/install/installing-pfsense.html>  
<https://docs.netgate.com/pfsense/en/latest/virtualization/virtualizing-pfsense-with-hyper-v.html>  
<https://samuraihacks.com/install-pfsense-in-virtualbox/>  
<https://www.ceos3c.com/pfsense/pfsense-2-4-installation-step-step-overview/>  
<https://www.youtube.com/watch?v=h97J70hzcP0>  
<https://www.youtube.com/watch?v=6s5wvmlESfo>  
<https://www.pfsense.org/getting-started/>

