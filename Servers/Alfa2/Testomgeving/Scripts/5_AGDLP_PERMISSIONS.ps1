# Installatiescript dat de configuratie doet van de DNS (primary forward en reversed lookup zones maken + Forwarder):
                          # TODO: Eigenlijk kan dit script pas gestart worden vanaf dat lima2 volledig klaar is KLOPT DIT??????????????????????? TODO #
# Elke stap wordt uitgelegd met zijn eigen comment

# VARIABLES:
$VBOXdrive = "Z:"

$VerkoopData = "\\Lima2\VerkoopData\"
$OntwikkelingData = "\\Lima2\OntwikkelingData\"
$ITData = "\\Lima2\ITData\"
$DirData = "\\Lima2\DirData\"
$AdminData = "\\Lima2\AdminData\"
$ShareVerkoop = "\\Lima2\ShareVerkoop\"

$Homedirs = "\\Lima2\Homedirs\"
$Profiledirs = "\\Lima2\Profiledirs\"

# PREFERENCE VARIABLES: (Om Debug,Verbose en informaation info in de Start-Transcript log files te zien)
$DebugPreference = "Continue"
$VerbosePreference = "Continue"
$InformationPreference = "Continue"


# LOG SCRIPT TO FILE (+ op het einde van het script Stop-Transcript doen):
Start-Transcript "C:\ScriptLogs\5_AGDLP_PERMISSIONSlog.txt"

# 1) Map alle drives zodat Alfa2 toegang heeft tot de shared folders van Lima2:          TODO: MOET OOK IN SCCM TASK SEQUENCE VOOR DE CLIENTS (+ SMB 1.0/CIFS)
# net use [drive letter]: \\server\sharedFolder\    /P:yes = Maak mapping permanent
Write-Host "Mapping Shared folders of Lima2 to drive letters so Alfa2 has access to them:" -ForeGroundColor "Green"
net use d: $VerkoopData /P:Yes
net use e: $OntwikkelingData /P:Yes
net use f: $ITData /P:Yes
net use g: $DirpData /P:Yes
net use h: $AdminData /P:Yes
net use i: $ShareVerkoop /P:Yes

net use x: $Homedirs /P:Yes           # Y: drive in opgave
net use y: $Profiledirs /P:Yes        # Z: drive in opgave (was al bezet door VirtualBox shared folder)

# 2) Maak groupen (GLOBAL GROUPS) voor elke afdeling:
# Groepen aanmaken
Write-Host "Make AD Global Groups..." -ForeGroundColor "Green"
New-ADGroup -Name "Administratie" -Path "OU=Administratie,DC=red,DC=local" -GroupCategory "Security" -GroupScope "Global"
New-ADGroup -Name "Directie" -Path "OU=Directie,DC=red,DC=local" -GroupCategory "Security" -GroupScope "Global"
New-ADGroup -Name "Ontwikkeling" -Path "OU=Ontwikkeling,DC=red,DC=local" -GroupCategory "Security" -GroupScope "Global"
New-ADGroup -Name "Verkoop" -Path "OU=Verkoop,DC=red,DC=local" -GroupCategory "Security" -GroupScope "Global"
New-ADGroup -Name "IT_Administratie" -Path "OU=IT_Administratie,DC=red,DC=local" -GroupCategory "Security" -GroupScope "Global"

# 3) Domain local groups aanmaken waarop we de permissies toepassen:
# IT_Administratie heeft full control over alle shared folders
Write-Host "Make AD Localdomain groups (= permission groups)" -ForeGroundColor "Green"
New-ADGroup -Name "RW_VERKOOP" -Path "DC=red,DC=local" -GroupCategory "Security" -GroupScope "DomainLocal"
New-ADGroup -Name "RW_ONTWIKKELING" -Path "DC=red,DC=local" -GroupCategory "Security" -GroupScope "DomainLocal"
New-ADGroup -Name "RW_DIRECTIE" -Path "DC=red,DC=local" -GroupCategory "Security" -GroupScope "DomainLocal"
New-ADGroup -Name "RW_ADMIN" -Path "DC=red,DC=local" -GroupCategory "Security" -GroupScope "DomainLocal"

# IT DomainLocal group dat full permissies aan alle shares:
New-ADGroup -Name "FullAccess_IT" -Path "DC=red,DC=local" -GroupCategory "Security" -GroupScope "DomainLocal"

# Homedirs/profiledirs enkel zichtbaar voor de gebruiker die is aangemeld (de anderen niet):
New-ADGroup -Name "RW_HOMEDIRS" -Path "DC=red,DC=local" -GroupCategory "Security" -GroupScope "DomainLocal"
New-ADGroup -Name "RW_PROFILEDIRS" -Path "DC=red,DC=local" -GroupCategory "Security" -GroupScope "DomainLocal"

# TODO: NADENKEN OVER DE PERMISSIES HIERONDER + -Path overal correct invullen
New-ADGroup -Name "RW_SHAREVERKOOP" -Path "DC=red,DC=local" -GroupCategory "Security" -GroupScope "DomainLocal"


# 4) Voeg de Domain local groups toe als members juiste van de global groups:
Add-LocalGroupMember -Group "LOCAL_GROUP_HERE" -Member "MEMBERS_HERE(= global groups)", "MEMBER_2", "MEMBER_3" -

# 5) Geef de nodige permissies/rechten aan elke global group volgens de opdrachtomschrijving:
Write-Host "Assigning permissions to the domainlocal groups:" -ForeGroundColor "Green"
$ACL = Get-ACL "$Verkoopdata"
$VerkoopPermissions = New-Object System.Security.AccessControl.FileSystemAccessRule("username","FullControl","Allow")
$ACL.SetAccessRule($VerkoopPermissions)
Set-ACL "$Verkoopdata" $ACL

Stop-Transcript
