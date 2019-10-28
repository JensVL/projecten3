# Testplan Charlie2 - Exchange Server

#### Uit te voeren stappen

##### Alfa2 opzetten

1. Installeer [Windows Server 2016](https://software-download.microsoft.com/download/pr/Windows_Server_2016_Datacenter_EVAL_en-us_14393_refresh.ISO) (opslag 50GB) met een Host-only adapter in het netwerk 172.18.1.64/27.
2. Maak een gedeelde folder in virtualbox met de map "p3ops-1920-red\Servers\Alfa2\Testomgeving\Scripts" uit de GitHub-repository.

4. Run het powershellscript '1_RUNFIRST.ps1' in de gedeelde schijf als administrator en bevestig de wijzigingen aan de 'execution policy' door de vraag met 'A' te beantwoorden.



##### Charlie2 opzetten

1. Installeer [Windows Server 2016](https://software-download.microsoft.com/download/pr/Windows_Server_2016_Datacenter_EVAL_en-us_14393_refresh.ISO) (opslag 50GB) met een Host-only adapter in hetzelfde netwerk 172.18.1.64/27 als Charlie2. Voor testen zonder integratie met het netwerk moet je ook een NAT adapter instellen.
2. Voer de installatieschijf van [Exchange Server 2016 CU14](https://download.microsoft.com/download/f/4/e/f4e4b3a0-925b-4eff-8cc7-8b5932d75b49/ExchangeServer2016-x64-cu14.iso) in, schakel de server uit, wijzig de opstartvolgorde van de schijven zodat de harde schijf op de eerste plaats staat en start de server opnieuw op.
3. Maak een gedeelde folder in virtualbox met de map "p3ops-1920-red\Servers\Charlie2\scripts" uit de GitHub-repository.

4. Run het powershellscript '1_RenameServer.ps1' in de gedeelde schijf als administrator en bevestig de wijzigingen aan de 'execution policy' door de vraag met 'A' te beantwoorden.

5. Open een browser op de server of op de host (dan moet je wel de dns-server instellen op Alfa2) en ga naar het Exchange-beheercentrum via https://mail.red.local/ecp. Log in met de login-gegevens van de AD-administrator. Selecteer de gewenste taal en tijdszone en ga verder.

6. Selecteer in de linkerkolom 'servers' en klik op het potlood-icoon/wijzigen voor server Charlie2. Ga vervolgens naar 'DNS-zoekopdrachten'.

7. Controleer of het correcte DNS-adres verschijnt en selecteer indien nodig de juiste netwerkadapter, zowel voor interne als externe zoekopdrachten zodat het ip-adres van de dns-server Alfa2 verschijnt. Sla vervolgens de wijzigingen op.



##### Test mail verzenden

1. Surf naar https://mail.red.local/owa en log in met de gebruikersnaam van een willekeurige gebruiker en het wachtwoord "Administrator 2019". De lijst van actieve gebruikers vind je in het Exchange-beheerscentrum onder 
2. Verzend een mail naar een e-mailadres van een willekeurige andere gebruiker binnen het domein.
3. Log in bij die andere gebruiker en controleer of de mail is aangekomen.

#### Troubleshooting

Wanneer er iets fout loopt, dan kunt u alle logbestanden terugvinden in de map `C:\ScriptLogs`. Bekijk deze allemaal eens en kijk of er foutmeldingen werden gegenereerd.

Controleer zeker ook volgende zaken:

- Kan je pingen naar Alfa2 (172.18.1.66)? Indien nee,
  - Kijk via ipconfig /all of ipv4 autoconfiguration aan staat => oplossingen zie: <https://community.spiceworks.com/how_to/62077-how-to-disable-ip-autoconfiguration-in-core-server>
  - Kijk of je ip-instellingen correct zijn op beide servers
- Zit Charlie2 in het domein red.local?
  - Controleren in powershell via: Get-ADComputer -Filter *
- Indien mail blijft vastzitten in draft
  -  'Mail exchange transport' service herstarten
  - DNS-lookup controleren in Exchange-beheercentrum



