# Handige links

## Algemeen
[Packer templates](https://github.com/ruzickap/packer-templates/tree/master/http)  

## Afdelingen/groepen
[Managing OUs](https://blog.netwrix.com/2018/06/26/managing-ous-and-moving-their-objects-with-powershell/)  
[New-ADComputer](https://docs.microsoft.com/en-us/powershell/module/addsadministration/new-adcomputer?view=win10-ps)    
[Roaming profiles](https://sid-500.com/2017/08/27/active-directory-configuring-roaming-profiles-using-gui-and-powershell/)   

## Beleidsregels op gebruikersniveau
### Verbied iedereen uit alle afdelingen behalve IT Administratie de toegang tot het control panel  
[Group Policy](https://blog.netwrix.com/2019/04/11/top-10-group-policy-powershell-commands/)    
[Disable Control Panel Access](http://www.mustbegeek.com/disable-control-panel-access-using-group-policy-on-windows/)  
[Import-GPO](https://docs.microsoft.com/en-us/powershell/module/grouppolicy/import-gpo?view=win10-ps)   
### Verwijder het games link menu uit het start menu voor alle afdelingen
Get-AppxPackage *Xbox* | Remove-AppxPackage  
### Verbied iedereen uit de afdelingen Administratie en Verkoop de toegang tot de eigenschappen van de netwerkadapters  
[Disable-NetAdapter](https://docs.microsoft.com/en-us/powershell/module/netadapter/disable-netadapter?view=win10-ps)  

### Zorg voor de juiste toegangsgroepen voor de fileserver (Modify/Read/Full) en voeg de juiste personen en/of groepen toe.  
[Set-GPPermission](https://docs.microsoft.com/en-us/powershell/module/grouppolicy/Set-GPPermission?view=win10-ps)  


### Maak gebruik van AGDLP (Account, Global, Domain Local, Permission) voor het uitwerken van de groepsstructuur.

## Andere
### Opslaan bureaublad: path
"C:\Users\Administrator.red\Desktop"    