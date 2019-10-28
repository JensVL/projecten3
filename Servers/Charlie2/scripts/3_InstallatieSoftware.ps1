Write-host "Installatie Exchange Server Script 3" -ForeGroundColor "Red"

# VARIABELEN
$VBOXdrive = "Z:"

# LOG SCRIPT TO FILE (+ op het einde van het script Stop-Transcript doen):
Start-Transcript "C:\ScriptLogs\3_InstallatieSoftwarelog.txt"

# Idem aan het 1_RenameServer.ps1 script zal deze registry instelling ervoor zorgen dat ons volgende script automatisch wordt geladen
# RunOnce verwijderd deze instelling automatisch nadat het script klaar is met runnen
Write-host "Volgend script inladen in register" -ForeGroundColor "Green"
Set-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce' -Name ResumeScript `
                -Value "C:\Windows\system32\WindowsPowerShell\v1.0\Powershell.exe -executionpolicy bypass -file `"$VBOXdrive\4_InstallatieExchangeServer.ps1`""

#Chocolatey installeren
Write-host "Chocolatey installeren" -ForeGroundColor "Green"
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
#autoconfirm chocolatey
choco feature enable -n=allowGlobalConfirmation
#.NET 4.7.2 installeren
Write-host ".NET 4.7.2 installeren via Chocolatey" -ForeGroundColor "Green"
choco install dotnet4.7.2
#Visual C++ Redistributable Packages for Visual Studio installeren
Write-host "Visual C++ Redistributable Packages for Visual Studio installeren via Chocolatey" -ForeGroundColor "Green"
choco install vcredist2013
#ucma installeren
Write-host "UCMA/Microsoft Unified Communications Managed API 4.0 installeren via Chocolatey" -ForeGroundColor "Green"
choco install ucma4

Stop-Transcript

Restart-Computer