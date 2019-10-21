# Testplan Charlie2 - Exchange Server

#### Uit te voeren stappen

1. Installeer [Windows Server 2016](https://software-download.microsoft.com/download/pr/Windows_Server_2016_Datacenter_EVAL_en-us_14393_refresh.ISO) (opslag 50GB) met een Host-only adapter in het netwerk 172.18.1./27. Voor testen zonder integratie met het netwerk moet je ook een NAT adapter instellen.
2. Voer de installatieschijf van [Exchange Server 2016 CU14](https://download.microsoft.com/download/f/4/e/f4e4b3a0-925b-4eff-8cc7-8b5932d75b49/ExchangeServer2016-x64-cu14.iso) in
3. Maak een gedeelde folder in virtualbox met de map "p3ops-1920-red\Servers\Charlie2\scripts" uit de GitHub-repository.
4. Run het powershellscript '1_RenameServer.ps1' in de gedeelde schijf "Z:" als administrator, bevestig de wijzigingen aan de 'execution policy' door de vraag met 'A' te beantwoorden.



#### Troubleshooting

Wanneer er iets fout loopt, dan kunt u alle logbestanden terugvinden in de map `C:\ScriptLogs`. Bekijk deze allemaal eens en kijk of er foutmeldingen werden gegenereerd.

Controleer zeker ook volgende zaken:

- Kan je pingen naar Alfa2 (172.18.1.66)? Indien nee,
  - Kijk via ipconfig/all of ipv4 autoconfiguration aan staat => oplossingen zie: <https://community.spiceworks.com/how_to/62077-how-to-disable-ip-autoconfiguration-in-core-server>
  - Kijk of je ip-instellingen correct zijn
- Zit Charlie2 in het domein red.local
  - Controleren in powershell via: Get-ADComputer -Filter *
- Indien mail blijft vastzitten in draft => 'Mail exchange transport' service herstarten



