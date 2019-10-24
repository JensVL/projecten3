Write-host "Installatie Exchange Server Script 2" -ForeGroundColor "Red"

# VARIABELEN
$VBOXdrive = "\\VBOXSVR\scripts"

# LOG SCRIPT TO FILE (+ op het einde van het script Stop-Transcript doen):
Start-Transcript "C:\ScriptLogs\2_JoinDomainlog.txt"

# Idem aan het 1_RenameServer.ps1 script zal deze registry instelling ervoor zorgen dat ons volgende script automatisch wordt geladen
# RunOnce verwijderd deze instelling automatisch nadat het script klaar is met runnen
Write-host "Volgend script inladen in register" -ForeGroundColor "Green"
Set-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce' -Name ResumeScript `
                -Value "C:\Windows\system32\WindowsPowerShell\v1.0\Powershell.exe -executionpolicy bypass -file `"$VBOXdrive\3_InstallatieSoftware.ps1`""

Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name DefaultUserName -Value "red.local\Administrator"

#Charlie2 toevoegen aan domein red.local
Write-host "Charlie2 toevoegen aan domein red.local" -ForeGroundColor "Green"
Add-Computer -ComputerName 'Charlie2' -DomainName 'red.local'-Credential red.local\Administrator

Stop-Transcript

Restart-Computer