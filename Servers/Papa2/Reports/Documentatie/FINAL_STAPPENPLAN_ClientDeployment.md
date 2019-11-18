Handleiding om task sequence te maken en een client te deployen:
De deployment share aanmaken (met MDT) en de boot image X86 distribueren naar de SCCM Distribution Point zijn al gebeurt in de scripts. X64 boot image moet nog aangemaakt worden.
Om een client te deployen moeten we nu juist nog de operating system image toevoegen aan SCCM, een task sequence maken, De nodige programma’s voor de clients aan SCCM toevoegen en de PXE boot uitvoeren

# Boot image en Operating system image toevoegen aan SCCM:
## Voorbereiding (Share permissions van deployment share in stellen voor MDT):
a.	Log out en log in als local admin van Papa2. 
b.	Open file explorer en ga naar \\Papa2 Doe rechtermuisknop op de “Deployment Share” folder en kies “properties”
c.	Ga naar Sharing en dan Advanced Sharing. Klik op “permissions” en geef “full control” aan everyone. 
d.	Log terug in als RED\Administrator
e.	Open powershell ISE als admin en geef volgende commands in:

                Import-Module "C:\Program Files\Microsoft Deployment Toolkit\Bin\MicrosoftDeploymentToolkit.psd1"

                ([wmiclass]"win32_share").Create("C:\DeploymentShare","DeploymentShare",0)
                $DS001 = New-PSDrive -Name "DS001" -PSProvider "MicrosoftDeploymentToolkit\MDTProvider" -Root "C:\DeploymentShare" -Description "Deployment Share voor Windows 10" -Verbose

                Import-MDTOperatingSystem -SourcePath "E:\" -Path "DS001:\Operating Systems" -DestinationFolder "Win10Consumers1809" -verbose


## Boot image:
a.	In SCCM console ga naar:
Software Library > Overview > Operating images > Boot images

b.	Doe rechtermuisknop op “boot images” en kies “Create Boot image using MDT”
c.	In het pad moet je browsen naar de directory waar de boot image wordt opgeslaan (in de deployment share) doe: 
\\Papa2\DeploymentShare\Boot

d.	Druk op next en kies “Windows10x64” als naam. Druk op next en kies x64 als platform. Andere options op default en finish de wizard.
e.	Doe rechtermuisknop op de “Windows10x64” boot image en kies properties. Ga naar de “data source” tab en vink “Deploy this boot image from PXE enabled Distribution point” aan 
f.	Doe nu rechtermuisknop op de net aangemaakte “Windows10x64” boot image en kies voor “distribute content” Kies Papa2 als distribution point en finish de wizard. (doe hetzelfde voor de x86 boot image)

## Operating system image:
a.	In de SCCM console ga naar: 
Software Library > Overview > Operating Systems > Operating systems images

b.	Doe rechtermuisknop op “Operating system images” en kies “Add operating system image”
c.	In het pad moet je browsen naar de Install.WIM die je in je deployment share vind. Op Papa2 is dit op het volgende pad:
\\Papa2\DeploymentShare\Operating Systems\Win10Consumers1809\sources\install.wim

d.	Druk op next en vul als naam Windows 10 pro en als version 1809 in. Druk op next en finish de wizard.
e.	Doe nu rechtermuisknop op de net aangemaakte “Windows 10 pro” image en kies voor “distribute content”.
f.	In de wizard klik je eerst op next en dan op “add distribution point”. Kies hier voor: Papa2.red.local. Klik terug op next en finish de wizard.

# Task sequence maken en toevoegen aan SCCM:
## Task sequence zelf:
a.	In de SCCM console ga naar: 
Software Library > Overview > Operating Systems > Task sequences

b.	Doe rechtermuisknop op “Task sequences” en kies “Create MDT task sequence”
c.	Laat template op “Client task sequence staan” en kies als task sequence naam “Windows 10 pro”.
d.	Gebruik bij “details” volgende settings en klik op next:
 
e.	Bij capture settings niks aanpassen en gewoon op next drukken.
f.	Bij boot image klik je op browse en kies je voor “Windows10x64 en-US”
g.	Bij MDT Package klik je op “Create a new MDT package” en browser naar:
\\Papa2\DeploymentShare\Packages\MDT
Klik hierna op next. (En kies als name “MDT”)

