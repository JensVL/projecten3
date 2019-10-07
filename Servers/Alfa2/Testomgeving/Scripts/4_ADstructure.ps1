Start-Transcript "C:\ScriptLogs\4_ADstructure.txt"
Import-Module ActiveDirectory

## Groepen
Write-Host "Make Organizational Unit Verkoop..." 
New-ADOrganizationalUnit "Verkoop" -Discription "Organizational Unit voor Verkoop" -ManagedBy "Mieke"

Write-Host "Make Organizational Unit Ontwikkeling..."
New-ADOrganizationalUnit "Ontwikkeling" -Discription "Organizational Unit voor Ontwikkeling" -ManagedBy  "Jan"

Write-Host "Make Organizational Unit Directie..."
New-ADOrganizationalUnit "Directie" -Discription "Organizational Unit voor Directie" -ManagedBy "Kimberly"

Write-Host "Make Organizational Unit Administratie..."
New-ADOrganizationalUnit -Name "Administratie" -Discription "Organizational Unit voor Administratie" -ManagedBy "Piet"

# Sub OU
Write-Host "Make Organizational Units in OU Administratie..."
New-ADOrganizationalUnit "IT Administratie" –Path "OU=Administratie,DC=red,DC=local" -Discription "Organizational Unit voor IT Administratie" -ManagedBy "Laurens"
New-ADOrganizationalUnit "Accounting Administratie" –Path "OU=Administratie,DC=red,DC=local" -Discription "Organizational Unit voor Accounting Administratie"  -ManagedBy "Tibo"
New-ADOrganizationalUnit "Productie Administratie" –Path "OU=Administratie,DC=red,DC=local" -Discription "Organizational Unit voor Productie Administratie" -ManagedBy "Dieter"

# Groepen aanmaken
Write-Host "Make AD Groups..."
New-ADGroup "Administratie" -DisplayName "Administratie", -Path "OU=Administratie,DC=red,DC=local", -GroupCategory "Security", -GroupScope "Global"
New-ADGroup "Administratie" -DisplayName "Directie", -Path "OU=Directie,DC=red,DC=local", -GroupCategory "Security", -GroupScope "Global"
New-ADGroup "Administratie" -DisplayName "Ontwikkeling", -Path "OU=Ontwikkeling,DC=red,DC=local", -GroupCategory "Security", -GroupScope "Global"
New-ADGroup "Administratie" -DisplayName "Verkoop", -Path "OU=Verkoop,DC=red,DC=local", -GroupCategory "Security", -GroupScope "Global"

Write-Host "Make AD Sub-Groups..."
New-ADGroup "Administratie" -DisplayName "IT Administratie", -Path "OU=Administratie,OU=IT Administratie, DC=red,DC=local", -GroupCategory "Security", -GroupScope "Global"
New-ADGroup "Administratie" -DisplayName "Productie Administratie", -Path "OU=Administratie,OU=Productie Administratie, DC=red,DC=local", -GroupCategory "Security", -GroupScope "Global"
New-ADGroup "Administratie" -DisplayName "Accounting Administratie", -Path "OU=Administratie,OU=Accounting Administratie, DC=red,DC=local", -GroupCategory "Security", -GroupScope "Global"

# Gebruikers 
# Er wordt telkens een gebruiker aangemaakt, specifiek de manager van elke Organizational Unit. 
$paswoordje=ConverTo-SecureString "Admin2019" -asPlainText -force

Write-Host "Create users..."
New-AdUser -Name "Kimberly" -Surname "De Clercq" -Department "Manager" -Description "Account voor Kimberly" -DisplayName "KimberlyDC" `
           -GivenName "Kimberly" -State "West-Vlaanderen"  -City "Ingelmunster" -PostalCode "8770" -EmailAddress "kimberly@red.local" `
           -Office "B0.001" -EmployeeID "1004" -HomePhone "0444727272" -Initials "KDC" -Path "OU=Users,OU=Directie,DC=red,DC=local" -AccountPassword $paswoordje

New-AdUser -Name "Laurens" -Surname "Blancquaert-Cassaer" -Department "IT Administration" -Description "Account voor Laurens" -DisplayName "LaurensBC" `
           -GivenName "Laurens" -State "Oost-Vlaanderen" -City "Gent" -PostalCode "9000" -EmailAddress "laurens@red.local" `
           -Office "B4.037" -EmployeeID "2015" -HomePhone "0444727281" -Initials "LBC" -Path "OU=Users,OU=Administratie,OU=IT Administratie,DC=red,DC=local" -AccountPassword $paswoordje

