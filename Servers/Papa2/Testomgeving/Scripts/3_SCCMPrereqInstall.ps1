# Dit script zal eerst de prerequisites voor SCCM installeren / configureren en daarna SCCM zelf:
# Elke stap wordt uitgelegd met zijn eigen comment

############################################################################
############################################################################ NOTE: Dit script manueel uitvoeren als RED\Administrator !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
############################################################################


# VARIABLES:
$VBOXdrive = "C:\Vagrant"

$Username = "RED\Administrator"  # LET OP RED\Administrator ZAL SCCM INSTALLEREN EN ALLE RECHTEN EROP HEBBEN !
$Password = ConvertTo-SecureString "Admin2019" -AsPlainText -Force

# Password voor SQL installatie + Network access account (LIJN NIET WEG DOEN)
$SCCMPassword = [System.Runtime.Interopservices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password))

# PREFERENCE VARIABLES: (Om Debug,Verbose en informaation info in de Start-Transcript log files te zien)
$DebugPreference = "Continue"
$VerbosePreference = "Continue"
$InformationPreference = "Continue"

# LOG SCRIPT TO FILE (+ op het einde van het script Stop-Transcript doen):
Start-Transcript "C:\Scriptlogs\3_SCCMPrereqInstall_LOG.txt"

# Start-Sleep zal 30 seconden wachten voor hij aan het eerste commando van dit script begint
# om zeker te zijn dat de server klaar is met het starten van zijn services na de reboot
Write-host "Waiting 30 seconds before executing script" -ForeGroundColor "Green"
start-sleep -s 30
Write-host "Starting script now:" -ForeGroundColor "Green"

# 0) Zet auto login terug af:
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name AutoAdminLogon -Value 0
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name ForceAutoLogon -Value 0

############################################################################################################################### NOTE ENKEL VOOR TEST ENV.
# Write-Host "Copying SQL Server to local desktop. This might take a while..." -ForeGroundColor "Green"
# Copy-Item "$VBOXdrive\BenodigdeFiles\SQL Server 2017 Installation" -Destination "C:\Users\Administrator\Desktop\SQL Server 2017 Installation" -Recurse -Verbose
#
# Write-Host "Starting Installation of SQL Server 2017 Developpers edition (THIS TAKES A LONG TIME!)" -ForeGroundColor "Green"
#
# set-location 'C:\Users\Administrator\Desktop\SQL Server 2017 Installation'
# .\SETUP.EXE /Q /ACTION=Install /IACCEPTSQLSERVERLICENSETERMS /Features=SQL /INSTANCENAME=MSSQLSERVER /INSTANCEID=MSSQLSERVER `
#              /SQLSVCACCOUNT='RED\Administrator' /SQLSVCPASSWORD=$SCCMPassword `
#              /AGTSVCACCOUNT='RED\Administrator' /AGTSVCPASSWORD=$SCCMPassword `
#              /FTSVCACCOUNT='RED\Administrator' /FTSVCPASSWORD=$SCCMPassword `
#              /SQLSYSADMINACCOUNTS='RED\Administrator' 'RED\Administrator' `
#              /INSTALLSQLDATADIR=C:\SQLServer `
#              /SQLUSERDBDIR=C:\Database `
#              /SQLUSERDBLOGDIR=C:\DBlogs `
#              /SQLBACKUPDIR=C:\Backup `
#              /SQLTEMPDBDIR=C:\TempDB `
#              /SQLTEMPDBLOGDIR=C:\TempDBlog `
#              /TCPENABLED=1 `
#              /NPENABLED=1
#
#
# Write-Host "Installation SQL Server 2017 COMPLETED!" -ForeGroundColor "Green"
#
# start-sleep -s 15
#
# # 2.2) De juiste poorten openen in de firewall om SQL goed met SCCM te laten werken
# New-NetFirewallRule -DisplayName "SQL Server" -Direction Inbound -Protocol TCP -LocalPort 1433 -Action Allow
# New-NetFirewallRule -DisplayName "SQL Admin Connection" -Direction Inbound -Protocol TCP -LocalPort 1434 -Action Allow
# New-NetFirewallRule -DisplayName "SQL Database Management" -Direction Inbound -Protocol UDP -LocalPort 1434 -Action Allow
# New-NetFirewallRule -DisplayName "SQL Service Broker" -Direction Inbound -Protocol TCP -LocalPort 4022 -Action Allow
# New-NetFirewallRule -DisplayName "SQL Debugger RPC" -Direction Inbound -Protocol TCP -LocalPort 135 -Action Allow
#
# # 4) Installeer SQL Server Management studio:
# # 4.1) Download SSMS in /SSMS directory op desktop van domain admin:
# Write-Host "Copying SQL Server Management studio r to local desktop. This might take a while..." -ForeGroundColor "Green"
# Copy-Item "$VBOXdrive\BenodigdeFiles\SSMS" -Destination "C:\Users\Administrator\Desktop\SSMS" -Recurse -Verbose
#
# # 4.2) Installeer SSMS en wacht 200 seconden voor het script verder gaat:
# Write-Host "Starting installation of SQL Server Management studio (Takes a while!)" -ForeGroundColor "Green"
#
# Set-location 'C:\Users\Administrator\Desktop\SSMS'
# Start-Process "SSMS-Setup-ENU.exe" -ArgumentList "/Install", "/Quiet" -wait
# Start-Sleep -s 15
# Write-host "Continuing script now:" -ForeGroundColor "Green"
########################################################################################################################### NOTE ENKEL VOOR TEST ENV.


