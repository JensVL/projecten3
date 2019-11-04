# Stappenplan/Testplan Oscar 2
1. Begin met een fresh install van Windows server 2016, dit mag eventueel een box zijn.
2. Voor performantie kies je best voor een standard install (geen desktop experience)
3. Download de install-files voor prtg network monitor: https://www.paessler.com/prtg?gclid=CjwKCAjwo9rtBRAdEiwA_WXcFqK0dpgMVOrmupjCeYhnDSXde17AeYfvtsaHhZ3ktcXISQOhWwGizxoCCxQQAvD_BwE
4. Indien je dit rechtstreeks op je VM downloadt, mag je naar stap "12" gaan
5. Indien je dit via een shared folder op je VM wilt krijgen, installeer dan eerst Virtualbox Guest Additions
6. In mijn geval was dit te vinden op drive D:
7. Maak nu een shared folder aan
8. Gebruik het commando "net use x: \\vboxsvr\[SHAREDFOLDER]"
9. Er is nu een 'netwerkschijf' x:
10. Plaats op de hostpc de installatiefiles voor PRTG
11. Vind de files in de shared folder op de guest
12. Run de installer en volg de instructies
13. Open een browser en surf naar het IP-adres van de prtg-server (in dit geval 127.0.0.1)
14. Volg de SMART-setup instructies (Geel kader dat langs de rechterkant zou moeten verschijnen)