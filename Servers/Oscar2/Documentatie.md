# Technische documentatie

## Nodige software

Om de PRTG server op een correcte mannier te installeren hebben we verschillende programma's nodig:
1. Vagrant: https://www.vagrantup.com
2. Virtualbox: https://www.virtualbox.org/wiki/Downloads

## Creatie windows server 2019

1. Voor een eerste opzetting van de PRTG server maken we gebruik van Vagrant en een windows_2019 Vagrant box.
2. De Vagrant box zal automatisch worden geïnstalleerd op uw host-systeem.
3. We gaan er van uit dat u deze repository heeft gecloned op uw host-systeem met behulp van powershell of git-bash.
4. Open op uw host-systeem git-bash en navigeer naar de directory waar u deze repository heeft gecloned en navigeer dan naar p3ops-1920-red/Servers/Oscar2/testomgeving
5. Voer in deze directory het commando "vagrant up" uit.
6. De windows server wordt nu automatisch geïnstalleerd op uw host-systeem.
7. U krijgt een bericht te zien in de command-line als de server volledig geïnstalleerd is.