# 5) Installeer Windows Assessment And Deployment kit (ADK) role (+ Windows PE Addon):
# Dit is uiteraard nodig voor Operating System / client Deployment

# 5.1) Kopiêer ADK 1903 naar desktop:
Write-Host "Copying ADK 1903 to desktop/ADK1903:" -ForeGroundColor "Green"
Copy-Item "$VBOXdrive\BenodigdeFiles\ADK1903" -Destination "C:\Users\Administrator\Desktop\ADK1903" -Recurse -verbose
start-sleep -s 15
Write-Host "Copying ADK 1903 addon completed!" -ForeGroundColor "Green"

# 5.2) Installeer ADK 1903:
# /CEIP off = Opt out customer experience program
# De features zijn de standaard features die geselecteerd zijn als je ADKsetup als GUI install doet:
Write-Host "Starting installation of Windows ADK 1903:" -ForeGroundColor "Green"
set-location 'C:\Users\Administrator\Desktop\ADK1903'
Write-host "Waiting 45 seconds for ADK to install:" -ForeGroundColor "Green"

.\adksetup.exe /Quiet /norestart /ceip off `
               /Features OptionId.DeploymentTools OptionId.ImagingAndConfigurationDesigner `
               OptionId.ICDConfigurationDesigner OptionId.UserStateMigrationTool

start-sleep -s 45
Write-host "Continuing script now:" -ForeGroundColor "Green"

# 5.3) Kopieer WinPe addon vanaf Virtualbox shared folder naar desktop/WindowsPE:
# Bestand is ongeveer 4gb dus te groot om te downloaden (daarom kies ik voor een shared folder copy)
Write-Host "Copying Windows PE to desktop/WindowsPE:" -ForeGroundColor "Green"
Copy-Item "$VBOXdrive\BenodigdeFiles\WindowsPE" -Destination "C:\Users\Administrator\Desktop\WindowsPE" -Recurse -verbose
start-sleep -s 15
Write-Host "Copying WindowsPE addon completed!" -ForeGroundColor "Green"
Write-Host "Waiting a few minutes before installing WindowsPE to avoid Windows Installer error"

# 5.4) Installeer Windows PE addon
Start-Sleep -s 240
Write-Host "Starting installation of WindowsPE addon (5 minutes):" -ForeGroundColor "Green"
# dezze commandos resetten windows installer (anders deed WindowsPE lastig om te installeren)
msiexec /UNREGISTER
Start-sleep -s 2
msiexec /REGSERVER
Start-sleep -s 5

set-location 'C:\Users\Administrator\Desktop\WindowsPE'
.\adkwinpesetup.exe /Quiet /Features OptionId.WindowsPreinstallationEnvironment /L "C:\Scriptlogs\WindowsPElog.txt"

If ($?) {
  Write-Host "Installation WindowsPE Addon completed!" -ForeGroundColor "Green"
  Start-Sleep -s 240
} else {
  Write-Host "Installation WindowsPE Addon FAILED!" -ForeGroundColor "Red" -BackGroundColor "White"
}

Write-host "Continuing script now:" -ForeGroundColor "Green"

# 6) Installeer MDT 8456:
# 6.1) Kopiëer MDT:
Write-Host "Copying MDT 8456 to desktop/WindowsPE:" -ForeGroundColor "Green"
Copy-Item "$VBOXdrive\BenodigdeFiles\MDT" -Destination "C:\Users\Administrator\Desktop\MDT" -Recurse -verbose
start-sleep -s 15
Write-Host "Copying MDT 8456 completed!" -ForeGroundColor "Green"

