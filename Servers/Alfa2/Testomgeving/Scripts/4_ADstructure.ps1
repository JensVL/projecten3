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
$paswoordje=ConvertTo-SecureString "Admin2019" -asPlainText -force

Write-Host "Create users..." -ForeGroundColor "Green"
New-AdUser -Name "Kimberly" -Surname "De Clercq" -Department "Manager" -Description "Account voor Kimberly" -DisplayName "KimberlyDC" `
           -GivenName "Kimberly" -State "West-Vlaanderen"  -City "Ingelmunster" -PostalCode "8770" -EmailAddress "kimberly@red.local" `
           -Office "B0.001" -EmployeeID "1004" -HomePhone "0444727272" -Initials "KDC" -Path "OU=Directie,DC=red,DC=local" -AccountPassword $paswoordje

New-AdUser -Name "Laurens" -Surname "Blancquaert-Cassaer" -Department "IT_Administration" -Description "Account voor Laurens" -DisplayName "LaurensBC" `
           -GivenName "Laurens" -State "Oost-Vlaanderen" -City "Gent" -PostalCode "9000" -EmailAddress "laurens@red.local" `
           -Office "B4.037" -EmployeeID "2015" -HomePhone "0444727280" -Initials "LBC" -Path "OU=IT_Administratie,DC=red,DC=local" -AccountPassword $paswoordje

New-AdUser -Name "Pieter" -Surname "Blomme" -Department "IT_Administration" -Description "Account voor Pieter" -DisplayName "PieterB" `
           -GivenName "Laurens" -State "West-Vlaanderen" -City "Wervik" -PostalCode "8940" -EmailAddress "pieter@red.local" `
           -Office "B4.037" -EmployeeID "8425" -HomePhone "0444727281" -Initials "PB" -Path "OU=IT_Administratie,DC=red,DC=local" -AccountPassword $paswoordje

New-AdUser -Name "Jan" -Surname "Janssens" -Department "Development" -Description "Account voor Jan" -DisplayName "JanJ" `
           -GivenName "Jan" -State "Antwerpen" -City "Zoersel" -PostalCode "2980" -EmailAddress "jan@red.local" `
           -Office "B1.018" -EmployeeID "5078" -HomePhone "0444727290" -Initials "JJ" -Path "OU=Ontwikkeling,DC=red,DC=local" -AccountPassword $paswoordje

New-AdUser -Name "Jonas" -Surname "Vander Beken" -Department "Development" -Description "Account voor Jonas" -DisplayName "JonasVB" `
           -GivenName "Jan" -State "Vlaams-Brabant" -City "Bierbeek" -PostalCode "3360" -EmailAddress "jonas@red.local" `
           -Office "B1.018" -EmployeeID "1578" -HomePhone "0444727291" -Initials "JVB" -Path "OU=Ontwikkeling,DC=red,DC=local" -AccountPassword $paswoordje

New-AdUser -Name "Mieke" -Surname "Dobbels" -Department "Sale" -Description "Account voor Mieke" -DisplayName "MiekeD" `
           -GivenName "Mieke" -State "West-Vlaanderen" -City "Koksijde" -PostalCode "8670" -EmailAddress "mieke@red.local" `
           -Office "B0.015" -EmployeeID "4732" -HomePhone "0444727200" -Initials "MD" -Path "OU=Verkoop,DC=red,DC=local" -AccountPassword $paswoordje

New-AdUser -Name "Sandra" -Surname "Dewulf" -Department "Sale" -Description "Account voor Sandra" -DisplayName "SandraD" `
           -GivenName "Sandra" -State "West-Vlaanderen" -City "Torhout" -PostalCode "8820" -EmailAddress "sandra@red.local" `
           -Office "B0.015" -EmployeeID "5422" -HomePhone "0444727201" -Initials "SD" -Path "OU=Verkoop,DC=red,DC=local" -AccountPassword $paswoordje

New-AdUser -Name "Piet" -Surname "Pietersen" -Department "Administration" -Description "Account voor Piet" -DisplayName "PietP" `
            -GivenName "Piet" -State "Oost-Vlaanderen" -City "Sint-Martens-Latem" -Postalcode "9830" -EmailAddress "piet@red.local" `
            -Office "B4.002" -EmployeeID "2531" -HomePhone "0444727260" -Initials "PP" -Path "OU=Administratie,DC=red,DC=local" -AccountPassword $paswoordje

New-AdUser -Name "Tibo" -Surname "Vanhercke" -Department "Administration" -Description "Account voor Tibo" -DisplayName "TiboV" `
            -GivenName "Tibo" -State "West-Vlaanderen" -City "Ingooigem" -Postalcode "8570" -EmailAddress "tibo@red.local" `
            -Office "B4.002" -EmployeeID "2246" -HomePhone "0444727261" -Initials "TV" -Path "OU=Administratie,DC=red,DC=local" -AccountPassword $paswoordje