h.	Bij OS image ook klikken op “browse for existing… “ en kiezen voor “Windows 10 Home 1809 nl-NL”. Klik op next en kies voor “Windows 10 PRO”.
i.	Deployment method laat je op default staan. (no user interaction)
j.	Bij client package klik je op “browse for existing…” en kies je voor Microsoft Corporation Configuration Manager Client Package. Klik hierna op next.
k.	Bij USMT package klik je op “browse for existing…” en kies je voor Microsoft Corporation User State Migration Tool for Windows 10. Klik hierna op next.
l.	Bij Settings Package klik je op “Create a new Settings package” en browser naar:
\\Papa2\DeploymentShare\Settings
Klik hierna op next. (En kies als name “Windows 10 x64 Settings”)

m.	Bij SysPrep gewoon op next drukken. En bevestig je instellingen.
n.	De task sequence is nu correct aangemaakt.
o.	Tenslotte moeten we in SCCM console nog naar:
Software Library > Overview > Application Management > Packages
Gaan en de “MDT”, “User State migration tool” en “Windows 10 x64 Settings” packages distribueren naar de distribution point (Zelfde werkwijze als bij het toevoegen van de Operating System Image in het vorige deel)

# Applications (Java, Adobe Flash Player en LibreOffice) toevoegen aan SCCM:
## Java:
a.	In de Virtualbox Shared folder vind je de 3 MSI’s voor Java, Adobe Flash Player en Libreoffice in:
Papa2\BenodigdeFiles\Windows10Software\
Kopieer deze indien nodig naar de deploymentshare!

b.	In SCCM console ga naar: Software Library > Overview > Application Management > Applications. En doe “create application”
c.	Zorg ervoor dat “MSI” file is aangeduid en browse naar:
\\Papa2\DeploymentShare\Applications\JavaMSIfile

d.	Op de “general information” page moet je bij installation program volgende command ingeven:
msiexec /i "jre1.8.0_23164.msi" JU=0 JAVAUPDATE=0 AUTOUPDATECHECK=0 RebootYesNo=No WEB_JAVA=1 /q

e.	Klik twee keer op next en sluit daarna de application wizard. Doe nu rechtermuisknop op de aangemaakte “Java” application en doe properties.
f.	Vink “Allow this application to be installed from the install application task sequence action without being deployed” aan.
g.	Tenslotte moet je terug rechtermuisknop doen op de “Java” application en “Distribute content” kiezen. Deze applicatie is nu klaar om in de task sequence te komen.

## Adobe Flash Player:
a.	In SCCM console ga naar: Software Library > Overview > Application Management > Applications. En doe “create application”
b.	Zorg ervoor dat “MSI” file is aangeduid en browse naar:
\\Papa2\DeploymentShare\Applications\install_flash_player_32_active_x

c.	Op de “general information” page moet je bij installation program volgende command ingeven:
msiexec /i "install_flash_player_32_active_x.msi" /q
Klik twee keer op next en sluit daarna de application wizard. Doe nu rechtermuisknop op de aangemaakte “Flash Player” application en doe properties.

d.	Vink “Allow this application to be installed from the install application task sequence action without being deployed” aan.
e.	Tenslotte moet je terug rechtermuisknop doen op de “Flash Player” application en “Distribute content” kiezen. Deze applicatie is nu klaar om in de task sequence te komen.

## LibreOffice:
a.	In SCCM console ga naar: Software Library > Overview > Application Management > Applications. En doe “create application”
b.	Zorg ervoor dat “MSI” file is aangeduid en browse naar:
\\Papa2\DeploymentShare\Applications\LibreOffice_6.2.8_Win_x64

c.	Op de “general information” page moet je bij installation program volgende command ingeven:
msiexec /i "LibreOffice_6.2.8_Win_x64.msi" /qn /norestart ALLUSERS=1 ISCHECKFORPRODUCTUPDATES=0 UI_LANGS=en_US /l “C:\Scriptlogs\libreOffice.txt”

d.	Klik twee keer op next en sluit daarna de application wizard. Doe nu rechtermuisknop op de aangemaakte “Libre Office” application en doe properties.
e.	Vink “Allow this application to be installed from the install application task sequence action without being deployed” aan.
f.	Tenslotte moet je terug rechtermuisknop doen op de “Libre Office” application en “Distribute content” kiezen. Deze applicatie is nu klaar om in de task sequence te komen.

