# Dit script zal eerst de prerequisites voor SCCM installeren / configureren en daarna SCCM zelf:
# Elke stap wordt uitgelegd met zijn eigen comment
# TODO: 2e schijf (:E) instellen!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

# VARIABLES:
$VBOXdrive = "Z:"

$Username = "RED\SCCMAdmin"  # LET OP SCCMADMIN ZAL SCCM INSTALLEREN EN ALLE RECHTEN EROP HEBBEN !
$Password = ConvertTo-SecureString "Admin2019" -AsPlainText -Force

# Password voor SQL installatie (TODO enkel nodig voor test environment)
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

################################################################################################################################### ENKEL VOOR TEST ENV.
Write-Host "Copying SQL Server to local desktop. This might take a while..." -ForeGroundColor "Green"
Copy-Item "Z:\SQL Server 2017 Installation" -Destination "C:\Users\SCCMadmin\Desktop\SQL Server 2017 Installation" -Recurse -Verbose

Write-Host "Starting Installation of SQL Server 2017 Developpers edition (THIS TAKES A LONG TIME!)" -ForeGroundColor "Green"

set-location 'C:\Users\SCCMadmin\Desktop\SQL Server 2017 Installation'
.\SETUP.EXE /Q /ACTION=Install /IACCEPTSQLSERVERLICENSETERMS /Features=SQL /INSTANCENAME=MSSQLSERVER /INSTANCEID=MSSQLSERVER `
             /SQLSVCACCOUNT='RED\SCCMAdmin' /SQLSVCPASSWORD=$SCCMPassword `
             /AGTSVCACCOUNT='RED\SCCMAdmin' /AGTSVCPASSWORD=$SCCMPassword `
             /FTSVCACCOUNT='RED\SCCMAdmin' /FTSVCPASSWORD=$SCCMPassword `
             /SQLSYSADMINACCOUNTS='RED\SCCMAdmin' 'RED\Administrator' `
             /INSTALLSQLDATADIR=E:\SQLServer `
             /SQLUSERDBDIR=E:\Database `
             /SQLUSERDBLOGDIR=E:\DBlogs `
             /SQLBACKUPDIR=E:\Backup `
             /SQLTEMPDBDIR=E:\TempDB `
             /SQLTEMPDBLOGDIR=E:\TempDBlog `
             /TCPENABLED=1 `
             /NPENABLED=1


Write-Host "Installation SQL Server 2017 FAILED!" -ForeGroundColor "Red" -BackGroundColor "White"

start-sleep -s 15

# 2.2) De juiste poorten openen in de firewall om SQL goed met SCCM te laten werken
New-NetFirewallRule -DisplayName "SQL Server" -Direction Inbound -Protocol TCP -LocalPort 1433 -Action Allow
New-NetFirewallRule -DisplayName "SQL Admin Connection" -Direction Inbound -Protocol TCP -LocalPort 1434 -Action Allow
New-NetFirewallRule -DisplayName "SQL Database Management" -Direction Inbound -Protocol UDP -LocalPort 1434 -Action Allow
New-NetFirewallRule -DisplayName "SQL Service Broker" -Direction Inbound -Protocol TCP -LocalPort 4022 -Action Allow
New-NetFirewallRule -DisplayName "SQL Debugger RPC" -Direction Inbound -Protocol TCP -LocalPort 135 -Action Allow

# 4) Installeer SQL Server Management studio:
# 4.1) Download SSMS in /SSMS directory op desktop van domain admin:
Write-Host "Downloading SQL Server Management studio:" -ForeGroundColor "Green"
$folderpath = "C:\Users\SCCMadmin\Desktop\"
New-Item -Path "$folderpath" -Name "SSMS" -ItemType "directory"
$filepath="$folderpath\SSMS\SSMS-Setup-ENU.exe"
$URL = "https://go.microsoft.com/fwlink/?linkid=870039"
$client = New-Object System.Net.WebClient
$client.DownloadFile($url,$filepath)
Write-Host "Download completed!" -ForeGroundColor "Green"

