# Testrapport bravo2: backup domeincontroller

Auteur(s) testrapport: 

## 1_RUNFIRST script

| Nr test | Wat moet er getest worden | In orde? |
| :--- | :--- | :--- |
| 1 | De computername is bravo2 | Ja/Nee |
| 2 |Is de gebruiker red/administrator? | Ja/Nee |


## DNSInstall

| Nr test | Wat moet er getest worden | In orde? |
| :--- | :--- | :--- |
| 1 |past het script de tijdzone correct aan? | Ja/Nee |
| 2 |de adapternaam wordt gewijzigd? | Ja/Nee |
| 3 |de netwerk instellingen kloppen? | Ja/Nee |
| 4 |dns is correct ingesteld? | Ja/Nee |
| 5 |de firewall staat "off" | Ja/Nee |
| 6 |er wordt aangemeld met admin en dns is geinstalleerd | Ja/Nee |
| 7 |lima2 is in het domein gejoined? | Ja/Nee |



##  DNSConfig

| Nr test | Wat moet er getest worden | In orde? | 
| :--- | :--- | :--- | 
 1 |Is dns+adapters goed geconfigureerd? | Ja/Nee |
| 2 |zijn de forward servers correct?  | Ja/Nee |

## AD/DNS configuratie en installatie

| Nr test | Wat moet er getest worden | In orde? | 
| :--- | :--- | :--- | 
| 1 | bravo2 is terug te vinden in de AD users en computers lijst?| Ja/Nee |
| 2 | red.local is terug te vinden in de forward lookup zone? | Ja/Nee |
| 3 | is de replicatie test met alfa 2 is successvol?| Ja/Nee |


##  DNS records tabel

| Nr test | Wat moet er getest worden | In orde? |
| :--- | :--- | :--- |
| 1 | zijn alle dns records correct?| Ja/Nee |