New-AdUser -Name "Jan" -Surname "Janssens" -Department "Development" -Description "Account voor Jan" -DisplayName "JanJ" `
           -GivenName "Jan" -State "Antwerpen" -City "Zoersel" -PostalCode "2980" -EmailAddress "jan@red.local" `
           -Office "B1.018" -EmployeeID "5078" -HomePhone "0444727280" -Initials "JJ" -Path "OU=Users,OU=Ontwikkeling,DC=red,DC=local" -AccountPassword $paswoordje

New-AdUser -Name "Mieke" -Surname "Dobbels" -Department "Sale" -Description "Account voor Mieke" -DisplayName "MiekeD" `
           -GivenName "Mieke" -State "West-Vlaanderen" -City "Koksijde" -PostalCode "8670" -EmailAddress "mieke@red.local" `
           -Office "B0.015" -EmployeeID "4245" -HomePhone "0444727275" -Initials "MD" -Path "OU=Users,OU=Verkoop,DC=red,DC=local" -AccountPassword $paswoordje

New-AdUser -Name "Piet" -Surname "Pietersen" -Department "Administration" -Description "Account voor Piet" -DisplayName "PietP" `
            -GivenName "Piet" -State "Oost-Vlaanderen" -City "Sint-Martens-Latem" -Postalcode "9830" -EmailAddress "piet@red.local" `
            -Office "B4.002" -EmployeeID "2531" -HomePhone "0444727280" -Initials "PP" -Path "OU=Users,OU=Administratie,DC=red,DC=local" -AccountPassword $paswoordje

New-AdUser -Name "Tibo" -Surname "Vanhercke" -Department "Accounting Administration" -Description "Account voor Tibo" -DisplayName "TiboV" `
            -GivenName "Tibo" -State "Oost-Vlaanderen" -City "Gent" -Postalcode "9000" -EmailAddress "tibo@red.local" `
            -Office "B4.012" -EmployeeID "2246" -HomePhone "0444727282" -Initials "TV" -Path "OU=Users,OU=Administratie,OU=Accounting Administratie,DC=red,DC=local" -AccountPassword $paswoordje

New-AdUser -Name "Dieter" -Surname "Vanderbeken" -Department "Productie Administration" -Description "Account voor Dieter" -DisplayName "DieterV" `
            -GivenName "Dieter" -State "Oost-Vlaanderen" -City "Gent" -Postalcode "9000" -EmailAddress "dieter@red.local" `
            -Office "B4.022" -EmployeeID "2246" -HomePhone "0444727283" -Initials "DV" -Path "OU=Users,OU=Administratie,OU=Productie Administratie,DC=red,DC=local" -AccountPassword $paswoordje

## Manager toekennen aan elke user
Write-Host "Allocate manager ..."
Set-ADUser -Identity "Laurens" -Manager "CN=Kimberly,OU=Directie,DC=red,DC=local"
Set-ADUser -Identity "Jan" -Manager "CN=Kimberly,OU=Directie,DC=red,DC=local"
Set-ADUser -Identity "Mieke" -Manager "CN=Kimberly,OU=Directie,DC=red,DC=local"
Set-ADUser -Identity "Piet" -Manager "CN=Kimberly,OU=Directie,DC=red,DC=local"
Set-ADUser -Identity "Tibo" -Manager "CN=Kimberly,OU=Directie,DC=red,DC=local"
Set-ADUser -Identity "Dieter" -Manager "CN=Kimberly,OU=Directie,DC=red,DC=local"

# Elk user-account unlocken. 
Write-Host "Unlock accounts..."
Enable-ADAccount -Identity "Kimberly"
Enable-ADAccount -Identity "Laurens"
Enable-ADAccount -Identity "Jan"
Enable-ADAccount -Identity "Mieke"
Enable-ADAccount -Identity "Piet"
Enable-ADAccount -Identity "Tibo"
Enable-ADAccount -Identity "Dieter"

# Computers
# Voeg minstens 5 werkstations toe (één in elke afdeling). 
Write-Host "Create workstations..."
# Hoe moeten de werkstations heetten?
New-ADComputer "Alfa2" -SamAccountName "Alfa2-SRV1" -Path "OU=Computers,OU=Administratie,DC=red,DC=local"

Write-Host "Create workstation for Administratie..."
New-ADComputer "Admin001" -SamAccountName "Admin001-SRV1" -Path "OU=Computers,OU=Administratie,DC=red,DC=local"

Write-Host "Create workstation for IT Administratie..."
New-ADComputer "ITAdmin001" -SamAccountName "ITAdmin001-SRV1" -Path "OU=Computers,OU=Adminsitratie,OU=IT Administratie,DC=red,DC=local" -Enabled $True -Location "Gent,BE"

Write-Host "Create workstation for Accounting Administratie..."
New-ADComputer "ACCAdmin001" -SamAccountName "ITAdmin001-SRV1" -Path "OU=Computers,OU=Adminsitratie,OU=Accounting Administratie,DC=red,DC=local" -Enabled $True -Location "Gent,BE"