# 4.2) Installeer SSMS en wacht 200 seconden voor het script verder gaat:
Write-Host "Starting installation of SQL Server Management studio (Takes a while!)" -ForeGroundColor "Green"

Set-location 'C:\Users\SCCMadmin\Desktop\SSMS'
Start-Process "SSMS-Setup-ENU.exe" -ArgumentList "/Install", "/Quiet" -wait

If ($?) {
  Write-Host "Installation SQL Server Management Studio completed!" -ForeGroundColor "Green"
} else {
  Write-Host "Installation SQL Server Management Studio FAILED!" -ForeGroundColor "Red" -BackGroundColor "White"
}

Write-host "Continuing script now:" -ForeGroundColor "Green"
################################################################################################################################### ENKEL VOOR TEST ENV.


# 5) Installeer Windows Assessment And Deployment kit (ADK) role (+ Windows PE Addon):
# Dit is uiteraard nodig voor Operating System / client Deployment

# 5.1) Kopiêer ADK 1903 naar desktop:
Write-Host "Copying ADK 1903 to desktop/ADK1903:" -ForeGroundColor "Green"
Copy-Item "Z:\ADK1903" -Destination "C:\Users\SCCMadmin\Desktop\ADK1903" -Recurse -verbose
start-sleep -s 15
Write-Host "Copying ADK 1903 addon completed!" -ForeGroundColor "Green"

# 5.2) Installeer ADK 1903:
# /CEIP off = Opt out customer experience program
# De features zijn de standaard features die geselecteerd zijn als je ADKsetup als GUI install doet:
Write-Host "Starting installation of Windows ADK 1903:" -ForeGroundColor "Green"
set-location 'C:\Users\SCCMadmin\Desktop\ADK1903'
Write-host "Waiting 45 seconds for ADK to install:" -ForeGroundColor "Green"

.\adksetup.exe /Quiet /norestart /ceip off `
               /Features OptionId.DeploymentTools OptionId.ImagingAndConfigurationDesigner `
               OptionId.ICDConfigurationDesigner OptionId.UserStateMigrationTool

If ($?) {
  Write-Host "Installation Windows ADK 1903 completed!" -ForeGroundColor "Green"
} else {
  Write-Host "Installation Windows ADK 1903 FAILED!" -ForeGroundColor "Red" -BackGroundColor "White"
}

start-sleep -s 45
Write-host "Continuing script now:" -ForeGroundColor "Green"

# 5.3) Kopieer WinPe addon vanaf Virtualbox shared folder naar desktop/WindowsPE:
# Bestand is ongeveer 4gb dus te groot om te downloaden (daarom kies ik voor een shared folder copy)
Write-Host "Copying Windows PE to desktop/WindowsPE:" -ForeGroundColor "Green"
Copy-Item "Z:\WindowsPE" -Destination "C:\Users\SCCMadmin\Desktop\WindowsPE" -Recurse -verbose
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

set-location 'C:\Users\SCCMadmin\Desktop\WindowsPE'
.\adkwinpesetup.exe /Quiet /Features OptionId.WindowsPreinstallationEnvironment /L "C:\Scriptlogs\WindowsPElog.txt"

If ($?) {
  Write-Host "Installation WindowsPE Addon completed!" -ForeGroundColor "Green" -BackGroundColor "White"
  Start-Sleep -s 240
} else {
  Write-Host "Installation WindowsPE Addon FAILED!" -ForeGroundColor "Red" -BackGroundColor "White"
}

Write-host "Continuing script now:" -ForeGroundColor "Green"

# 6) Installeer MDT 8456:
# 6.1) Kopiëer MDT:
Write-Host "Copying MDT 8456 to desktop/WindowsPE:" -ForeGroundColor "Green"
Copy-Item "Z:\MDT" -Destination "C:\Users\SCCMadmin\Desktop\MDT" -Recurse -verbose
start-sleep -s 15
Write-Host "Copying MDT 8456 completed!" -ForeGroundColor "Green"

