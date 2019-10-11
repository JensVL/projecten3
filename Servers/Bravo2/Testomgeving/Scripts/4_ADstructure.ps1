# PREFERENCE VARIABLES: (Om Debug,Verbose en informaation info in de Start-Transcript log files te zien)
$DebugPreference = "Continue"
$VerbosePreference = "Continue"
$InformationPreference = "Continue"

Start-Transcript "C:\ScriptLogs\4_ADstructure.txt"
Import-Module ActiveDirectory

## Organizational Units aanmaken
Write-Host "Make Organizational Unit Verkoop..." -ForeGroundColor "Green"
New-ADOrganizationalUnit -Name "Verkoop" -Description "Organizational Unit voor Verkoop"
Write-Host "Make Organizational Unit Ontwikkeling..." -ForeGroundColor "Green"
New-ADOrganizationalUnit -Name "Ontwikkeling" -Description "Organizational Unit voor Ontwikkeling"
Write-Host "Make Organizational Unit Directie..." -ForeGroundColor "Green"
New-ADOrganizationalUnit -Name "Directie" -Description "Organizational Unit voor Directie"
Write-Host "Make Organizational Unit Administratie..." -ForeGroundColor "Green"
New-ADOrganizationalUnit -Name "Administratie" -Description "Organizational Unit voor Administratie"
Write-Host "Make Organizational Unit IT Administratie..." -ForeGroundColor "Green"
New-ADOrganizationalUnit -Name "IT_Administratie" -Description "Organizational Unit voor IT Administratie"

# Groepen aanmaken
Write-Host "Make AD Groups..." -ForeGroundColor "Green"
New-ADGroup -Name "Administratie" -DisplayName "Administratie" -Path "OU=Administratie,DC=red,DC=local" -GroupCategory Security -GroupScope Global
New-ADGroup -Name "Directie" -DisplayName "Directie" -Path "OU=Directie,DC=red,DC=local" -GroupCategory Security -GroupScope Global
New-ADGroup -Name "Ontwikkeling" -DisplayName "Ontwikkeling" -Path "OU=Ontwikkeling,DC=red,DC=local" -GroupCategory Security -GroupScope Global
New-ADGroup -Name "Verkoop" -DisplayName "Verkoop" -Path "OU=Verkoop,DC=red,DC=local" -GroupCategory Security -GroupScope Global
New-ADGroup -Name "IT_Administratie" -DisplayName "IT_Administratie" -Path "OU=IT_Administratie,DC=red,DC=local" -GroupCategory Security -GroupScope Global

# Gebruikers
# Er wordt telkens een gebruiker aangemaakt, specifiek de manager van elke Organizational Unit.
$paswoord=ConvertTo-SecureString "Admin2019" -asPlainText -force

Write-Host "Create users..." -ForeGroundColor "Green"
New-AdUser -Name "Van Nieuwenhove" -Surname "Arno" -Department "Manager" -Description "Account voor Arno" -DisplayName "ArnoVN" `
           -GivenName "Arno" -State "Oost-Vlaanderen"  -City "Ninove" -PostalCode "9404" -EmailAddress "arno@red.local" `
           -Office "B0.001" -EmployeeID "1003" -HomePhone "0444727273" -Initials "AVN" -Path "OU=Directie,DC=red,DC=local" -AccountPassword $paswoord

New-AdUser -Name "Goessens" -Surname "Levi" -Department "IT_Administration" -Description "Account voor Levi" -DisplayName "LeviG" `
           -GivenName "Levi" -State "Oost-Vlaanderen" -City "Denderwindeke" -PostalCode "9400" -EmailAddress "Levi@red.local" `
           -Office "B4.037" -EmployeeID "2014" -HomePhone "0444727284" -Initials "LG" -Path "OU=IT_Administratie,DC=red,DC=local" -AccountPassword $paswoord