# 6.2) Installeer MDT 8456 (installatie is msi bestand daarom gebruik je msiexec):
Write-Host "Starting installation of MDT 8456:" -ForeGroundColor "Green"
set-location 'C:\Users\Administrator\Desktop\MDT'

Write-host "Waiting 45 seconds for MDT to install:" -ForeGroundColor "Green"
Start-Process "MicrosoftDeploymentToolkit_X64.msi" /quiet -wait

If ($?) {
  Write-Host "Installation Windows MDT completed!" -ForeGroundColor "Green"
} else {
  Write-Host "Installation Windows MDT FAILED!" -ForeGroundColor "Red" -BackGroundColor "White"
}

start-sleep -s 45

Write-host "Continuing script now:" -ForeGroundColor "Green"

# 7) Installeer de nodige Windows features:
# Dit zijn vooral IIS default roles

# Om .net 3.5 (= Web-Asp-Net) te kunnen installeren op Windows Server 2019 moet je enkele source files kopiëren uit de
# Windows Server install DVD en deze als sources toevoegen aan het install-windowsFeature command
# (Path op install DVD = DVDDrive:\sources\sxs)
# Ik heb deze source files al gekopieerd en zal deze nu lokaal kopiëeren van de VirtualBox shared folder:
# 7.1) Kopiëer source files van virtualbox shared folder naar Administrator\Desktop:
Copy-Item "$VBOXdrive\BenodigdeFiles\DotNet35sources" -Destination "C:\Users\Administrator\Desktop\DotNet35Sources" -Recurse -verbose

# 7.2) Installatie van de windows roles/features zelf:
# -source option zal zeggen waar de sxs folder zich bevind
Write-host "Installing necessary Windows features (could take a while):" -ForeGroundColor "Green"

Install-WindowsFeature -name Web-Server, Web-WebServer, Web-Common-Http, Web-Default-Doc, Web-Static-Content, Web-Metabase, Web-App-Dev, `
               Web-Asp-Net, Web-Http-Logging, Web-Log-Libraries, Web-Request-Monitor, web-health, Web-Http-Tracing, Web-Performance, `
               Web-Stat-Compression, Web-Security, Web-Filtering, Web-Windows-Auth, Web-Mgmt-Tools, `
               Web-Lgcy-Scripting, Net-Framework-Core, Web-WMI, NET-HTTP-Activation, NET-Non-HTTP-Activ, NET-WCF-HTTP-Activation45, `
               NET-WCF-MSMQ-Activation45, NET-WCF-Pipe-Activation45, NET-WCF-TCP-Activation45, BITS, BITS-IIS-Ext, BITS-Compact-Server, `
               RDC, Web-Asp-Net45, Web-Net-Ext45, Web-Lgcy-Mgmt-Console, Web-Scripting-Tools `
               -source "C:\Users\Administrator\Desktop\DotNet35sources\sxs"

Write-host "Installation necessary Windows features completed!" -ForeGroundColor "Green"

# 4) Firewall uitzetten (want we gebruiken hardware firewall):
Write-Host "Turning firewall off:" -ForeGroundColor "Green"
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False

# 5) Voorbereiding op SCCM installatie zelf:

# 5.2) Copy SCCM installatie required files van VirtualBox Shared folder naar desktop\SCCMrequiredFiles:
Write-Host "Copying SCCM installation required files to desktop/SCCMrequiredfiles:" -ForeGroundColor "Green"
Copy-Item "$VBOXdrive\BenodigdeFiles\SCCMrequiredFiles" -Destination "C:\Users\Administrator\Desktop\SCCMrequiredFiles" -Recurse -verbose
Write-Host "Copying SCCM installation required files completed!" -ForeGroundColor "Green"

# 5.3) Installatie van SCCM zelf. Dit heb ik met een try catch block gedaan omdat er veel kan foutlopen tijdens deze installatie,
# door op deze manier te werken wordt de error naar de console geschreven als er een nonzero exit status is:
# LET OP DUURT ONGEVEER 86 MINUTEN !!!!!!
Write-Host "Starting installation of SCCM (Takes +/- 80-90 minutes)" -ForeGroundColor "Green"
Copy-Item "$VBOXdrive\BenodigdeFiles\SCCM 1902 Installation" -Destination "C:\Users\Administrator\Desktop\SCCM 1902 Installation" -Recurse -verbose
Start-Sleep -s 20
Set-Location "C:\Users\Administrator\Desktop\SCCM 1902 Installation\SMSSETUP\BIN\X64"

