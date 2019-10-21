# VARIABLES:
$VBOXdrive = "Z:"
$Land = "eng-BE"
$IpAddress = "172.18.1.67"
$IpAlfa2 = "172.18.1.66"
$CIDR = "27"
# $DefaultGateWay = "172.18.1.98"
$AdapterNaam = "LAN"
# $DebugPreference = "Continue"
# $VerbosePreference = "Continue"
# $InformationPreference = "Continue"

# LOG SCRIPT TO FILE (+ op het einde van het script Stop-Transcript doen):
# Start-Transcript "C:\ScriptLogs\2_InstallDCDNSlog.txt"

Write-host "Waiting 15 seconds before executing script" -ForeGroundColor "Green"
start-sleep -s 15 #Zorgen dat de server genoeg tijd heeft door 15 seconden te laten wachten.
Write-host "Starting script now:" -ForeGroundColor "Green"

# 1) Stel Datum/tijd correct in:
# Romance standard time = Brusselse tijd
Write-host "Setting correct timezone and time format settings:" -ForeGroundColor "Green"
Set-Culture -CultureInfo $Land
set-timezone -Name "Romance Standard Time"

# 2) Zorgen voor juist LAN adapter. Via intern netwerk.
Write-host "Changing NIC adapter names:" -ForeGroundColor "Green"
Get-NetAdapter -Name "Ethernet" | Rename-NetAdapter -NewName 'NAT'
Get-NetAdapter -Name "Ethernet 2" | Rename-NetAdapter -NewName $AdapterNaam

# 3) LAN adapter instellen
Write-host "Setting correct ipv4 settings:" -ForeGroundColor "Green"
New-NetIPAddress -InterfaceAlias "$AdapterNaam" -IPAddress "$IpAddress" -PrefixLength $CIDR

# 4) DNS van LAN van Alfa2 instellen op Hogent DNS servers:
# Eventueel commenten tijdens testen in demo omgeving
# Set-DnsClientServerAddress -InterfaceAlias "$AdapterNaam" -ServerAddress "$IpAlfa2","$IpAddress"
Set-DnsClientServerAddress -InterfaceAlias "NAT" -ResetServerAddresses
Set-DnsClientServerAddress -InterfaceAlias "$AdapterNaam" -ServerAddress "$IpAlfa2","$IpAddress"

# disable ipv6 on both nics
# Disable-NetAdaptorBinding -Name Internal, External -ComponentID ms_tcpip6

# 5) Installatie ADDS:
Write-host "Starting installation of ADDS role:" -ForeGroundColor "Green"
Install-WindowsFeature AD-domain-services -IncludeManagementTools
import-module ADDSDeployment

# 6) Idem aan het 1_RUNFIRST.ps1 script zal deze registry instelling ervoor zorgen dat ons volgende script automatisch wordt geladen
# Want het installeren van de ADDS role herstart automatisch onze server
# RunOnce verwijderd deze instelling automatisch nadat het script klaar is met runnen
# Set-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce' -Name ResumeScript `
                # -Value "C:\Windows\system32\WindowsPowerShell\v1.0\Powershell.exe -executionpolicy bypass -file `"$VBOXdrive\3_ConfigDCDNS.ps1`""

# 7) DSRM instellen
$creds = New-Object System.Management.Automation.PSCredential ("RED\Administrator", (ConvertTo-SecureString "Admin2019" -AsPlainText -Force))
$DSRM = ConvertTo-SecureString "Admin2019" -asPlainText -force

# 7.1) De eerste command zorgt ervoor dat je je als admin niet steeds moet inloggen wanneer je wijzigingen wil doen:
# set-itemproperty -Path "REGISTRY::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System" `
#                 -name "ConsentPromptBehaviorAdmin" -value 0
# Set-ItemProperty -Path "REGISTRY::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System" `
#                 -Name "FilterAdministratorToken" -value 1

# 8) Firewall uitschakelen
# Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False

# 9) Joinen van domein "red.local":
Write-host "Starting configuration of red.local domain:" -ForeGroundColor "Green"
install-ADDSDomainController -DomainName "red.local" `
                  -ReplicationSourceDC "Alfa2.red.local" `
                  -credential $creds `
                  -installDns `
                  -createDNSDelegation:$false `
                  -NoRebootOnCompletion:$true `
                  -SafeModeAdministratorPassword $DSRM `
                  -force:$true


# Stop-Transcript