New-AdUser -Name "Marckx" -Surname "Aron" -Department "IT_Administration" -Description "Account voor Pieter" -DisplayName "AronM" `
           -GivenName "Aron" -State "Oost-Vlaanderen" -City "Meldert" -PostalCode "9310" -EmailAddress "aron@red.local" `
           -Office "B4.037" -EmployeeID "8424" -HomePhone "0444727285" -Initials "AM" -Path "OU=IT_Administratie,DC=red,DC=local" -AccountPassword $paswoord

New-AdUser -Name "Van den Eede" -Surname "Cédric" -Department "Development" -Description "Account voor Cédric" -DisplayName "CedricVDE" `
           -GivenName "Cédric" -State "Antwerpen" -City "Zoersel" -PostalCode "2980" -EmailAddress "cedric@red.local" `
           -Office "B1.018" -EmployeeID "5078" -HomePhone "0444727294" -Initials "CVE" -Path "OU=Ontwikkeling,DC=red,DC=local" -AccountPassword $paswoord

New-AdUser -Name "Detemmerman" -Surname "Cedric" -Department "Development" -Description "Account voor Cedric" -DisplayName "CedricD" `
           -GivenName "Cedric" -State "Oost-Vlaanderen" -City "Haaltert" -PostalCode "3360" -EmailAddress "cedricd@red.local" `
           -Office "B1.018" -EmployeeID "1588" -HomePhone "0444727295" -Initials "CD" -Path "OU=Ontwikkeling,DC=red,DC=local" -AccountPassword $paswoord

New-AdUser -Name "Daelman" -Surname "Robby" -Department "Sale" -Description "Account voor Roby" -DisplayName "RobbyD" `
           -GivenName "Robby" -State "Oost-Vlaanderen" -City "Lede" -PostalCode "9340" -EmailAddress "robby@red.local" `
           -Office "B0.015" -EmployeeID "4736" -HomePhone "0444727220" -Initials "RD" -Path "OU=Verkoop,DC=red,DC=local" -AccountPassword $paswoord

New-AdUser -Name "Sandra" -Surname "Dewulf" -Department "Sale" -Description "Account voor Sandra" -DisplayName "SandraD" `
           -GivenName "Sandra" -State "West-Vlaanderen" -City "Torhout" -PostalCode "8820" -EmailAddress "sandra@red.local" `
           -Office "B0.015" -EmployeeID "5422" -HomePhone "0444727201" -Initials "SD" -Path "OU=Verkoop,DC=red,DC=local" -AccountPassword $paswoord

New-AdUser -Name "Piet" -Surname "Pietersen" -Department "Administration" -Description "Account voor Piet" -DisplayName "PietP" `
            -GivenName "Piet" -State "Oost-Vlaanderen" -City "Sint-Martens-Latem" -Postalcode "9830" -EmailAddress "piet@red.local" `
            -Office "B4.002" -EmployeeID "2531" -HomePhone "0444727260" -Initials "PP" -Path "OU=Administratie,DC=red,DC=local" -AccountPassword $paswoord

New-AdUser -Name "Tibo" -Surname "Vanhercke" -Department "Administration" -Description "Account voor Tibo" -DisplayName "TiboV" `
            -GivenName "Tibo" -State "West-Vlaanderen" -City "Ingooigem" -Postalcode "8570" -EmailAddress "tibo@red.local" `
            -Office "B4.002" -EmployeeID "2246" -HomePhone "0444727261" -Initials "TV" -Path "OU=Administratie,DC=red,DC=local" -AccountPassword $paswoord

## Managers per groep toekennen
Write-Host "Allocate managers to OU's..." -ForeGroundColor "Green"
Set-ADOrganizationalUnit -Identity "OU=Verkoop,DC=red,DC=local" -ManagedBy "Mieke"
Set-ADOrganizationalUnit -Identity "OU=Ontwikkeling,DC=red,DC=local" -ManagedBy "Jan"
Set-ADOrganizationalUnit -Identity "OU=Directie,DC=red,DC=local" -ManagedBy "Arno"
Set-ADOrganizationalUnit -Identity "OU=Administratie,DC=red,DC=local" -ManagedBy "Piet"
Set-ADOrganizationalUnit -Identity "OU=IT_Administratie,DC=red,DC=local" -ManagedBy "Levi"