Start-Process "Setup.exe" -ArgumentList "/script $VBOXdrive\SCCMsilentInstallSettings.ini" -wait
# .\Setup.exe /script "$VBOXdrive\SCCMsilentInstallSettings.ini" | Out-Null TODO TODO Deze lijn mag weg indien bovenstaande werkt.
# Out-Null zodat Powershell wacht tot installatie klaar is voor hij verder gaat

If ($?) {
  Write-Host "Installation Windows SCCM completed!" -ForeGroundColor "Green"
} else {
  Write-Host "Installation Windows SCCM FAILED!" -ForeGroundColor "Red" -BackGroundColor "White"
}

# 5.4) Configureer MDT integratie met SCCM (met een kleine applicatie "configMgr Integration")
# Deze applicatie heeft geen cmdlets/options dus moet je het automatiseren met volgende cmds:
$SiteCode   = "RED"
$SiteServer = "Papa2.red.local"
$MDT  = "C:\Program Files\Microsoft Deployment Toolkit"
$SCCM = "C:\SCCM\AdminConsole"
$MOF  = "$SCCM\Bin\Microsoft.BDD.CM12Actions.mof"

Copy-Item "$MDT\Bin\Microsoft.BDD.CM12Actions.dll" "$SCCM\Bin\Microsoft.BDD.CM12Actions.dll"
Copy-Item "$MDT\Bin\Microsoft.BDD.Workbench.dll" "$SCCM\Bin\Microsoft.BDD.Workbench.dll"
Copy-Item "$MDT\Bin\Microsoft.BDD.ConfigManager.dll" "$SCCM\Bin\Microsoft.BDD.ConfigManager.dll"
Copy-Item "$MDT\Bin\Microsoft.BDD.CM12Wizards.dll" "$SCCM\Bin\Microsoft.BDD.CM12Wizards.dll"
Copy-Item "$MDT\Bin\Microsoft.BDD.PSSnapIn.dll" "$SCCM\Bin\Microsoft.BDD.PSSnapIn.dll"
Copy-Item "$MDT\Bin\Microsoft.BDD.Core.dll" "$SCCM\Bin\Microsoft.BDD.Core.dll"
Copy-Item "$MDT\SCCM\Microsoft.BDD.CM12Actions.mof" $MOF
Copy-Item "$MDT\Templates\CM12Extensions\*" "$SCCM\XmlStorage\Extensions\" -Force -Recurse
(Get-Content $MOF).Replace('%SMSSERVER%', $SiteServer).Replace('%SMSSITECODE%', $SiteCode) | Set-Content $MOF
& "C:\Windows\System32\wbem\mofcomp.exe" "$SCCM\Bin\Microsoft.BDD.CM12Actions.mof"

# 6) Configureer Boundaries & Boundary groups voor SCCM
# We hebben boundaries nodig voor site assignment (= clients krijgen policies toegewezen van een specifieke SCCM site (wij hebben er maar 1))
# En voor content location (clients krijgen content van de distribution point en boundaries zorgen ervoor dat ze de juiste content
# van de juiste source krijgen)
# Boundaries doen niks zonder dat ze aangewezen zijn aan een boundary group. Dus dit is een belangrijke stap om niet te vergeten.