## Task sequence aanpassen en applicaties eraan toevoegen:
a.	In de SCCM console ga naar: 
Software Library > Overview > Operating Systems > Task sequences

b.	Doe rechtermuisknop op de task sequence die we in het vorige stuk gemaakt hebben en kies voor “edit”.
c.	In de “post install” section klik op “Apply network settings” en vul bij domain OU het volgende in (dit zal de client in de clients OU plaatsen):
LDAP://CN=Computers,DC=red,DC=local

d.	Vervolgens gaan we de drie applicaties toevoegen aan de task sequence. Ga naar de “State restore” section en ga naar “Install Application”.
e.	Vink ‘Install the following applications” aan en voeg de drie applications toe (je zal er maar 3 zien in de lijst aangezien we deze allemaal al geïmporteerd hebben in SCCM). Java dan Flash Player dan LibreOffice.
f.	Voeg net voor de “install software” step een nieuwe step toe (vanboven op add klikken) en kies general > restart computer
g.	Druk op apply en save de task sequence. 
h.	Browse nu met file explorer naar:
C:\DeploymentShare\Settings en open “CustomSettings.ini” met kladblok.

i.	Zet volgende variables in de CustomSettings.ini file en save het bestand: 

                [Settings]
                Priority=Default
                Properties=MyCustomProperty

                [Default]
                OSInstall=Y
                OSDComputerName=Client1
                SkipAppsOnUpgrade=YES
                SkipComputerName=YES
                SkipDomainMembership=YES
                SkipUserData=YES
                UserDataLocation=Auto
                SkipLocaleSelection=YES
                SkipTaskSequence=NO
                MachineObjectOU=CN=Computers,DC=red,dc=local
                DeploymentType=NEWCOMPUTER
                SkipTimeZone=YES
                SkipApplications=NO
                SkipBitLocker=YES
                SkipSummary=YES
                SkipBDDWelcome=YES
                SkipCapture=YES
                DoCapture=NO
                SkipFinalSummary=NO
                TimeZone105
                TimeZoneName=Romance Standard Time
                JoinDomain=RED
                DomainAdmin=Administrator
                DomainAdminDomain=RED
                DomainAdminPassword=Admin2019
                SkipAdminPassword=YES
                SkipProductKey=YES

j.	In SCCM console ga naar:
\Software Library\Overview\Application Management\Packages

k.	De volgende acties moet je op de MDT, “Windows 10 x64 settings” en de “User State Migration Tool for Windows” uitvoeren:
a.	Doe rechtermuisknop en kies properties. Ga naar de “Data access” tab
b.	Vink “Copy the content in this package to a package share on distribution points” aan!. Klik op “ok. 
c.	Terug rechtermuisknop op alle drie de packages en kies “update distribution points”
l.	In SCCM console ga naar: 
\Software Library\Overview\Operating Systems\Task Sequences\
Doe rechtermuisknop op “Windows 10 PRO” en kies voor “Deploy”. 
m.	Klik bij collection op browse en kies “All unknown computers”
n.	Op het volgende scherm verander je enkel de “make available to the following” setting naar “Only media and PXE”.
o.	Scheduling, user experience, alerts en distribution point settings op default laten. Finish de wizard

# Windows Cliënt
## Handleiding:
1.	VM aanmaken:
De eerste stap is een nieuwe virtuele machine aanmaken in Virtualbox met volgende specificaties:

o	Name: WIN-CLT1
o	Windows 10 (64-bit)
o	2048mb RAM
o	1 hard drive (50gb)
o	Netwerkadapters:
  1 = LAN
o	In Virtualbox in je nieuwe client VM ga naar system > motherboard > boot order en stel hard disk als eerste in en network als tweede.


2.	Windows 10 deployment:
a.	Start de VM in Virtualbox
b.	Druk op F12 wanneer erom gevraagd wordt
c.	In het eerste venster van de task sequence wizard druk op next en selecteer “Windows 10 PRO”
d.	Laat de deployment lopen (alles gebeurt automatisch)
e.	Wanneer de deployment klaar is meld je op de client aan als BLANCQUAERT\Administrator (Het scherm zal 10-15min op “welkom” blijven staan)

