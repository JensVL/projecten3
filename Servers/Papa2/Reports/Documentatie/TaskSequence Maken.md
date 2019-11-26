# Stappenplan voor het aanmaken van een Task Sequence in SCCM.

# 1. Prerequisites

## 1.1 MDT integreren in SCCM
    Door MDT te integreren in SCCM kan je je Task Sequence veel meer personaliseren.
    Ook zorgt dit ervoor dat de nood aan scripting verminderd, je toegang hebt tot alle MDT variabelen, MDT databases, toolkit en customsettings.ini. Op deze manier maak je het dus eenvoudiger om een Task Sequence aan te maken met specifieke vereisten, zonder deze via scripts te moeten uitvoeren.

    1. Zoek in "START" "Configure ConfigMgr Integration" op en Start dit programma.
    2. NEXT -> FINISH
 
## 1.2 Aanmaken van de nodige netwerklocaties
    De Task Sequence Wizard gebruikt enkel bestandlocaties op een netwerkpad, en niet op een lokaal pad.
#### Maak op de C schijf een Map "TSReq" aan, rechtermuisklik hierop, ga dan naar properties, ga naar de tab "Share", en klik op "Share" 
# SPECIFIEKER BESCHRIJVEN ^^
TE MAKEN UNC FOLDERS (Maak deze in de gedeelde folder "TSReq"):  
1. "MDT Toolkit Package": LEEG  
2. "MDT Settings Package": LEEG  
3. "installImage": MET "install.wim"
4. "Applicaties": MET:  
    - Acrobat Reader msi  
	- Flash Player msi  
	- Java (jre) msi  
	- LibreOffice msi  

## 1.3 install.wim toevoegen in SCCM
#### In Configuration Manager Console:  
1. Right-Click "Operating System Images" -> "Add O S Image"
2. Navigeer naar de "UNC map\install.wim" SELECTEER "install.wim" -> NEXT
3. TAB General: NEXT
4. TAB Summary: NEXT

# 2. Aanmaken van de Task Sequence

1. In "Software Library"
    - ga naar"Operating Systems"  
    - right-click "Task Sequences"  
    - SELECTEER "Create MDT Task Sequence"  
2. SELECTEER "Client Task Sequence"  
    - Next
3. Geef NAAM  
    - Next (=Tab "Details")
4. Selecteer "Join a Domain"  
    - vul "red.local" in bij Domain
5. Set Account:  
    - User Name="red\SCCM_DJ"  
    - Password="Admin2019"  
    - confirm  
    - OK
6. Windows Settings:  
    - User Name="RED IT"  
    - Org. Name="HoGent"
7. Administrator Account:  
    - SELECTEER "ENABLE"  
    - Password="Admin2019"  
    - Confirm  
    - NEXT
8. Capture Settings:  
    - DEFAULT= NEVER  
    - NEXT
9. Specify Existing Boot Image:  
    - Browse naar "...x64"  
    - OK  
    - NEXT
10. MDT Package:
	- Maak UNC(gedeelde map op netwerk) met full permission: "MDT Toolkit Package"
# CONTROLEER OF DEZE STAP NODIG IS ^^
	- Geef pad op naar de UNC Map bv "\\DC3\MDT Toolkit Package"
	- NEXT
11. MDT Details:
	- Name="MDT Toolkit Package"
	- NEXT
12. OS IMAGE:
	- Specify an Existing OS image: SELECTEER "Windows 10 Enterprise Evaluation"
	- NEXT
13. DEPLOYMENT METHOD:
	- SELECTEER "Perform a USER DRIVEN Installation"
	- NEXT
14. CLIENT PACKAGE:
	- SPECIFY -> Browse -> "Micr. Corp. Config. Man. Client Pack." -> OK
	- NEXT
15. USMT PACKAGE:
	- SPECIFY -> Browse -> "Micr. Corp. User State Migr. Tool for Windows 10.0....." -> OK
	- NEXT
16. SETTINGS PACKAGE:
	- SELECTEER "Create new settings Package"
	- VUL UNC PAD IN bv: "\\DC3\MDT Settings Package"
	- NEXT
17. SETTINGS DETAILS:
	- NAME="MDT Settings Package"
	- NEXT
18. SYSPREP PACKAGE:
	- No Sysprep Package is Required
	- NEXT
19. SUMMARY:
	- NEXT
	- WACHTEN
	- FINISH
