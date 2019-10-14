# Installatiescript dat de initiële configuratie doet en de ADDS role installeert:
# Elke stap wordt uitgelegd met zijn eigen comment

# VARIABLES:
$VBOXdrive = "Z:"
$Land = "eng-BE"
$IpAddress = "172.18.1.67"
$CIDR = "27"
$AdapterNaam = "LAN"

# PREFERENCE VARIABLES: (Om Debug,Verbose en informaation info in de Start-Transcript log files te zien)
$DebugPreference = "Continue"
$VerbosePreference = "Continue"
$InformationPreference = "Continue"

# LOG SCRIPT TO FILE (+ op het einde van het script Stop-Transcript doen):
Start-Transcript "C:\ScriptLogs\2_InstallDCDNSlog.txt"

# Start-Sleep zal 10 seconden wachten voor hij aan het eerste commando van dit script begint
# om zeker te zijn dat de server klaar is met het starten van zijn services na de reboot
Write-host "Waiting 15 seconds before executing script" -ForeGroundColor "Green"
start-sleep -s 15
Write-host "Starting script now:" -ForeGroundColor "Green"

# 1) Stel Datum/tijd correct in:
# Romance standard time = Brusselse tijd
# Eerste commando zal tijd naar 24uur formaat instellen (eng zorgt dat taal op engels blijft maar regio komt op BE)
Write-host "Setting correct timezone and time format settings:" -ForeGroundColor "Green"
Set-Culture -CultureInfo $Land
set-timezone -Name "Romance Standard Time"

###################################################################################################### ENKEL VOOR VIRTUALBOX LAB TESTING DEMO HEEFT 1 NIC (LAN)
# 2) Hernoem de netwerkadapters. NAT = de adapter die met het internet verbind
# LAN = de adapter met static IP instellingen die alle servers met elkaar verbind.
Write-host "Changing NIC adapter names:" -ForeGroundColor "Green"
# TODO:                                                                                                                      TODO: Vervang door:
Get-NetAdapter -Name "Ethernet" | Rename-NetAdapter -NewName $AdapterNaam
#Get-NetAdapter -Name "Ethernet" | Rename-NetAdapter -NewName NAT
#Get-NetAdapter -Name "Ethernet 2" | Rename-NetAdapter -NewName $AdapterNaam
###################################################################################################### ENKEL VOOR VIRTUALBOX LAB TESTING DEMO HEEFT 1 NIC (LAN)

#                                                                          ############################# TODO: SWITCH IP ADRES INSTELLEN ALS Def. Gateway
# 3) Geef de LAN adapter de correcte IP instellingen volgens de opdracht:
# Prefixlength = CIDR notatie van subnet (in ons geval 255.255.255.224)
Write-host "Setting correct ipv4 settings:" -ForeGroundColor "Green"
New-NetIPAddress -InterfaceAlias "$AdapterNaam" -IPAddress "$IpAddress" -PrefixLength $CIDR -DefaultGateWay "172.18.1.98"

# 4) DNS van LAN van Alfa2 instellen op Hogent DNS servers:
# Eventueel commenten tijdens testen in demo omgeving
Set-DnsClientServerAddress -InterfaceAlias "$AdapterNaam" -ServerAddress "172.18.1.66","$IpAddress"

# 4) Installeer de Active Directory Domain Services role om van de server een DC te kunnen maken:
Write-host "Starting installation of ADDS role:" -ForeGroundColor "Green"
Install-WindowsFeature AD-domain-services -IncludeManagementTools
import-module ADDSDeployment

# 5) Idem aan het 1_RUNFIRST.ps1 script zal deze registry instelling ervoor zorgen dat ons volgende script automatisch wordt geladen
# Want het installeren van de ADDS role herstart automatisch onze server
# RunOnce verwijderd deze instelling automatisch nadat het script klaar is met runnen
Set-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce' -Name ResumeScript `
                -Value "C:\Windows\system32\WindowsPowerShell\v1.0\Powershell.exe -executionpolicy bypass -file `"$VBOXdrive\3_ConfigDCDNS.ps1`""

# 6) Voeg de Alfa2 server toe aan het nieuwe domain: red.local
# 6.1) Maak een CredentialsOBject aan voor de user om zijn DSRM password te vragen (Admin2019)
# Zal een popup window openen waarin je je passwoord moet invullen dit passwoord wordt dan in het commando in stap 7 gebruikt
$CurrentCredentials = Get-Credential -UserName "RED\$env:USERNAME" -Message "Geef je gewenste DSRM passwoord in"
$DSRM = $CurrentCredentials.Password

# 6.2) Vanaf dat ik met red/administrator was ingelogd had ik het probleem dat ik geen permissie had om de netwerkadapters te wijzigen.
# De oplossing hiervoor is in gpedit.msc "User Account Control: Admin approval mode for the builtin Administrator account" te ENABLEN
# Dit doe je in powershell met volgende command die de juiste registry instelling zal wijzigen:
# De eerste command zorgt ervoor dat je je als admin niet steeds moet inloggen wanneer je wijzigingen wil doen:
set-itemproperty -Path "REGISTRY::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System" `
                -name "ConsentPromptBehaviorAdmin" -value 0
Set-ItemProperty -Path "REGISTRY::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System" `
                -Name "FilterAdministratorToken" -value 1

# 7) Aanmaken van ons nieuw domain:
#     Forestmode/DomainMode => 7 is = Windows Server 2016 (de oudste Windows Server versie in onze opstelling)
#     DNS role laten aanmaken en DNSdelegation uitzetten om later onze eigen DNS server in te stellen
#     Force forceert negeren van bevestigingen
Write-host "Starting configuration of red.local domain:" -ForeGroundColor "Green"
install-ADDSDomainController -DomainName "red.local" `
                  -ReplicationSourceDC "Alfa2.red.local" `
                  -credential $CurrentCredentials `
                  -installDns `
                  -createDNSDelegation:$false `
                  -SafeModeAdministratorPassword $DSRM `
                  -force:$true


Stop-Transcript
