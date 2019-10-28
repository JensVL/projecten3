Write-host "Installatie Exchange Server Script 4" -ForeGroundColor "Red"

# LOG SCRIPT TO FILE (+ op het einde van het script Stop-Transcript doen):
Start-Transcript "C:\ScriptLogs\4_InstallatieExchangeServer.txt"

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

Write-host "Auto-login uitschakelen" -ForeGroundColor "Green"
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name DefaultPassword -Value ""
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name AutoAdminLogon -Value 0
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name ForceAutoLogon -Value 0

Write-host "Installatie is beëindigd" -ForeGroundColor "Red"
Stop-Transcript

Restart-Computer