# Testrapport Charlie2 - Exchange Server

Auteur(s) testrapport: Kimberly De Clercq   

Labo gemaakt door: Jannes Van Wonterghem en Joachim Van de Keere  
Uitvoerder(s) test: Kimberly De Clercq  
Uitgevoerd op: 09/12/2019

#### Uit te voeren stappen

1. Open een browser op de server of op de host (dan moet je wel de dns-server instellen op Alfa2) en ga naar het Exchange-beheercentrum via https://mail.red.local/ecp. Log in met de login-gegevens van de AD-administrator. Selecteer de gewenste taal en tijdszone en ga verder.
2. Selecteer in de linkerkolom 'servers' en klik op het potlood-icoon/wijzigen voor server Charlie2. Ga vervolgens naar 'DNS-zoekopdrachten'.
3. Controleer of het correcte DNS-adres verschijnt en selecteer indien nodig de juiste netwerkadapter, zowel voor interne als externe zoekopdrachten zodat het ip-adres van de dns-server Alfa2 verschijnt. Sla vervolgens de wijzigingen op.

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

###### Resultaat bij uitvoeren testplan
- Werkt volledig, kan enkel nog niet testen met Linux.
