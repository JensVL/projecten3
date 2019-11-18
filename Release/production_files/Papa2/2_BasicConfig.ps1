# Installatiescript dat de initiële configuratie doet en de server een member server maakt van ons domein
# Elke stap wordt uitgelegd met zijn eigen comment

# VARIABLES:
# --------------------------------------------------------------------------------------------------------
# VOOR INTEGRATIE:
$VBOXdrive = "C:\Scripts_ESXI\Papa2"

# VOOR VIRTUALBOX TESTING:
#$VBOXdrive = "Z:"
# --------------------------------------------------------------------------------------------------------

################################################################################################################## NOTE
# ECHTE IP VOOR INTEGRATIE DEMO:
$IpAddress = "172.18.1.6"
$DefaultGateway = "172.18.1.7"
$CIDR = "26"

# TEST IP VOOR VIRTUALBOX TESTING:
#$IpAddress = "172.18.1.67"
#$DefaultGateway = "172.18.1.65"
#$CIDR = "27"
################################################################################################################## NOTE

$Land = "eng-BE"
$AdapterNaam = "LAN"

$Username = "RED\Administrator" # LET OP: ZAL SCCM INSTALLEREN EN ALLE RECHTEN EROP HEBBEN !
$Password = "Admin2019" | ConvertTo-SecureString -AsPlainText -Force

# PREFERENCE VARIABLES: (Om Debug,Verbose en informaation info in de Start-Transcript log files te zien)
$DebugPreference = "Continue"
$VerbosePreference = "Continue"
$InformationPreference = "Continue"

# LOG SCRIPT TO FILE (+ op het einde van het script Stop-Transcript doen):
Start-Transcript "C:\Scriptlogs\2_BasicConfig_LOG.txt"

# Start-Sleep zal 10 seconden wachten voor hij aan het eerste commando van dit script begint
# om zeker te zijn dat de server klaar is met het starten van zijn services na de reboot
Write-host "Waiting 10 seconds before executing script" -ForeGroundColor "Green"
start-sleep -s 10
Write-host "Starting script now:" -ForeGroundColor "Green"

# 1) Stel Datum/tijd correct in:
# Romance standard time = Brusselse tijd
# Eerste commando zal tijd naar 24uur formaat instellen (eng zorgt dat taal op engels blijft maar regio komt op BE)
Write-host "Setting correct timezone and time format settings:" -ForeGroundColor "Green"
Set-Culture -CultureInfo $Land
set-timezone -Name "Romance Standard Time"

# 2) Hernoem de netwerkadapter LAN = de adapter met static IP instellingen die alle servers met elkaar verbind.
Write-host "Changing NIC adapter names:" -ForeGroundColor "Green"
Get-NetAdapter -Name "Ethernet" | Rename-NetAdapter -NewName "$AdapterNaam"

# 3) Geef de LAN adapter de correcte IP instellingen volgens de opdracht:
# Prefixlength = CIDR notatie van subnet (in ons geval 255.255.255.192)
# Default gateway option stelt deze in op de Layer 3 switch van VLAN 300
Write-host "Setting correct ipv4 adapter settings (including DNS and Default gateway):" -ForeGroundColor "Green"
New-NetIPAddress -InterfaceAlias "$AdapterNaam" -IPAddress "$IpAddress" -PrefixLength $CIDR -DefaultGateway "$DefaultGateway"

# Beide DNS servers van de NIC worden ook ingesteld op de ip van Hogent DNS servers met volgend commando:
Set-DnsClientServerAddress -InterfaceAlias LAN -ServerAddresses ("172.18.1.66","172.18.1.67")

# 4) Idem aan het 1_RUNFIRST.ps1 script zal deze registry instelling ervoor zorgen dat ons volgende script automatisch wordt geladen
# Want het joinen van een domein herstart automatisch onze server
# RunOnce verwijderd deze instelling automatisch nadat het script klaar is met runnen

# 6) Voeg de Papa2 server toe aan het domain: red.local
# 6.1) Maak een CredentialsObject aan met username SCCMAdmin en password Admin2019
$SCCMcredentials = New-Object System.Management.Automation.PSCredential($Username,$Password)

Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name DefaultUserName -Value $Username
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name DefaultPassword -Value "Admin2019"

# 6.2) Voeg het volgende script toe als registry value:
# RunOnce verwijderd deze instelling automatisch nadat het script klaar is met runnen
Set-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce' -Name ResumeScript `
         -Value "C:\Windows\system32\WindowsPowerShell\v1.0\Powershell.exe -executionpolicy bypass -file `"$VBOXdrive\3_SCCMPrereqInstall.ps1`""


# 7) Papa2 toevoegen aan het bestaande domein als member server:
Write-Host "Joining RED.local domain as a member server:" -ForeGroundColor "Green"
Add-Computer -DomainName "red.local" `
             -Credential $SCCMcredentials `
             -Force:$true `
             -Restart

Stop-Transcript
