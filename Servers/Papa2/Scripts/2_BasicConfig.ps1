# Installatiescript dat de initiële configuratie doet en de server een member server maakt van ons domein
# Elke stap wordt uitgelegd met zijn eigen comment

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
Set-Culture -CultureInfo eng-BE
set-timezone -Name "Romance Standard Time"

# 2) Hernoem de netwerkadapter LAN = de adapter met static IP instellingen die alle servers met elkaar verbind.
Write-host "Changing NIC adapter names:" -ForeGroundColor "Green"
Get-NetAdapter -Name "Ethernet" | Rename-NetAdapter -NewName "LAN"

# 3) Geef de LAN adapter de correcte IP instellingen volgens de opdracht:
# Prefixlength = CIDR notatie van subnet (in ons geval 255.255.255.0)
# Default gateway option stelt deze in op het static IP van WIN-DC1 (zo gaat het internet via WIN-DC1)
Write-host "Setting correct ipv4 adapter settings (including DNS and Default gateway):" -ForeGroundColor "Green"
New-NetIPAddress -InterfaceAlias "LAN" -IPAddress "192.168.100.30" -PrefixLength 24 -DefaultGateway "192.168.100.10"

# Beide DNS servers van de LAN NIC worden ook ingesteld op de ip van WIN-DC1 met volgend commando:
Set-DnsClientServerAddress -InterfaceAlias LAN -ServerAddresses ("192.168.100.10","192.168.100.10")

# 4) Idem aan het RUNFIRST.ps1 script zal deze registry instelling ervoor zorgen dat ons volgende script automatisch wordt geladen
# Want het joinen van een domein herstart automatisch onze server
# RunOnce verwijderd deze instelling automatisch nadat het script klaar is met runnen
Set-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce' -Name ResumeScript `
                -Value 'C:\Windows\system32\WindowsPowerShell\v1.0\Powershell.exe -executionpolicy bypass -file "Z:\3InstallSQLServer.ps1"'

# 6) Voeg de WIN-DC1 server toe aan het nieuwe domain: blancquaert.periode1
# 6.1) Maak een CredentialsOBject aan voor de user om zijn DSRM password te vragen (Admin 2019)
# Zal een popup window openen waarin je je passwoord moet invullen dit passwoord wordt dan in het commando in stap 7 gebruikt
$CurrentCredentials = Get-Credential -UserName "BLANCQUAERT\Administrator" -Message "Geef je gewenste DSRM passwoord in"
$Username = "BLANCQUAERT\SCCMadmin"
$Password = $CurrentCredentials.GetNetworkCredential().Password

# 6.2) Registry waardes voor username/password en autologin instellen:
# Deze zorgen ervoor dat het inloggen automatisch gebeurd met de credentials die in het vorige commando verzameld zijn.
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name DefaultUserName -Value $Username
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name DefaultPassword -Value $Password
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name AutoAdminLogon -Value 1
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name ForceAutoLogon -Value 1

# 7) SQLSCCMSERVER toevoegen aan het bestaande domein als member server:
Write-Host "Joining blancquaert.periode1 domain as a member server:" -ForeGroundColor "Green"
Add-Computer -domainName "blancquaert.periode1" `
             -credential $CurrentCredentials `
             -force:$true `
             -restart

Stop-Transcript