Write-Host "Create workstation for Productie Administratie..."
New-ADComputer "ProdAdmin001" -SamAccountName "ITAdmin001-SRV1" -Path "OU=Computers,OU=Adminsitratie,OU=Productie Administratie,DC=red,DC=local" -Enabled $True -Location "Gent,BE"

Write-Host "Create workstation for Verkoop..."
New-ADComputer "Verkoop001" -SamAccountName "Verkoop001-SRV1" -Path "OU=Computers,OU=Verkoop,DC=red,DC=local"

Write-Host "Create workstation for Ontwikkeling..."
New-ADComputer "Ontwikkeling001" -SamAccountName "Ontwikkeling001-SRV1" -Path "OU=Computers,OU=Ontwikkeling,DC=red,DC=local"

Write-Host "Create workstation for Directie..."
New-ADComputer "Directie001" -SamAccountName "Directie001-SRV1" -Path "OU=Computers,OU=Directie,DC=red,DC=local"

# Roaming profiles
Write-Host "Create a shared folder for roaming profiles..."
New-Item -ItemType Directory -Name "Profiles" -Path "C:"
New-SmbShare -Path "C:\Profiles\" -Name "Profiles"

Write-Host "Modify folder permissions..."
Grant-SmbShareAccess -Name "Profiles" -AccountName Everyone -AccesRight Full

Write-Host "Configure the profile path..."
# TO DO: ProfilePath + Identity
Set-ADUser -Identity Kimberly -ProfilePath "\\dc01\profiles\%username%"

## Group policy
# Verbied iedereen uit alle afdelingen behalve IT Administratie de toegang tot het control panel
New-GPO "DisablingControlPanel" | New-GPLink -Target "OU=Users,OU=Administratie,OU=IT Administratie,dc=red,dc=local" 
New-GPLink "DisablingControlPanel" -Target "OU,Users,OU=Verkoop,DC=red,dc=local"
New-GPLink "DisablingControlPanel" -Target "OU,Users,OU=Ontwikkeling,DC=red,dc=local"
New-GPLink "DisablingControlPanel" -Target "OU,Users,OU=Directie,DC=red,dc=local"
$GPOSession = Open-NetGPO -PolicyStore "red.local\DisablingControlPanel"

## TO DO: Group policy 
# Import the settings from the latest backup to another directory in the same domain
Import-GPO -BackupId "A491D730-F3ED-464C-B8C9-F50562C536AA" -TargetName "BackupGPO" -path "c:\backups" -CreateIfNeeded 
# Import the settings from specified backup in the same directory in the same domain
Import-GPO -BackupGPOName "BackupGPO" -Path "D:\Backups" -TargetName "BackupGPO" -MigrationTable "D:\Tables\Migtable1.migtable" -CreateIfNeeded 

# Verwijder het games link menu uit het start menu voor alle afdelingen
New-GPO "DisablingGameLink" | New-GPLink -Target "OU=Users,OU=Administratie,OU=IT Administratie,dc=red,dc=local" 
New-GPLink "DisablingGameLink" -Target "OU=Users,OU=Verkoop,dc=red,dc=local" 
New-GPLink "DisablingGameLink" -Target "OU=Users,OU=Ontwikkeling,dc=red,dc=local" 
New-GPLink "DisablingGameLink" -Target "OU=Users,OU=Administratie,dc=red,dc=local" 
New-GPLink "DisablingGameLink" -Target "OU=Users,OU=Directie,dc=red,dc=local" 
$GPOSession = Open-NetGPO -PolicyStore "red.local\DisablingGameLink"

# Verbied iedereen uit de afdelingen Administratie en Verkoop de toegang tot de eigenschappen van de netwerkadapters
New-GPO "DisableNetwerkadapters" | New-GPLink -Target "OU=Users,OU=Administratie,dc=red,dc=local" 
New-GPLink "DisableNetwerkadapters" -Target "OU=Users,OU=Verkoop,DC=red,DC=local"
$GPOSession = Open-NetGPO -PolicyStore "red.local\DisableNetwerkadapters"

Copy-NetFirewallRule -Name ""

Save-NetGPO -GPOSession $GPOSession

# New-GPLink -Name "Control Panel" -Target "OU=Verkoop,dc=red,dc=local" -LinkEnabled Yes -Enforced Yes

## Juiste toegangsgroepen voor de fileserver (Modify/Read/Full) en voeg de juiste personen en/of groepen toe
Set-GPPermission -Name "DisablingControlPanel" -TargetName "Users" -TargetType "Group" -PermissionLevel "GPORead"

Stop-Transcript