## Manager toekennen aan elke user
Write-Host "Allocate manager ..." -ForeGroundColor "Green"
Set-ADUser -Identity "Levi" -Manager "CN=Arno,OU=Directie,DC=red,DC=local"
Set-ADUser -Identity "Pieter" -Manager "CN=Levi,OU=IT_Administratie,DC=red,DC=local"
Set-ADUser -Identity "Jan" -Manager "CN=Arno,OU=Directie,DC=red,DC=local"
Set-ADUser -Identity "Jonas" -Manager "CN=Jan,OU=Ontwikkeling,DC=red,DC=local"
Set-ADUser -Identity "Mieke" -Manager "CN=Arno,OU=Directie,DC=red,DC=local"
Set-ADUser -Identity "Sandra" -Manager "CN=Mieke,OU=Verkoop,DC=red,DC=local"
Set-ADUser -Identity "Piet" -Manager "CN=Arno,OU=Directie,DC=red,DC=local"
Set-ADUser -Identity "Tibo" -Manager "CN=Piet,OU=Administratie,DC=red,DC=local"

# Elk user-account unlocken.
Write-Host "Unlock accounts..." -ForeGroundColor "Green"
Enable-ADAccount -Identity "Arno"
Enable-ADAccount -Identity "Levi"
Enable-ADAccount -Identity "Pieter"
Enable-ADAccount -Identity "Jan"
Enable-ADAccount -Identity "Jonas"
Enable-ADAccount -Identity "Mieke"
Enable-ADAccount -Identity "Sandra"
Enable-ADAccount -Identity "Piet"
Enable-ADAccount -Identity "Tibo"

# Computers
# Voeg minstens 5 werkstations toe (��n in elke afdeling).
Write-Host "Create workstations..." -ForeGroundColor "Green"
New-ADComputer "Directie_001" -SamAccountName "Directie001" -Path "CN=Computers,DC=red,DC=local" -Enabled $True -Location "Gent,BE" -ManagedBy "Arno"
New-ADComputer "Administratie_001" -SamAccountName "Admin001" -Path "CN=Computers,DC=red,DC=local" -Enabled $True -Location "Gent,BE" -ManagedBy "Piet"
New-ADComputer "Administratie_002" -SamAccountName "Admin002" -Path "CN=Computers,DC=red,DC=local" -Enabled $True -Location "Gent,BE" -ManagedBy "Tibo"
New-ADComputer "Verkoop_001" -SamAccountName "Verkoop001" -Path "CN=Computers,DC=red,DC=local" -Enabled $True -Location "Gent,BE" -ManagedBy "Mieke"
New-ADComputer "Verkoop_002" -SamAccountName "Verkoop002" -Path "CN=Computers,DC=red,DC=local" -Enabled $True -Location "Gent,BE" -ManagedBy "Sandra"
New-ADComputer "Ontwikkeling_001" -SamAccountName "Ontwikkeling001" -Path "CN=Computers,DC=red,DC=local" -Enabled $True -Location "Gent,BE" -ManagedBy "Jan"
New-ADComputer "Ontwikkeling_002" -SamAccountName "Ontwikkeling002" -Path "CN=Computers,DC=red,DC=local" -Enabled $True -Location "Gent,BE" -ManagedBy "Jonas"
New-ADComputer "ITAdministratie_001" -SamAccountName "ITAdmin001" -Path "CN=Computers,DC=red,DC=local" -Enabled $True -Location "Gent,BE" -ManagedBy "Levi"
New-ADComputer "ITAdministratie_002" -SamAccountName "ITAdmin002" -Path "CN=Computers,DC=red,DC=local" -Enabled $True -Location "Gent,BE" -ManagedBy "Pieter"

