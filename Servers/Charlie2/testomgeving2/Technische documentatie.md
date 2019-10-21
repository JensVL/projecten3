### Technische documentatie

1. Installeer windows server 2016 (opslag 50GB) + ADDS (om te testen zonder alpha2/bravo2). Maak snapshot in VirtualBox om instellingen makkelijk terug te plaatsen bij testen
2. IP adres instellen voor host-only adapter: 172.18.1.68/24
3. AD joinen
4. Powershell code:

```
#Chocolatey installeren
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
#.NET 4.7.2 installeren
choco install dotnet4.7.2
#Visual C++ Redistributable Packages for Visual Studio installeren
choco install vcredist2013
#install ucma
choco install ucma4

Install-WindowsFeature RSAT-ADDS

Install-WindowsFeature NET-Framework-45-Features, RPC-over-HTTP-proxy, RSAT-Clustering, RSAT-Clustering-CmdInterface, RSAT-Clustering-Mgmt, RSAT-Clustering-PowerShell, Web-Mgmt-Console, WAS-Process-Model, Web-Asp-Net45, Web-Basic-Auth, Web-Client-Auth, Web-Digest-Auth, Web-Dir-Browsing, Web-Dyn-Compression, Web-Http-Errors, Web-Http-Logging, Web-Http-Redirect, Web-Http-Tracing, Web-ISAPI-Ext, Web-ISAPI-Filter, Web-Lgcy-Mgmt-Console, Web-Metabase, Web-Mgmt-Console, Web-Mgmt-Service, Web-Net-Ext45, Web-Request-Monitor, Web-Server, Web-Stat-Compression, Web-Static-Content, Web-Windows-Auth, Web-WMI, Windows-Identity-Foundation, RSAT-ADDS

#Ga naar installatieschijf exchange server in powershell
d:

.\Setup.exe /PrepareAD /OrganizationName:'test' /IAcceptExchangeServerLicenseTerms
#enable the Active Directory Domain for Exchange Server 2019
./Setup.exe /PrepareAllDomains /IAcceptExchangeServerLicenseTerms

#einde voorbereidende fase (snapshot)

#installatie
.\Setup.exe /mode:Install /role:Mailbox /OrganizationName:'test' /IAcceptExchangeServerLicenseTerms

```







```
Install-WindowsFeature Server-Media-Foundation, NET-Framework-45-Features, RPC-over-HTTP-proxy, RSAT-Clustering, RSAT-Clustering-CmdInterface, RSAT-Clustering-PowerShell, WAS-Process-Model, Web-Asp-Net45, Web-Basic-Auth, Web-Client-Auth, Web-Digest-Auth, Web-Dir-Browsing, Web-Dyn-Compression, Web-Http-Errors, Web-Http-Logging, Web-Http-Redirect, Web-Http-Tracing, Web-ISAPI-Ext, Web-ISAPI-Filter, Web-Metabase, Web-Mgmt-Service, Web-Net-Ext45, Web-Request-Monitor, Web-Server, Web-Stat-Compression, Web-Static-Content, Web-Windows-Auth, Web-WMI, RSAT-ADDS -restart

Optie 1:
#chocolatey installeren
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

#autoconfirm
choco feature enable -n=allowGlobalConfirmation

#install ucma
choco install ucma4



Optie 2:

#downloaden MICROSOFT UNIFIED COMMUNICATIONS MANAGED API 4.0
Invoke-WebRequest -Uri "http://download.microsoft.com/download/2/C/4/2C47A5C1-A1F3-4843-B9FE-84C0032C61EC/UcmaRuntimeSetup.exe" -OutFile "C:\Users\Administrator\Downloads\Ucma.exe"


#installeren MICROSOFT UNIFIED COMMUNICATIONS MANAGED API 4.0 (indien je dit een 2e keer runt, wordt het verwijderd)
Start-Process "C:\Users\Administrator\Downloads\Ucma.exe" -ArgumentList "/quiet /norestart" -Wait -PassThru
```

5. Voer schijf exchange server 2016 in

6. Powershell code (op AD?):

   ```
   #navigeer naar installatieschijf
   d:
   
   .\setup.exe /PrepareSchema /IAcceptExchangeServerLicenseTerms
   .\Setup.exe /PrepareAD /OrganizationName:'test' /IAcceptExchangeServerLicenseTerms
   ```

7. ```
   .\Setup.exe /mode:Install /role:Mailbox /OrganizationName:'test' /IAcceptExchangeServerLicenseTerms
   ```

   




Handige links:

https://download.microsoft.com/download/2/C/4/2C47A5C1-A1F3-4843-B9FE-84C0032C61EC/UcmaRuntimeSetup.exe

<https://www.itprotoday.com/email-and-calendaring/how-install-microsoft-exchange-server-2016-windows-server-2016-powershell>

<https://emg.johnshopkins.edu/?p=1072> (Meer controles bij installatie ucma.exe)

<https://www.youtube.com/watch?v=Z7nA0mpaSWQ>