# 6.2) Installeer MDT 8456 (installatie is msi bestand daarom gebruik je msiexec):
Write-Host "Starting installation of MDT 8456:" -ForeGroundColor "Green"
set-location 'C:\Users\SCCMadmin\Desktop\MDT'

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
# 7.1) Kopiëer source files van virtualbox shared folder naar SCCMadmin\Desktop:
Copy-Item "Z:\DotNet35sources" -Destination "C:\Users\SCCMadmin\Desktop\DotNet35Sources" -Recurse -verbose

# 7.2) Installatie van de windows roles/features zelf:
# -source option zal zeggen waar de sxs folder zich bevind
Write-host "Installing necessary Windows features (could take a while):" -ForeGroundColor "Green"

Install-WindowsFeature -name Web-Server, Web-WebServer, Web-Common-Http, Web-Default-Doc, Web-Static-Content, Web-Metabase, Web-App-Dev, `
               Web-Asp-Net, Web-Http-Logging, Web-Log-Libraries, Web-Request-Monitor, web-health, Web-Http-Tracing, Web-Performance, `
               Web-Stat-Compression, Web-Security, Web-Filtering, Web-Windows-Auth, Web-Mgmt-Tools, `
               Web-Lgcy-Scripting, Net-Framework-Core, Web-WMI, NET-HTTP-Activation, NET-Non-HTTP-Activ, NET-WCF-HTTP-Activation45, `
               NET-WCF-MSMQ-Activation45, NET-WCF-Pipe-Activation45, NET-WCF-TCP-Activation45, BITS, BITS-IIS-Ext, BITS-Compact-Server, `
               RDC, Web-Asp-Net45, Web-Net-Ext45, Web-Lgcy-Mgmt-Console, Web-Scripting-Tools `
               -source "C:\Users\SCCMadmin\Desktop\DotNet35sources\sxs"

Write-host "Installation necessary Windows features completed!" -ForeGroundColor "Green"

# 4) Firewall uitzetten (want we gebruiken hardware firewall):
Write-Host "Turning firewall off:" -ForeGroundColor "Green"
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False

# 5) Voorbereiding op SCCM installatie zelf:
# 5.1) Aangezien we SCCM op de D: drive gaan installeren ipv de System (C:) drive moeten we op de root van de C: drive
# Het volgende bestand aanmaken. Dan zal SCCM alles op de gekozen drive (D:) installeren:
New-Item -Path "C:\" -Name "no_sms_on_drive.SMS" -ItemType "file"

# 5.2) Copy SCCM installatie required files van VirtualBox Shared folder naar desktop\SCCMrequiredFiles:
Write-Host "Copying SCCM installation required files to desktop/SCCMrequiredfiles:" -ForeGroundColor "Green"
Copy-Item "Z:\SCCMrequiredFiles" -Destination "C:\Users\SCCMadmin\Desktop\SCCMrequiredFiles" -Recurse -verbose
Write-Host "Copying SCCM installation required files completed!" -ForeGroundColor "Green"

# 5.3) Installatie van SCCM zelf. Dit heb ik met een try catch block gedaan omdat er veel kan foutlopen tijdens deze installatie,
# door op deze manier te werken wordt de error naar de console geschreven als er een nonzero exit status is:
# LET OP DUURT ONGEVEER 86 MINUTEN !!!!!!
Write-Host "Starting installation of SCCM (Takes +/- 80-90 minutes)" -ForeGroundColor "Green"
Copy-Item "Z:\SCCM 1902 Installation" -Destination "C:\Users\SCCMadmin\Desktop\SCCM 1902 Installation" -Recurse -verbose
Start-Sleep -s 20
Set-Location "C:\Users\SCCMadmin\Desktop\SCCM 1902 Installation\SMSSETUP\BIN\X64"

Start-Process "Setup.exe" -ArgumentList "/script Z:\SCCMsilentInstallSettings.ini" -wait
# .\Setup.exe /script "Z:\SCCMsilentInstallSettings.ini" | Out-Null TODO TODO Deze lijn mag weg indien bovenstaande werkt.
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
$SCCM = "D:\SCCM\AdminConsole"
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
