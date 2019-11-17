# Initialisatiescript dat eerst moet worden uitgevoerd. Dit script zal de servernaam wijzigen, het configuratiescript als runOnce value
# toevoegen in de registry en de computer rebooten.
# Elke stap wordt uitgelegd met zijn eigen comment


# VARIABLES:
# --------------------------------------------------------------------------------------------------------
# VOOR INTEGRATIE:
$VBOXdrive = "C:\Scripts_ESXI\Alfa2"

# VOOR VIRTUALBOX TESTING:
#$VBOXdrive = "Z:"
# --------------------------------------------------------------------------------------------------------
$username = "Administrator"
$password = "Admin2019"

# PREFERENCE VARIABLES: (Om Debug,Verbose en informaation info in de Start-Transcript log files te zien)
$DebugPreference = "Continue"
$VerbosePreference = "Continue"
$InformationPreference = "Continue"

# LOG SCRIPT TO FILE (+ op het einde van het script Stop-Transcript doen):
 Start-Transcript "C:\ScriptLogs\1_RUNFIRSTlog.txt"

# 1) Sla huidige username/password op als credentials en voeg de nodige properties aan de registry toe
# om de server de mogelijkheid te geven een reboot te doen en daarna verder te gaan door het script:

# 1.1) Voeg het script toe als registry value:
# RunOnce verwijderd deze instelling automatisch nadat het script klaar is met runnen
Set-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce' -Name ResumeScript `
                -Value "C:\Windows\system32\WindowsPowerShell\v1.0\Powershell.exe -executionpolicy bypass -file `"$VBOXdrive\2_installDCDNS.ps1`""

# 1.2) Registry waardes voor username/password en autologin instellen:
# Deze zorgen ervoor dat het inloggen automatisch gebeurd met de credentials die in het vorige commando verzameld zijn.
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name DefaultUserName -Value $Username
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name DefaultPassword -Value $Password
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name ForceAutoLogon -Value 1
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name AutoAdminLogon -Value 1

# 2) Rename de DC van zijn default naam naar alfa2:
# -Force zal confirmation dialog boxes negeren
Rename-Computer -NewName Alfa2 -Force

Stop-Transcript

Restart-Computer
