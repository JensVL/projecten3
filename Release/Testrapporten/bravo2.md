# Testrapport bravo2: backup domeincontroller

Auteur(s) testrapport: Detemmerman cedric

## 1_RUNFIRST script

| Nr test | Wat moet er getest worden | In orde? |
| :--- | :--- | :--- |
| 1 | De computername is bravo2 | Ja |
| 2 |Is de gebruiker red/administrator? | Ja |


## DNSInstall

| Nr test | Wat moet er getest worden | In orde? |
| :--- | :--- | :--- |
| 1 |past het script de tijdzone correct aan? | Ja|
| 2 |de adapternaam wordt gewijzigd? | Ja |
| 3 |de netwerk instellingen kloppen? | nee (Default gateway is fout)|
| 4 |dns is correct ingesteld? | Ja |
| 5 |de firewall staat "off" | Ja |
| 6 |er wordt aangemeld met admin en dns is geinstalleerd | Ja |
| 7 |lima2 is in het domein gejoined? | Ja |



##  DNSConfig

| Nr test | Wat moet er getest worden | In orde? | 
| :--- | :--- | :--- | 
 1 |Is dns+adapters goed geconfigureerd? | Ja |
| 2 |zijn de forward servers correct?  | Ja |

## AD/DNS configuratie en installatie

| Nr test | Wat moet er getest worden | In orde? | 
| :--- | :--- | :--- | 
| 1 | bravo2 is terug te vinden in de AD users en computers lijst?| Ja |
| 2 | red.local is terug te vinden in de forward lookup zone? | Ja |
| 3 | is de replicatie test met alfa 2 is successvol?| Ja |


##  DNS records tabel

| Nr test | Wat moet er getest worden | In orde? |
| :--- | :--- | :--- |
| 1 | zijn alle dns records correct?| Ja |


