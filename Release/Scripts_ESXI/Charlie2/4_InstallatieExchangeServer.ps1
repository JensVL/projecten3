Write-host "Installatie Exchange Server Script 4" -ForeGroundColor "Red"

# VARIABELEN
$VBOXdrive = "C:\Scripts_ESXI\Charlie2"

# LOG SCRIPT TO FILE (+ op het einde van het script Stop-Transcript doen):
Start-Transcript "C:\ScriptLogs\4_InstallatieExchangeServer.txt"

# Idem aan het 1_RenameServer.ps1 script zal deze registry instelling ervoor zorgen dat ons volgende script automatisch wordt geladen
# RunOnce verwijderd deze instelling automatisch nadat het script klaar is met runnen
Write-host "Volgend script inladen in register" -ForeGroundColor "Green"
Set-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce' -Name ResumeScript `
                -Value "C:\Windows\system32\WindowsPowerShell\v1.0\Powershell.exe -executionpolicy bypass -file `"$VBOXdrive\5_configureExchangeServer.ps1`""

#Features installeren
Write-host "Features installeren" -ForeGroundColor "Green"
Install-WindowsFeature RSAT-ADDS
Install-WindowsFeature NET-Framework-45-Features, RPC-over-HTTP-proxy, RSAT-Clustering, RSAT-Clustering-CmdInterface, RSAT-Clustering-Mgmt, RSAT-Clustering-PowerShell, Web-Mgmt-Console, WAS-Process-Model, Web-Asp-Net45, Web-Basic-Auth, Web-Client-Auth, Web-Digest-Auth, Web-Dir-Browsing, Web-Dyn-Compression, Web-Http-Errors, Web-Http-Logging, Web-Http-Redirect, Web-Http-Tracing, Web-ISAPI-Ext, Web-ISAPI-Filter, Web-Lgcy-Mgmt-Console, Web-Metabase, Web-Mgmt-Console, Web-Mgmt-Service, Web-Net-Ext45, Web-Request-Monitor, Web-Server, Web-Stat-Compression, Web-Static-Content, Web-Windows-Auth, Web-WMI, Windows-Identity-Foundation, RSAT-ADDS

#AD voorbereiden
Write-host "AD voorbereiden" -ForeGroundColor "Green"
Invoke-Expression "& d:\setup.exe /PrepareSchema /IAcceptExchangeServerLicenseTerms"
Invoke-Expression "& d:\Setup.exe /PrepareAD /OrganizationName:'red' /IAcceptExchangeServerLicenseTerms"

#Exchange Server 2016 installeren
Write-host "Exchange Server 2016 installeren" -ForeGroundColor "Green"
Invoke-Expression "& d:\Setup.exe /mode:Install /role:Mailbox /OrganizationName:'red' /IAcceptExchangeServerLicenseTerms"


Stop-Transcript

Restart-Computer