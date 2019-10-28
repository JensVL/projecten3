# Firewall uitzetten:
Set-NetFirewallProfile -Profile Domain, Public, Private -Enabled False

Install-WindowsFeature RSAT-ADDS

Install-WindowsFeature NET-Framework-45-Features, RPC-over-HTTP-proxy, RSAT-Clustering, RSAT-Clustering-CmdInterface, RSAT-Clustering-Mgmt, RSAT-Clustering-PowerShell, Web-Mgmt-Console, WAS-Process-Model, Web-Asp-Net45, Web-Basic-Auth, Web-Client-Auth, Web-Digest-Auth, Web-Dir-Browsing, Web-Dyn-Compression, Web-Http-Errors, Web-Http-Logging, Web-Http-Redirect, Web-Http-Tracing, Web-ISAPI-Ext, Web-ISAPI-Filter, Web-Lgcy-Mgmt-Console, Web-Metabase, Web-Mgmt-Console, Web-Mgmt-Service, Web-Net-Ext45, Web-Request-Monitor, Web-Server, Web-Stat-Compression, Web-Static-Content, Web-Windows-Auth, Web-WMI, Windows-Identity-Foundation

Install-WindowsFeature Server-Media-Foundation

choco install dotnet4.7.2 -n

choco install vcredist2013 -n
# install Microsoft Unified Communications Managed API 4.0
choco install ucma4 -n

# Set-ADForestMode -Identity Get-ADForest -Server Get-ADForest.SchemaMaster -ForestMode Windows2016Forest

# Rename computer:
# Rename-Computer -NewName Charlie2 -Force
# (Daarna moet de server wel reboot worden)

Set-Location "D:"
.\setup.exe /PrepareSchema /IAcceptExchangeServerLicenseTerms

.\Setup.exe /PrepareAD /OrganizationName:"RED" /IAcceptExchangeServerLicenseTerms

./Setup.exe /PrepareAllDomains /IAcceptExchangeServerLicenseTerms

.\Setup.exe /mode:Install /role:Mailbox /OrganizationName:"RED" /IAcceptExchangeServerLicenseTerms

