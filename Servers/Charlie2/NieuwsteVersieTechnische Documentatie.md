# Technische documentatie Charlie 2 - Exchange Server

#### Uitleg

Charlie2 is een mailserver (Exchange Server) met SMTP en IMAP. Gebruik steeds de meest
recente versie. Het moet mogelijk zijn mails te versturen en te ontvangen tussen de twee domeinen. Gebruikers in de directory server (AD) hebben ook een mailbox.



#### Stappenplan

1. Installeer [Windows Server 2016](https://software-download.microsoft.com/download/pr/Windows_Server_2016_Datacenter_EVAL_en-us_14393_refresh.ISO) (opslag 50GB) met een Host-only adapter in het netwerk 172.18.1.64/27. Voor testen zonder integratie met het netwerk moet je ook een NAT adapter instellen.
2. Voer de installatieschijf van [Exchange Server 2016 CU14](https://download.microsoft.com/download/f/4/e/f4e4b3a0-925b-4eff-8cc7-8b5932d75b49/ExchangeServer2016-x64-cu14.iso) in, schakel de server uit, wijzig de opstartvolgorde van de schijven zodat de harde schijf op de eerste plaats staat en start de server opnieuw op.
3. Maak een gedeelde folder in virtualbox met de map "p3ops-1920-red\Servers\Charlie2\scripts" uit de GitHub-repository.
4. Run het powershellscript '1_RenameServer.ps1' in de gedeelde schijf "Z:" als administrator, bevestig de wijzigingen aan de 'execution policy' door de vraag met 'A' te beantwoorden.
5. Open een browser op de server of op de host (dan moet je wel de dns-server instellen op Alfa2) en ga naar het Exchange-beheercentrum via https://mail.red.local/ecp. Log in met de login-gegevens van de AD-administrator. Selecteer de gewenste taal en tijdszone en ga verder.
6. Selecteer in de linkerkolom 'servers' en klik op het potlood-icoon/wijzigen voor server Charlie2. Ga vervolgens naar 'DNS-zoekopdrachten'.
7. Controleer of het correcte DNS-adres verschijnt en selecteer indien nodig de juiste netwerkadapter, zowel voor interne als externe zoekopdrachten zodat het ip-adres van de dns-server Alfa2 verschijnt. Sla vervolgens de wijzigingen op.



#### Uitleg powershellcode

Hieronder vindt u meer uitleg over de powershellcode. Naast onderstaande code, is er ook nog een deel code dat als doel heeft om bij de verschillende stappen de gebruiker duidelijk te maken wat er gewijzigd, geïnstalleerd enzovoort wordt, dit gebeurt a.d.h van de "Write-host"-lijnen. Dan is er op het einde van elk script het "Restart-Computer" commando om te herstarten. Daarnaast wordt er na elk script automatisch overgeschakeld naar het volgende a.d.h. van het de vlgende lijn: 
> Set-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce' -Name ResumeScript `
                -Value "C:\Windows\system32\WindowsPowerShell\v1.0\Powershell.exe -executionpolicy bypass -file `"$VBOXdrive\NaamVolgendUitTeVoerenScript`""

Er wordt ook een "Log transcript" gecreërd na elk script via "Start-Transcript "padLogFile" " in het begin en op het einde "Stop-Transcript"

1. Naam van netwerkadapter(s) wijzigen voor duidelijkheid (op ESXI-Server)

      ```
      Get-NetAdapter -Name "Ethernet0" | Rename-NetAdapter -NewName "LAN"
      Get-NetAdapter -Name "Ethernet1" | Rename-NetAdapter -NewName "Internet"
      ```

2. Ip adres instellen voor LAN

   ```
   New-NetIPAddress -InterfaceAlias "LAN" -IPAddress "172.18.1.68" -PrefixLength 27
   ```

3. Alfa2 en Bravo2 als DNS-server instellen

   ```
   Set-DnsClientServerAddress -InterfaceAlias "LAN" -ServerAddress ("172.18.1.66","172.18.1.67")
   ```

4. Firewall uitschakelen

   ```
   Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False
   ```

5. Server hernoemen naar 'Charlie2'. Hierna herstarten

   ```
   Rename-Computer -NewName Charlie2 -Force -restart
   ```

6. Join domein red.local. Hierna herstarten en opnieuw inlogen als AD-user

   ```
   Add-Computer -ComputerName 'Charlie2' -DomainName 'red.local'-Credential red.local\Administrator -Restart
   ```

7. Chocolatey installeren en automatisch bevestigen activeren

   ```
   Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
   choco feature enable -n=allowGlobalConfirmation
   ```

8. .NET 4.7.2 installeren via Chocolatey

   ```
   choco install dotnet4.7.2
   ```

9. Visual C++ Redistributable Packages for Visual Studio installeren via Chocolatey

   ```
   choco install vcredist2013
   ```

10. UCMA/Microsoft Unified Communications Managed API 4.0 installeren via Chocolatey

    ```
    choco install ucma4
    ```

11. Windows Features installeren

    ```
    Install-WindowsFeature RSAT-ADDS
    Install-WindowsFeature NET-Framework-45-Features, RPC-over-HTTP-proxy, RSAT-Clustering, RSAT-Clustering-CmdInterface, RSAT-Clustering-Mgmt, RSAT-Clustering-PowerShell, Web-Mgmt-Console, WAS-Process-Model, Web-Asp-Net45, Web-Basic-Auth, Web-Client-Auth, Web-Digest-Auth, Web-Dir-Browsing, Web-Dyn-Compression, Web-Http-Errors, Web-Http-Logging, Web-Http-Redirect, Web-Http-Tracing, Web-ISAPI-Ext, Web-ISAPI-Filter, Web-Lgcy-Mgmt-Console, Web-Metabase, Web-Mgmt-Console, Web-Mgmt-Service, Web-Net-Ext45, Web-Request-Monitor, Web-Server, Web-Stat-Compression, Web-Static-Content, Web-Windows-Auth, Web-WMI, Windows-Identity-Foundation, RSAT-ADDS
    ```

12. AD voorbereiden ("d" = naam schijf exchange server)

    ```
    & d:\setup.exe /PrepareSchema /IAcceptExchangeServerLicenseTerms
    & d:\Setup.exe /PrepareAD /OrganizationName:'red' /IAcceptExchangeServerLicenseTerms
    ```

13. Exchange Server 2016 installeren ("d" = naam schijf exchange server)

    ```
    & d:\Setup.exe /mode:Install /role:Mailbox /OrganizationName:'red' /IAcceptExchangeServerLicenseTerms
    ```

14. Een mailbox activeren voor alle AD-gebruikers

    ```
    Add-PSSnapin Microsoft.Exchange.Management.PowerShell.SnapIn
    $ADUsers = Get-ADUser -filter {userAccountControl -eq 512} -properties *
    $ADUsers | foreach{enable-mailbox -Identity $_.Name -Database (get-mailboxdatabase).name}
    ```

15. Send-connector aanmaken

    ```
    New-SendConnector -Name 'E-mail SMTP' -AddressSpaces * -Internet -SourceTransportServer Charlie2.red.local
    ```

    



Handige links:

https://download.microsoft.com/download/2/C/4/2C47A5C1-A1F3-4843-B9FE-84C0032C61EC/UcmaRuntimeSetup.exe

<https://www.itprotoday.com/email-and-calendaring/how-install-microsoft-exchange-server-2016-windows-server-2016-powershell>

<https://emg.johnshopkins.edu/?p=1072> (Meer controles bij installatie ucma.exe)

<https://www.youtube.com/watch?v=Z7nA0mpaSWQ>