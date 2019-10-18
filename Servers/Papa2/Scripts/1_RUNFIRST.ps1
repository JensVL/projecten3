# Initialisatiescript dat eerst moet worden uitgevoerd. Dit script zal Papa2 zijn servernaam wijzigen, het configuratiescript als runOnce value
# toevoegen in de registry en de computer rebooten.
# Elke stap wordt uitgelegd met zijn eigen comment

############################################## BELANGRIJK #####################################################################################
# VOER DIT SCRIPT UIT ALS ADMINISTRATOR!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
############################################## BELANGRIJK #####################################################################################

# PREFERENCE VARIABLES: (Om Debug,Verbose en informaation info in de Start-Transcript log files te zien)
$DebugPreference = "Continue"
$VerbosePreference = "Continue"
$InformationPreference = "Continue"

# LOG SCRIPT TO FILE (+ op het einde van het script Stop-Transcript doen):
Start-Transcript "C:\Scriptlogs\1_RUNFIRST_LOG.txt"

# 1) Sla huidige username/password op als credentials en voeg de nodige properties aan de registry toe
# om de server de mogelijkheid te geven een reboot te doen en daarna verder te gaan door het script:

# 1.1) Voeg het script toe als registry value:
# RunOnce verwijderd deze instelling automatisch nadat het script klaar is met runnen
Set-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce' -Name ResumeScript `
         -Value 'C:\Windows\system32\WindowsPowerShell\v1.0\Powershell.exe -executionpolicy bypass -file "Z:\BenodigdeFiles\2_BasicConfig.ps1"'

# 1.2) Verzamel de huidige credentials in een credentials object voor de auto-reboot (aanmalden als domain admin):
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

# 2) Rename de DC van zijn default naam naar Papa2:
# -Force zal confirmation dialog boxes negeren
Rename-Computer -NewName Papa2 -Force
Stop-Transcript
Restart-Computer