# 6.1) Import SCCM cmdlets module:
# Om SCCM powershell cmds te gebruiken moeten we eerst de SCCM cmdlets module importeren en naar onze aangemaakte site gaan (site naam = RED):
Set-Location -Path "C:\SCCM\AdminConsole\bin"
Import-Module .\ConfigurationManager.psd1
New-PSDrive -Name "RED" -PsProvider "AdminUI.PS.Provider\CMSite" -Root "Papa2.red.local" `
            -Description "RED site drive"

# RED = sitecode
Write-Host "Opening RED: site please wait..........." -BackGroundColor "Green"
Start-Sleep -s 30
Set-Location -Path RED:

# 6.2) Maak de boundary en boundary group aan en link ze aan elkaar (type = Active Directory Site):
Write-Host "Creating Config Manager boundaries and boundary groups:" -ForeGroundColor "Green"
New-CMBoundary -Type ADSite -DisplayName "Active Directory Site" -Value "Default-First-Site-Name"
New-CMBoundaryGroup -Name "ADsite"

# Papa2 wordt ingesteld als site system server (= deze server zal degene zijn dat content provide voor deze boundary group)
Set-CMBoundaryGroup -Name "ADsite" -AddSiteSystemServerName "Papa2.red.local" -DefaultSiteCode "RED"
Add-CMBoundaryToGroup -BoundaryGroupName "ADSite" -BoundaryName "Active Directory Site"
Write-Host "boundaries/groups Creation completed!" -ForeGroundColor "Green"

# 7) Configureer client settings en network access account:
# De network access account is de account die clients gebruiken wanneer ze hun lokale user niet kunnen gebruiken om content te krijgen
# van de distribution points
# Zet "RED" als bedrijfsnaam voor alle clients:
Set-CMClientSettingComputerAgent -BrandingTitle "RED" -DefaultSetting

# Configureer de network access account (dit is de Administrator account)
# Met Read-Host password opvragen van Administrator en deze als network access account instellen voor de clients:
Write-Host "Configuring Network Access account " -ForeGroundColor "Green"
New-CMAccount -UserName "$username" -Password $password -SiteCode "RED"
Set-CMSoftwareDistributionComponent -SiteCode "RED" -AddNetworkAccessAccountName "RED\Administrator"
Write-Host "Network access account configured!" -ForeGroundColor "Green"

# 8) Zet discovery methods (AD users, AD groups, AD systems en Network discovery aan):
# Dit zal om de 7 dagen automatisch scannen naar nieuwe users,groups,systems en ip adressen in je domain:
Set-CMDiscoveryMethod -ActiveDirectoryForestDiscovery -SiteCode "RED" -Enabled $true
Set-CMDiscoveryMethod -NetworkDiscovery -SiteCode "RED" -Enabled $true -NetworkDiscoveryType ToplogyAndClient
Set-CMDiscoveryMethod -ActiveDirectorySystemDiscovery -SiteCode "RED" -Enabled $true -ActiveDirectoryContainer "LDAP://DC=red,DC=local"
Set-CMDiscoveryMethod -ActiveDirectoryUserDiscovery -SiteCode "RED" -Enabled $true -ActiveDirectoryContainer "LDAP://DC=red,DC=local"

$discoveryScope = New-CMADGroupDiscoveryScope -LDAPlocation "LDAP://DC=red,DC=local" -Name "ADdiscoveryScope" -RecursiveSearch $true
Set-CMDiscoveryMethod -ActiveDirectoryGroupDiscovery -SiteCode "RED" -Enabled $true -AddGroupDiscoveryScope $discoveryScope

# 9) Stel PXE in zodat clients hun ip adres van DHCP kunnen krijgen wanneer WIndows 10 gedeployed wordt:
# PXE stel je in SCCM in op een distribution point (properties > PXE)

# Eerst nieuwe boot image voor X64 aanmaken:
# NOTE: VOLGENDE LIJN WAARSCHIJNLIJK NIET NODIG (x64 boot image werd standaard al aangemaakt bij SCCM installatie)
# Write-Host "Creating Windows 10 64 bit boot image (takes a few minutes):" -ForeGroundColor "Green"
#New-CMBootImage -Path "\\Papa2\sms_RED\OSD\boot\x64\boot.wim" -Name "Windows10x64" -Index 5 -verbose

Write-Host "Configuring PXE boot:" -ForeGroundColor "Green"

Set-CMDistributionPoint -SiteSystemServerName "Papa2.red.local" -enablePXE $true -AllowPxeResponse $true `
                        -EnableUnknownComputerSupport $true -RespondToAllNetwork

Write-Host "PXE boot configured!" -ForeGroundColor "Green"

# 10) Distribute de boot image (die standaard is aangemaakt bij SCCM installatie) naar een Distribution Point:
Start-CMContentDistribution -BootImageId "RED00005" -DistributionPointName "Papa2.red.local"

##########                        ##########
#          WSUS / WINWDOWS UPDATES         #
##########                        ##########

# 11) Installeer WSUS role:
Write-Host "Installing WSUS role with SQL integration:" -ForeGroundColor "Green"
Install-WindowsFeature -Name UpdateServices-DB, UpdateServices-Services -IncludeManagementTools
New-Item -Path "C:\" -ItemType Directory -Name "WSUS" # WSUS content locatie
Write-Host "Installation WSUS completed!" -ForeGroundColor "Green"