## Managers per groep toekennen
Write-Host "Allocate managers to OU's..." -ForeGroundColor "Green"
Set-ADOrganizationalUnit -Identity "OU=Verkoop,DC=red,DC=local" -ManagedBy "Mieke"
Set-ADOrganizationalUnit -Identity "OU=Ontwikkeling,DC=red,DC=local" -ManagedBy "Jan"
Set-ADOrganizationalUnit -Identity "OU=Directie,DC=red,DC=local" -ManagedBy "Kimberly"
Set-ADOrganizationalUnit -Identity "OU=Administratie,DC=red,DC=local" -ManagedBy "Piet"
Set-ADOrganizationalUnit -Identity "OU=IT_Administratie,DC=red,DC=local" -ManagedBy "Laurens"

## Manager toekennen aan elke user
Write-Host "Allocate manager ..." -ForeGroundColor "Green"
Set-ADUser -Identity "Laurens" -Manager "CN=Kimberly,OU=Directie,DC=red,DC=local"
Set-ADUser -Identity "Pieter" -Manager "CN=Laurens,OU=IT_Administratie,DC=red,DC=local"
Set-ADUser -Identity "Jan" -Manager "CN=Kimberly,OU=Directie,DC=red,DC=local"
Set-ADUser -Identity "Jonas" -Manager "CN=Jan,OU=Ontwikkeling,DC=red,DC=local"
Set-ADUser -Identity "Mieke" -Manager "CN=Kimberly,OU=Directie,DC=red,DC=local"
Set-ADUser -Identity "Sandra" -Manager "CN=Mieke,OU=Verkoop,DC=red,DC=local"
Set-ADUser -Identity "Piet" -Manager "CN=Kimberly,OU=Directie,DC=red,DC=local"
Set-ADUser -Identity "Tibo" -Manager "CN=Piet,OU=Administratie,DC=red,DC=local"

# Elk user-account unlocken.
Write-Host "Unlock accounts..." -ForeGroundColor "Green"
Enable-ADAccount -Identity "Kimberly"
Enable-ADAccount -Identity "Laurens"
Enable-ADAccount -Identity "Pieter"
Enable-ADAccount -Identity "Jan"
Enable-ADAccount -Identity "Jonas"
Enable-ADAccount -Identity "Mieke"
Enable-ADAccount -Identity "Sandra"
Enable-ADAccount -Identity "Piet"
Enable-ADAccount -Identity "Tibo"

# Computers
# Voeg minstens 5 werkstations toe (één in elke afdeling).
Write-Host "Create workstations..." -ForeGroundColor "Green"
New-ADComputer "Directie_001" -SamAccountName "Directie001" -Path "CN=Computers,DC=red,DC=local" -Enabled $True -Location "Gent,BE" -ManagedBy "Kimberly"
New-ADComputer "Administratie_001" -SamAccountName "Admin001" -Path "CN=Computers,DC=red,DC=local" -Enabled $True -Location "Gent,BE" -ManagedBy "Piet"
New-ADComputer "Administratie_002" -SamAccountName "Admin002" -Path "CN=Computers,DC=red,DC=local" -Enabled $True -Location "Gent,BE" -ManagedBy "Tibo"
New-ADComputer "Verkoop_001" -SamAccountName "Verkoop001" -Path "CN=Computers,DC=red,DC=local" -Enabled $True -Location "Gent,BE" -ManagedBy "Mieke"
New-ADComputer "Verkoop_002" -SamAccountName "Verkoop002" -Path "CN=Computers,DC=red,DC=local" -Enabled $True -Location "Gent,BE" -ManagedBy "Sandra"
New-ADComputer "Ontwikkeling_001" -SamAccountName "Ontwikkeling001" -Path "CN=Computers,DC=red,DC=local" -Enabled $True -Location "Gent,BE" -ManagedBy "Jan"
New-ADComputer "Ontwikkeling_002" -SamAccountName "Ontwikkeling002" -Path "CN=Computers,DC=red,DC=local" -Enabled $True -Location "Gent,BE" -ManagedBy "Jonas"
New-ADComputer "ITAdministratie_001" -SamAccountName "ITAdmin001" -Path "CN=Computers,DC=red,DC=local" -Enabled $True -Location "Gent,BE" -ManagedBy "Laurens"
New-ADComputer "ITAdministratie_002" -SamAccountName "ITAdmin002" -Path "CN=Computers,DC=red,DC=local" -Enabled $True -Location "Gent,BE" -ManagedBy "Pieter"

# Roaming profiles
Write-Host "Create a shared folder for roaming profiles..." -ForeGroundColor "Green"
New-Item -ItemType Directory -Name "Profiles" -Path "C:"
New-SmbShare -Path "C:\Profiles\" -Name "Profiles"

Write-Host "Modify folder permissions..." -ForeGroundColor "Green"
Grant-SmbShareAccess -Name "Profiles" -AccountName Everyone -AccesRight Full

Write-Host "Configure the profile path..." -ForeGroundColor "Green"
# TO DO: ProfilePath + Identity
Set-ADUser -Identity "Kimberly" -ProfilePath "\\dc01\profiles\%username%"

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
