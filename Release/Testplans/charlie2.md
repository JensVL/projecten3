# Testplan Charlie2 - Exchange Server

#### Uit te voeren stappen


##### Test mail verzenden binnen domein red.local

1. Surf naar https://mail.red.local/owa en log in met de gebruikersnaam van een willekeurige gebruiker en het wachtwoord "Administrator 2019". De lijst van actieve gebruikers vind je in het Exchange-beheerscentrum onder geadresseerden.
2. Verzend een mail naar een e-mailadres van een willekeurige andere gebruiker binnen het domein.
3. Log in bij die andere gebruiker en controleer of de mail is aangekomen.



##### Test mail verzenden binnen domein green.local

1. Surf naar https://mail.red.local/owa en log in met de gebruikersnaam van een willekeurige gebruiker en het wachtwoord "Administrator 2019". De lijst van actieve gebruikers vind je in het Exchange-beheerscentrum onder geadresseerden.
2. Verzend een mail naar een e-mailadres van een willekeurige andere gebruiker in het domein green.local.
3. Log in bij die andere gebruiker op de green.local mailserver en controleer of de mail is aangekomen.



#### Troubleshooting

Wanneer er iets fout loopt, dan kunt u alle logbestanden terugvinden in de map `C:\ScriptLogs`. Bekijk deze allemaal eens en kijk of er foutmeldingen werden gegenereerd.

Controleer zeker ook volgende zaken:

- Kan je pingen naar Alfa2 (172.18.1.66)? Indien nee,
  - Kijk via ipconfig /all of ipv4 autoconfiguration aan staat => oplossingen zie: <https://community.spiceworks.com/how_to/62077-how-to-disable-ip-autoconfiguration-in-core-server>
  - Kijk of je ip-instellingen correct zijn op beide servers
- Kan je pingen naar de mailserver in het domein green.local / Delta1 (172.16.1.68)? Indien nee,
  - Troubleshoot waar het probleem in de netwerkinfrastructuur zit
- Zit Charlie2 in het domein red.local?
  - Controleren in powershell via: Get-ADComputer -Filter *
- Indien mail blijft vastzitten in draft
  - 'Mail exchange transport' service herstarten
  - Controleren of DNS-lookup in Exchange Server Management Console correct is ingesteld op de juiste adapter.