# Roaming profiles
Write-Host "Create a shared folder for roaming profiles..." -ForeGroundColor "Green"
New-Item -ItemType Directory -Name "Profiles" -Path "C:"
New-SmbShare -Path "C:\Profiles\" -Name "Profiles"

Write-Host "Modify folder permissions..." -ForeGroundColor "Green"
Grant-SmbShareAccess -Name "Profiles" -AccountName Everyone -AccesRight Full

Write-Host "Configure the profile path..." -ForeGroundColor "Green"
# TO DO: ProfilePath + Identity
Set-ADUser -Identity "Arno" -ProfilePath "\\dc02\profiles\%username%"

## Group policy
# Verbied iedereen uit alle afdelingen behalve IT Administratie de toegang tot het control panel
Write-Host "Forbid everyone from all departments except IT Administration access to the control panel..." -ForeGroundColor "Green"
New-GPO "DisablingControlPanel" | New-GPLink -Target "OU=Administratie,dc=red,dc=local"
New-GPLink "DisablingControlPanel" -Target "OU=Verkoop,DC=red,dc=local"
New-GPLink "DisablingControlPanel" -Target "OU=Ontwikkeling,DC=red,dc=local"
New-GPLink "DisablingControlPanel" -Target "OU=Directie,DC=red,dc=local"
$GPOSession = Open-NetGPO -PolicyStore "red.local\DisablingControlPanel"

## TO DO: Group policy
# Import the settings from the latest backup to another directory in the same domain
Import-GPO -BackupId "A491D730-F3ED-464C-B8C9-F50562C536AA" -TargetName "BackupGPO" -path "c:\backups" -CreateIfNeeded
# Import the settings from specified backup in the same directory in the same domain
Import-GPO -BackupGPOName "BackupGPO" -Path "D:\Backups" -TargetName "BackupGPO" -MigrationTable "D:\Tables\Migtable1.migtable" -CreateIfNeeded

# Verwijder het games link menu uit het start menu voor alle afdelingen
Write-Host "Remove the games link menu from the start menu..." -ForeGroundColor "Green"
New-GPO "DisablingGameLink" | New-GPLink -Target "OU=IT_Administratie,dc=red,dc=local"
New-GPLink "DisablingGameLink" -Target "OU=Verkoop,dc=red,dc=local"
New-GPLink "DisablingGameLink" -Target "OU=Ontwikkeling,dc=red,dc=local"
New-GPLink "DisablingGameLink" -Target "OU=Administratie,dc=red,dc=local"
New-GPLink "DisablingGameLink" -Target "OU=Directie,dc=red,dc=local"
$GPOSession = Open-NetGPO -PolicyStore "red.local\DisablingGameLink"

# Verbied iedereen uit de afdelingen Administratie en Verkoop de toegang tot de eigenschappen van de netwerkadapters
Write-Host "Forbid everyone from the Administration and Sales departments access to the properties of the network adapters..." -ForeGroundColor "Green"
New-GPO "DisableNetwerkadapters" | New-GPLink -Target "OU=Administratie,dc=red,dc=local"
New-GPLink "DisableNetwerkadapters" -Target "OU=Verkoop,DC=red,DC=local"
$GPOSession = Open-NetGPO -PolicyStore "red.local\DisableNetwerkadapters"

Copy-NetFirewallRule -Name ""

Save-NetGPO -GPOSession $GPOSession

# New-GPLink -Name "Control Panel" -Target "OU=Verkoop,dc=red,dc=local" -LinkEnabled Yes -Enforced Yes

## Juiste toegangsgroepen voor de fileserver (Modify/Read/Full) en voeg de juiste personen en/of groepen toe
Set-GPPermission -Name "DisablingControlPanel" -TargetName "Users" -TargetType "Group" -PermissionLevel "GPORead"

Stop-Transcript