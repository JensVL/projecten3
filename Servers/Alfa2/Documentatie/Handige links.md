# Handige links

## Algemeen
[Packer templates](https://github.com/ruzickap/packer-templates/tree/master/http)  

## Afdelingen/groepen
[Managing OUs](https://blog.netwrix.com/2018/06/26/managing-ous-and-moving-their-objects-with-powershell/)  
[New-ADComputer](https://docs.microsoft.com/en-us/powershell/module/addsadministration/new-adcomputer?view=win10-ps)    
[Roaming profiles](https://sid-500.com/2017/08/27/active-directory-configuring-roaming-profiles-using-gui-and-powershell/)   

## Beleidsregels op gebruikersniveau
[Link GPO to OU](https://www.manageengine.com/products/active-directory-audit/kb/how-to/how-to-link-a-gpo-to-an-ou.html)  
[GPO in GUI](https://www.dell.com/support/article/be/fr/bedhs1/sln283093/windows-server-cr%C3%A9ation-et-liaison-d-un-objet-de-strat%C3%A9gie-de-groupe-%C3%A0-l-aide-de-la-console-de-gestion-des-strat%C3%A9gies-de-groupe?lang=fr)   
### Verbied iedereen uit alle afdelingen behalve IT Administratie de toegang tot het control panel  
[Group Policy](https://blog.netwrix.com/2019/04/11/top-10-group-policy-powershell-commands/)    
[Disable Control Panel Access](http://www.mustbegeek.com/disable-control-panel-access-using-group-policy-on-windows/)  
[Import-GPO](https://docs.microsoft.com/en-us/powershell/module/grouppolicy/import-gpo?view=win10-ps)   
[Get-GPO](https://docs.microsoft.com/en-us/powershell/module/grouppolicy/get-gpo?view=win10-ps)   
[New-GPO](https://sid-500.com/2017/08/25/configuring-group-policies-by-using-windows-powershell/)   
[Disable Display Control Panel](https://www.isunshare.com/windows-8/disable-display-control-panel.html)  

### Verwijder het games link menu uit het start menu voor alle afdelingen
Get-AppxPackage \*Xbox\* | Remove-AppxPackage  
[Games Link From Start Menu - Windows 7](http://www.thewindowsplanet.com/554/remove-games-link-start-menu-windows-7.htm)  

### Verbied iedereen uit de afdelingen Administratie en Verkoop de toegang tot de eigenschappen van de netwerkadapters  
[Disable-NetAdapter](https://docs.microsoft.com/en-us/powershell/module/netadapter/disable-netadapter?view=win10-ps)  
[Disable Ethernet network adapters](https://www.windowscentral.com/how-enable-or-disable-wi-fi-and-ethernet-network-adapters-windows-10)  
[Disable Network Adapter at Startup](https://www.zubairalexander.com/blog/powershell-script-to-enable-or-disable-network-adapter-at-startup-or-logon-in-windows-8-and-windows-2012/)  

### Zorg voor de juiste toegangsgroepen voor de fileserver (Modify/Read/Full) en voeg de juiste personen en/of groepen toe.  
[Set-GPPermission](https://docs.microsoft.com/en-us/powershell/module/grouppolicy/Set-GPPermission?view=win10-ps)  

### Maak gebruik van AGDLP (Account, Global, Domain Local, Permission) voor het uitwerken van de groepsstructuur.

## Andere
### Opslaan bureaublad: path
"C:\Users\Administrator.red\Desktop"    


© Authors:  Kimberly De Clercq