# Mike2

## Omschrijving

Een member server in het domein red.local. Deze server doet dienst als Intranet-en 
CMS-server (Sharepoint) die enkel toegankelijk is voor interne systemen uit hetdomein red.local.
Het database gedeelte van deze Sharepoint server staat eveneens op de databaseserver november2.
Als inhoud voor deze CMS server voorzie je alle Windows documentatie van dit project.


## Overzicht scripts

- `toevoegen domein.ps1`
  In dit script worden de basisconfiguraties in orde gebracht
    - IP instellingen
    - configure dns
    - Uitzetten firewall
    - veranderen computernaam
    - joined domein red.local
- `prerequisites.ps1`
  Installatie van de prerequisites
- `roles.ps1`
  Installatie van rollen indien nodig
- `SPsetup.ps1`
  De SharePoint setup, deze maakt gebruik van een xml file: ´SPinstallation.xml´
- `SPinstallation.xml`
  XML file voor de setup te automatiseren, zodat bv de product key geautomatiseerd wordt ingegeven.
- `SPFarm.ps1`
  Opzetten van de server farm
    - creating the configuration database
    - install help collections
    - initialize security
    - install services
    - register features
    - install application content
    - create Central Administration site
- `SPWebApp.ps1`
  Aanmaken van WebApplicatie en Site Collection in SharePoint
    - creating Wepapplication
    - creating site collection