# Post deployment configuratie instellen: (content location + SQL Server aan WSUS linken):
Write-Host "Configuring WSUS with SQL server and setting WSUS content location:" -ForeGroundColor "Green"
Set-Location -Path "C:\Program Files\Update Services\Tools"
# LET OP: aangezien we een default instance gebruikt hebben (bij installatie SQL server) laat je instance name hieronder leeg
# Normaal doe je SERVER_NAME\INSTANCE_NAME maar bij ons is het dus gewoon SERVER_NAME
# --------------------------------------------------------------------------------------------------------------------------------------
 ######################################################################################## NOTE ECHTE SETTINGS VOOR INTEGRATIE DEMO
 .\wsusutil.exe postinstall SQL_INSTANCE_NAME="November2" CONTENT_DIR=C:\WSUS

# --------------------------------------------------------------------------------------  NOTE OM TE TESTEN MET EIGEN SQL SERVER:
#.\wsusutil.exe postinstall SQL_INSTANCE_NAME="Papa2" CONTENT_DIR=C:\WSUS
# --------------------------------------------------------------------------------------------------------------------------------------

If ($?) {
  Write-Host "Post-deployment configuration WSUS completed!" -ForeGroundColor "Green"
} else {
  Write-Host "Post-deployment configuration WSUS FAILED!" -ForeGroundColor "Red" -BackGroundColor "White"
}

# 12) Maak en configureer een Software Update point role in SCCM:
Set-Location RED:
# 12.1) Installeer de Software Update Point role op Papa2:
Write-Host "Creating Software Update Point Role in SCCM:" -ForeGroundColor "Green"
Add-CMSoftwareUpdatePoint -SiteCode "RED" -SiteSystemServerName "Papa2.red.local" -ClientConnectionType "Intranet"

# 12.2) Configureer WSUS via SCCM met volgende settings:
# -SynchronizeAction staat op sync with microsoft servers, Enkele kleinere updates geselecteerd, ReportingEvents staan af
Set-CMSoftwareUpdatePointComponent -SynchronizeAction "SynchronizeFromMicrosoftUpdate" -ReportingEvent "DoNotCreateWsusReportingEvents" `
                                   -RemoveUpdateClassification "Service Packs","Upgrades","Update Rollups","Tools","Driver sets", `
                                   "Applications","Drivers","Feature Packs","Definition Updates", "Updates" `
                                   -AddUpdateClassification "Security Updates" -RemoveProductFamily "Office","Windows" -SiteCode "RED" -verbose

# 12.3) Verwijder alle talen buiten engels en alle producten buiten Windows 10 (zodat de WSUS content folder niet te groot wordt):
Write-Host "Configuring which updates will be synchronized (Only English language updates):" -ForeGroundColor "Green"

$WSUSserver = Get-WSUSserver
$WSUSconfig = $WSUSserver.GetConfiguration()
$WSUSconfig.AllUpdateLanguagesEnabled = $false
$WSUSconfig.SetEnabledUpdateLanguages("en")
$WSUSconfig.Save()


# 13) Synchroniseer de gekozen software updates met de Microsoft Servers:
# CHECK PROGRESS in C:\SCCM\logs\wsyncmgr.log
Write-Host "Starting syncronization of WSUS updates (in SCCM) in 300 seconds:" -ForeGroundColor "Green"

$beforeSync = Get-Date

  Restart-Service -Name sms_executive
  Sync-CMSoftwareUpdate -FullSync $true

  ### Wachten tot sync cycle klaar is: ###
  Start-Sleep -Seconds 300
  Write-host "Starting sync now:" -ForeGroundColor "Green"
  $syncStatus = Get-CMSoftwareUpdateSyncStatus
  Sync-CMSoftwareUpdate -FullSync $true


  $maxSeconds = (60*70)
  $endWait = $beforeSync.AddSeconds($maxSeconds)
  $intervalSeconds = 60

  Write-Host "  Waiting on Software Update Sync Cycle..."
  while($now -lt $endWait){
    $now = Get-Date
    $syncStatus = Get-CMSoftwareUpdateSyncStatus


    if($null -eq $syncStatus.LastSuccessfulSyncTime -or
       $syncStatus.LastSuccessfulSyncTime -lt $beforeSync)
    {
      continue
    }else{
      Write-Host "Sync completed!" -ForeGroundColor "Green"
      break
    }
  }

  # Nieuw product (Windows 10) toevoegen na de sync:
  Set-CMSoftwareUpdatePointComponent -SiteCode "RED" `
    -AddProduct "Windows 10, version 1809 and later, Upgrade & Servicing Drivers"

Stop-Transcript
