Write-host "Installatie Exchange Server Script 1 ESXI" -ForeGroundColor "Red"
# VARIABELEN
$VBOXdrive = "Z:"

# PREFERENCE VARIABLES: (Om Debug,Verbose en informaation info in de Start-Transcript log files te zien)
$DebugPreference = "Continue"
$VerbosePreference = "Continue"
$InformationPreference = "Continue"

# LOG SCRIPT TO FILE (+ op het einde van het script Stop-Transcript doen):
Start-Transcript "C:\ScriptLogs\1_RenameServerlogESXI.txt"

# = Shared folder met scripts en andere nodige files in die nodig zijn om de alfa2 server correct te provisionen
# De root van $VBOXdrive = "p3ops-1920-red\Servers\Charlie2\scripts" op Github

# 1) Sla huidige username/password op als credentials en voeg de nodige properties aan de registry toe
# om de server de mogelijkheid te geven een reboot te doen en daarna verder te gaan door het script:

# Voeg het script toe als registry value:
# RunOnce verwijderd deze instelling automatisch nadat het script klaar is met runnen
Write-host "Server voorbereiden om script automatisch te runnen na herstart" -ForeGroundColor "Green"
Set-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce' -Name ResumeScript `
                -Value "C:\Windows\system32\WindowsPowerShell\v1.0\Powershell.exe -executionpolicy bypass -file `"$VBOXdrive\2_JoinDomain.ps1`""

# 1.2) Verzamel de huidige credentials in een credentials object voor de auto-reboot:
# Zal een popup window openen waarin je je passwoord moet invullen
$CurrentCredentials = Get-Credential -UserName $env:USERNAME -Message "Credentials required for auto login"
$Username = $CurrentCredentials.GetNetworkCredential().UserName
$Password = $CurrentCredentials.GetNetworkCredential().Password

# 1.3) Registry waardes voor username/password en autologin instellen:
# Deze zorgen ervoor dat het inloggen automatisch gebeurd met de credentials die in het vorige commando verzameld zijn.
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name DefaultUserName -Value $Username
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name DefaultPassword -Value $Password
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name AutoAdminLogon -Value 1
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name ForceAutoLogon -Value 1

#Netwerkadapters hernoemen
Write-host "Naam netwerkadapters wijzigen" -ForeGroundColor "Green"
Get-NetAdapter -Name "Ethernet0" | Rename-NetAdapter -NewName "LAN"
Get-NetAdapter -Name "Ethernet1" | Rename-NetAdapter -NewName "Internet"
#ip adres instellen (nog bekijken)
Write-host "ip adres LAN instellen" -ForeGroundColor "Green"
New-NetIPAddress -InterfaceAlias "LAN" -IPAddress "172.18.1.68" -PrefixLength 27
#AD als DNS instellen
Write-host "DNS adres LAN instellen" -ForeGroundColor "Green"
Set-DnsClientServerAddress -InterfaceAlias "LAN" -ServerAddress "172.18.1.66"
#firewall uitzetten
Write-host "Firewall uitzetten" -ForeGroundColor "Green"
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False
#naam instellen
Write-host "Servernaam wijzigen naar Charlie2" -ForeGroundColor "Green"
Rename-Computer -NewName Charlie2 -Force

Stop-Transcript

Restart-Computer