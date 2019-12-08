#------------------------------------------------------------------------------
# Description
#------------------------------------------------------------------------------
# Installatiescript dat zorgt voor het aanmaken van de OU's
# en de gebruikeraccounts

#------------------------------------------------------------------------------
# Variables
#------------------------------------------------------------------------------
# VOOR INTEGRATIE:
$VBOXdrive = "C:\Scripts_ESXI\Alfa2"

# VOOR VIRTUALBOX TESTING:
#$VBOXdrive = "Z:"

Start-Transcript "C:\ScriptLogs\4_ADstructure.txt"
Import-Module ActiveDirectory

## Organizational Units aanmaken
function make_ou() {
    param(
        [string]$ou_name
    )
    $ou_exists=[adsi]::Exists("LDAP://OU=$ou_name,DC=red,DC=local")
    if(!($ou_exists)) {
        Write-Host ">>> Make Organizational Unit $ou_name" -ForegroundColor "Green"
        New-ADOrganizationalUnit -Name $ou_name -Description "Organizational Unit voor $ou_name"
    }
    else {
        Write-Warning "OU $ou_name already exists (skipping)"
    }
}
make_ou "Verkoop"
make_ou "Ontwikkeling"
make_ou "Administratie"
make_ou "IT_Administratie"
make_ou "Directie"

# Groepen aanmaken
function make_group() {
    Param(
        [string]$group_name
    )
    $group_exists = [adsi]::Exists("LDAP://CN=$group_name,OU=$group_name,DC=red,DC=local")

    if(!($group_exists)) {
        Write-Host ">>> Make AD Group $group_name" -ForegroundColor "Green"
        New-ADGroup -Name $group_name -DisplayName $group_name -Path "OU=$group_name,DC=red,DC=local" -GroupCategory Security -GroupScope Global
    }
    else {
        Write-Warning "Group $group_name already exists (skipping)"
    }
}
make_group "Verkoop"
make_group "Ontwikkeling"
make_group "Administratie"
make_group "IT_Administratie"
make_group "Directie"

# Gebruikers
Write-Host "Create users for Organizational Units..." -ForeGroundColor "Green"

$password=ConvertTo-SecureString "Administrator2019" -asPlainText -force

<# Path wanneer je via een share werkt in VirtualBox en niet met vagrant
Import-Csv -Path "\\VBOXSVR\Scripts\ExtendADschema\users3.csv" | Foreach-Object {
#>
Import-Csv -Path "$VBOXdrive\ExtendADschema\users3.csv" | ForEach-Object {
    $sambaname=$_.SamAccountName

    $user_exists=(([ADSISearcher] "(SamAccountName=$sambaname)").FindOne())

    # User does not exist so make it
    # Email wordt aangemaakt bij charlie2 met de SamAccountName: -EmailAddress $_.EmailAddress `
    if (!$user_exists) {
            Write-Host ">>> Add user '$($_.Firstname)'" -ForegroundColor "Green"
            New-ADUser -Name $_.Firstname `
                       -Surname $_.Lastname `
                       -SamAccountName $_.SamAccountName `
                       -Department $_.Department `
                       -Description $_.Description `
                       -DisplayName $_.DisplayName `
                       -GivenName $_.Givenname `
                       -State $_.State `
                       -City $_.City `
                       -PostalCode $_.PostalCode `
                       -Office $_.Office `
                       -EmployeeID $_.EmployeeID `
                       -HomePhone $_.Phone `
                       -Initials $_.Initials `
                       -Path $_.Path `
                       -AccountPassword $password
    }
    else {
        Write-Warning "User $sambaname already exists (skipping)"
    }
}

# Managers per groep toekennen
Write-Host "Allocate managers to groups..." -ForeGroundColor "Green"
Set-ADGroup -Identity "CN=Administratie,OU=Administratie,DC=red,DC=local" -ManagedBy "CN=Joachim,OU=Administratie,DC=red,DC=local"
Set-ADGroup -Identity "CN=Directie,OU=Directie,DC=red,DC=local" -ManagedBy "CN=Kimberly,OU=Directie,DC=red,DC=local"
Set-ADGroup -Identity "CN=Ontwikkeling,OU=Ontwikkeling,DC=red,DC=local" -ManagedBy "CN=Jannes,OU=Ontwikkeling,DC=red,DC=local"
Set-ADGroup -Identity "CN=Verkoop,OU=Verkoop,DC=red,DC=local" -ManagedBy "CN=Matthias,OU=Verkoop,DC=red,DC=local"
Set-ADGroup -Identity "CN=IT_Administratie,OU=IT_Administratie,DC=red,DC=local" -ManagedBy "CN=Laurens,OU=IT_Administratie,DC=red,DC=local"

# Groepmembers maken
Write-Host "Add members to groups..." -ForeGroundColor "Green"
Add-ADGroupMember -Identity "CN=Directie,OU=Directie,DC=red,DC=local" -Members "CN=Kimberly,OU=Directie,DC=red,DC=local", "CN=Arno,OU=Directie,DC=red,DC=local"
Add-ADGroupMember -Identity "CN=Administratie,OU=Administratie,DC=red,DC=local" -Members "CN=Joachim,OU=Administratie,DC=red,DC=local", "CN=Tibo,OU=Administratie,DC=red,DC=local", "CN=Yngvar,OU=Administratie,DC=red,DC=local", "CN=Tim,OU=Administratie,DC=red,DC=local", "CN=Rik,OU=Administratie,DC=red,DC=local"
Add-ADGroupMember -Identity "CN=IT_Administratie,OU=IT_Administratie,DC=red,DC=local" -Members "CN=Laurens,OU=IT_Administratie,DC=red,DC=local", "CN=Ferre,OU=IT_Administratie,DC=red,DC=local", "CN=Levi,OU=IT_Administratie,DC=red,DC=local", "CN=Aron,OU=IT_Administratie,DC=red,DC=local", "CN=Jens,OU=IT_Administratie,DC=red,DC=local"
Add-ADGroupMember -Identity "CN=Verkoop,OU=Verkoop,DC=red,DC=local" -Members "CN=Matthias,OU=Verkoop,DC=red,DC=local", "CN=Robby,OU=Verkoop,DC=red,DC=local", "CN=Nathan,OU=Verkoop,DC=red,DC=local", "CN=Elias,OU=Verkoop,DC=red,DC=local", "CN=Alister,OU=Verkoop,DC=red,DC=local", "CN=Sean,OU=Verkoop,DC=red,DC=local"
Add-ADGroupMember -Identity "CN=Ontwikkeling,OU=Ontwikkeling,DC=red,DC=local" -Members "CN=Jannes,OU=Ontwikkeling,DC=red,DC=local", "CN=Jonas,OU=Ontwikkeling,DC=red,DC=local", "CN=CedricVDE,OU=Ontwikkeling,DC=red,DC=local", "CN=CedricD,OU=Ontwikkeling,DC=red,DC=local", "CN=Robin,OU=Ontwikkeling,DC=red,DC=local"

# Managers per OU toekennen
Write-Host "Allocate managers to OU's..." -ForeGroundColor "Green"
Set-ADOrganizationalUnit -Identity "OU=Verkoop,DC=red,DC=local" -ManagedBy "CN=Matthias,OU=Verkoop,DC=red,DC=local"
Set-ADOrganizationalUnit -Identity "OU=Ontwikkeling,DC=red,DC=local" -ManagedBy "CN=Jannes,OU=Ontwikkeling,DC=red,DC=local"
Set-ADOrganizationalUnit -Identity "OU=Directie,DC=red,DC=local" -ManagedBy "CN=Kimberly,OU=Directie,DC=red,DC=local"
Set-ADOrganizationalUnit -Identity "OU=Administratie,DC=red,DC=local" -ManagedBy "CN=Joachim,OU=Administratie,DC=red,DC=local"
Set-ADOrganizationalUnit -Identity "OU=IT_Administratie,DC=red,DC=local" -ManagedBy "CN=Laurens,OU=IT_Administratie,DC=red,DC=local"

# Manager toekennen aan elke user
Write-Host "Allocate manager OU Directie Kimberly..." -ForeGroundColor "Green"
Set-ADUser -Identity "CN=Laurens,OU=IT_Administratie,DC=red,DC=local" -Manager "CN=Kimberly,OU=Directie,DC=red,DC=local"
Set-ADUser -Identity "CN=Joachim,OU=Administratie,DC=red,DC=local" -Manager "CN=Kimberly,OU=Directie,DC=red,DC=local"
Set-ADUser -Identity "CN=Jannes,OU=Ontwikkeling,DC=red,DC=local" -Manager "CN=Kimberly,OU=Directie,DC=red,DC=local"
Set-ADUser -Identity "CN=Matthias,OU=Verkoop,DC=red,DC=local" -Manager "CN=Kimberly,OU=Directie,DC=red,DC=local"
Set-ADUser -Identity "CN=Arno,OU=Directie,DC=red,DC=local" -Manager "CN=Kimberly,OU=Directie,DC=red,DC=local"

Write-Host "Allocate manager OU IT_Administratie Laurens..." -ForeGroundColor "Green"
Set-ADUser -Identity "CN=Ferre,OU=IT_Administratie,DC=red,DC=local" -Manager "CN=Laurens,OU=IT_Administratie,DC=red,DC=local"
Set-ADUser -Identity "CN=Levi,OU=IT_Administratie,DC=red,DC=local" -Manager "CN=Laurens,OU=IT_Administratie,DC=red,DC=local"
Set-ADUser -Identity "CN=Aron,OU=IT_Administratie,DC=red,DC=local" -Manager "CN=Laurens,OU=IT_Administratie,DC=red,DC=local"
Set-ADUser -Identity "CN=Jens,OU=IT_Administratie,DC=red,DC=local" -Manager "CN=Laurens,OU=IT_Administratie,DC=red,DC=local"

Write-Host "Allocate manager OU Administratie Joachim..." -ForeGroundColor "Green"
Set-ADUser -Identity "CN=Tibo,OU=Administratie,DC=red,DC=local" -Manager "CN=Joachim,OU=Administratie,DC=red,DC=local"
Set-ADUser -Identity "CN=Yngvar,OU=Administratie,DC=red,DC=local" -Manager "CN=Joachim,OU=Administratie,DC=red,DC=local"
Set-ADUser -Identity "CN=Tim,OU=Administratie,DC=red,DC=local" -Manager "CN=Joachim,OU=Administratie,DC=red,DC=local"
Set-ADUser -Identity "CN=Rik,OU=Administratie,DC=red,DC=local" -Manager "CN=Joachim,OU=Administratie,DC=red,DC=local"

Write-Host "Allocate manager OU Ontwikkeling Jannes..." -ForeGroundColor "Green"
Set-ADUser -Identity "CN=Jonas,OU=Ontwikkeling,DC=red,DC=local" -Manager "CN=Jannes,OU=Ontwikkeling,DC=red,DC=local"
Set-ADUser -Identity "CN=CedricVDE,OU=Ontwikkeling,DC=red,DC=local" -Manager "CN=Jannes,OU=Ontwikkeling,DC=red,DC=local"
Set-ADUser -Identity "CN=CedricD,OU=Ontwikkeling,DC=red,DC=local" -Manager "CN=Jannes,OU=Ontwikkeling,DC=red,DC=local"
Set-ADUser -Identity "CN=Robin,OU=Ontwikkeling,DC=red,DC=local" -Manager "CN=Jannes,OU=Ontwikkeling,DC=red,DC=local"

Write-Host "Allocate manager OU Verkoop Matthias..." -ForeGroundColor "Green"
Set-ADUser -Identity "CN=Robby,OU=Verkoop,DC=red,DC=local" -Manager "CN=Matthias,OU=Verkoop,DC=red,DC=local"
Set-ADUser -Identity "CN=Nathan,OU=Verkoop,DC=red,DC=local" -Manager "CN=Matthias,OU=Verkoop,DC=red,DC=local"
Set-ADUser -Identity "CN=Elias,OU=Verkoop,DC=red,DC=local" -Manager "CN=Matthias,OU=Verkoop,DC=red,DC=local"
Set-ADUser -Identity "CN=Alister,OU=Verkoop,DC=red,DC=local" -Manager "CN=Matthias,OU=Verkoop,DC=red,DC=local"
Set-ADUser -Identity "CN=Sean,OU=Verkoop,DC=red,DC=local" -Manager "CN=Matthias,OU=Verkoop,DC=red,DC=local"

# Elk user-account unlocken.
Write-Host "Unlock accounts..." -ForeGroundColor "Green"
# Om performanter te maken:
function unlock_directie() {
    Param(
        [string]$ou_directie
    )
    $ou_exists=[adsi]::Exists("LDAP://CN=$ou_directie,OU=Directie,DC=red,DC=local")
    if($ou_exists) {
        Write-Host ">>> Unlock account $ou_directie" -ForegroundColor "Green"
        Enable-ADAccount -Identity "CN=$ou_directie,OU=Directie,DC=red,DC=local"
    }
    else {
        Write-Warning "User $ou_directie does not exists (skipping)"
    }
}
unlock_directie "Kimberly"
unlock_directie "Arno"

function unlock_it() {
    Param(
        [string]$ou_it
    )
    $ou_exists=[adsi]::Exists("LDAP://CN=$ou_it,OU=IT_Administratie,DC=red,DC=local")
    if($ou_exists) {
        Write-Host ">>> Unlock account $ou_it" -ForegroundColor "Green"
        Enable-ADAccount -Identity "CN=$ou_it,OU=IT_Administratie,DC=red,DC=local"
    }
    else {
        Write-Warning "User $ou_it does not exists (skipping)"
    }
}
unlock_it "Laurens"
unlock_it "Ferre"
unlock_it "Levi"
unlock_it "Aron"
unlock_it "Jens"

function unlock_admin() {
    Param(
        [string]$ou_admin
    )
    $ou_exists=[adsi]::Exists("LDAP://CN=$ou_admin,OU=Administratie,DC=red,DC=local")
    if($ou_exists) {
        Write-Host ">>> Unlock account $ou_admin" -ForegroundColor "Green"
        Enable-ADAccount -Identity "CN=$ou_admin,OU=Administratie,DC=red,DC=local"
    }
    else {
        Write-Warning "User $ou_admin does not exists (skipping)"
    }
}
unlock_admin "Joachim"
unlock_admin "Tibo"
unlock_admin "Yngvar"
unlock_admin "Tim"
unlock_admin "Rik"

function unlock_ontwikkeling() {
    Param(
        [string]$ou_ontwikkeling
    )
    $ou_exists=[adsi]::Exists("LDAP://CN=$ou_ontwikkeling,OU=Ontwikkeling,DC=red,DC=local")
    if($ou_exists) {
        Write-Host ">>> Unlock account $ou_ontwikkeling" -ForegroundColor "Green"
        Enable-ADAccount -Identity "CN=$ou_ontwikkeling,OU=Ontwikkeling,DC=red,DC=local"
    }
    else {
        Write-Warning "User $ou_ontwikkeling does not exists (skipping)"
    }
}
unlock_ontwikkeling "Jannes"
unlock_ontwikkeling "Jonas"
unlock_ontwikkeling "CedricVDE"
unlock_ontwikkeling "CedricD"
unlock_ontwikkeling "Robin"

function unlock_verkoop() {
    Param(
        [string]$ou_verkoop
    )
    $ou_exists=[adsi]::Exists("LDAP://CN=$ou_verkoop,OU=Verkoop,DC=red,DC=local")
    if($ou_exists) {
        Write-Host ">>> Unlock account $ou_verkoop" -ForegroundColor "Green"
        Enable-ADAccount -Identity "CN=$ou_verkoop,OU=Verkoop,DC=red,DC=local"
    }
    else {
        Write-Warning "User $ou_verkoop does not exists (skipping)"
    }
}
unlock_verkoop "Matthias"
unlock_verkoop "Robby"
unlock_verkoop "Nathan"
unlock_verkoop "Elias"
unlock_verkoop "Alister"
unlock_verkoop "Sean"

# Computers
# Voeg minstens 5 werkstations toe (één in elke afdeling).
Write-Host "Create workstations for Directie..." -ForeGroundColor "Green"
New-ADComputer "Directie_001" -SamAccountName "Directie001" -Path "CN=Computers,DC=red,DC=local" -Enabled $True -Location "Gent,BE" -ManagedBy "CN=Kimberly,OU=Directie,DC=red,DC=local"
New-ADComputer "Directie_002" -SamAccountName "Directie002" -Path "CN=Computers,DC=red,DC=local" -Enabled $True -Location "Aalst,BE" -ManagedBy "CN=Arno,OU=Directie,DC=red,DC=local"

Write-Host "Create workstations for Administratie..." -ForeGroundColor "Green"
New-ADComputer "Administratie_001" -SamAccountName "Admin001" -Path "CN=Computers,DC=red,DC=local" -Enabled $True -Location "Gent,BE" -ManagedBy "CN=Joachim,OU=Administratie,DC=red,DC=local"
New-ADComputer "Administratie_002" -SamAccountName "Admin002" -Path "CN=Computers,DC=red,DC=local" -Enabled $True -Location "Gent,BE" -ManagedBy "CN=Tibo,OU=Administratie,DC=red,DC=local"
New-ADComputer "Administratie_003" -SamAccountName "Admin003" -Path "CN=Computers,DC=red,DC=local" -Enabled $True -Location "Gent,BE" -ManagedBy "CN=Yngvar,OU=Administratie,DC=red,DC=local"
New-ADComputer "Administratie_004" -SamAccountName "Admin004" -Path "CN=Computers,DC=red,DC=local" -Enabled $True -Location "Gent,BE" -ManagedBy "CN=Tim,OU=Administratie,DC=red,DC=local"
New-ADComputer "Administratie_005" -SamAccountName "Admin005" -Path "CN=Computers,DC=red,DC=local" -Enabled $True -Location "Gent,BE" -ManagedBy "CN=Rik,OU=Administratie,DC=red,DC=local"

Write-Host "Create workstations for Verkoop..." -ForeGroundColor "Green"
New-ADComputer "Verkoop_001" -SamAccountName "Verkoop001" -Path "CN=Computers,DC=red,DC=local" -Enabled $True -Location "Gent,BE" -ManagedBy "CN=Matthias,OU=Verkoop,DC=red,DC=local"
New-ADComputer "Verkoop_002" -SamAccountName "Verkoop002" -Path "CN=Computers,DC=red,DC=local" -Enabled $True -Location "Aalst,BE" -ManagedBy "CN=Robby,OU=Verkoop,DC=red,DC=local"
New-ADComputer "Verkoop_003" -SamAccountName "Verkoop003" -Path "CN=Computers,DC=red,DC=local" -Enabled $True -Location "Gent,BE" -ManagedBy "CN=Nathan,OU=Verkoop,DC=red,DC=local"
New-ADComputer "Verkoop_004" -SamAccountName "Verkoop004" -Path "CN=Computers,DC=red,DC=local" -Enabled $True -Location "Gent,BE" -ManagedBy "CN=Elias,OU=Verkoop,DC=red,DC=local"
New-ADComputer "Verkoop_005" -SamAccountName "Verkoop005" -Path "CN=Computers,DC=red,DC=local" -Enabled $True -Location "Gent,BE" -ManagedBy "CN=Alister,OU=Verkoop,DC=red,DC=local"
New-ADComputer "Verkoop_006" -SamAccountName "Verkoop006" -Path "CN=Computers,DC=red,DC=local" -Enabled $True -Location "Gent,BE" -ManagedBy "CN=Sean,OU=Verkoop,DC=red,DC=local"

Write-Host "Create workstations for Ontwikkeling..." -ForeGroundColor "Green"
New-ADComputer "Ontwikkeling_001" -SamAccountName "Ontwikkeling001" -Path "CN=Computers,DC=red,DC=local" -Enabled $True -Location "Gent,BE" -ManagedBy "CN=Jannes,OU=Ontwikkeling,DC=red,DC=local"
New-ADComputer "Ontwikkeling_002" -SamAccountName "Ontwikkeling002" -Path "CN=Computers,DC=red,DC=local" -Enabled $True -Location "Gent,BE" -ManagedBy "CN=Jonas,OU=Ontwikkeling,DC=red,DC=local"
New-ADComputer "Ontwikkeling_003" -SamAccountName "Ontwikkeling003" -Path "CN=Computers,DC=red,DC=local" -Enabled $True -Location "Aalst,BE" -ManagedBy "CN=CedricVDE,OU=Ontwikkeling,DC=red,DC=local"
New-ADComputer "Ontwikkeling_004" -SamAccountName "Ontwikkeling004" -Path "CN=Computers,DC=red,DC=local" -Enabled $True -Location "Aalst,BE" -ManagedBy "CN=CedricD,OU=Ontwikkeling,DC=red,DC=local"
New-ADComputer "Ontwikkeling_005" -SamAccountName "Ontwikkeling005" -Path "CN=Computers,DC=red,DC=local" -Enabled $True -Location "Gent,BE" -ManagedBy "CN=Robin,OU=Ontwikkeling,DC=red,DC=local"

Write-Host "Create workstations for IT_Administratie..." -ForeGroundColor "Green"
New-ADComputer "ITAdministratie_001" -SamAccountName "ITAdmin001" -Path "CN=Computers,DC=red,DC=local" -Enabled $True -Location "Gent,BE" -ManagedBy "CN=Laurens,OU=IT_Administratie,DC=red,DC=local"
New-ADComputer "ITAdministratie_002" -SamAccountName "ITAdmin002" -Path "CN=Computers,DC=red,DC=local" -Enabled $True -Location "Gent,BE" -ManagedBy "CN=Ferre,OU=IT_Administratie,DC=red,DC=local"
New-ADComputer "ITAdministratie_003" -SamAccountName "ITAdmin003" -Path "CN=Computers,DC=red,DC=local" -Enabled $True -Location "Aalst,BE" -ManagedBy "CN=Levi,OU=IT_Administratie,DC=red,DC=local"
New-ADComputer "ITAdministratie_004" -SamAccountName "ITAdmin004" -Path "CN=Computers,DC=red,DC=local" -Enabled $True -Location "Aalst,BE" -ManagedBy "CN=Aron,OU=IT_Administratie,DC=red,DC=local"
New-ADComputer "ITAdministratie_005" -SamAccountName "ITAdmin005" -Path "CN=Computers,DC=red,DC=local" -Enabled $True -Location "Gent,BE" -ManagedBy "CN=Jens,OU=IT_Administratie,DC=red,DC=local"

# Roaming profiles
# Write-Host "Create a shared folder for roaming profiles..." -ForeGroundColor "Green"
# New-Item -ItemType Directory -Name "Profiles" -Path "C:"
# New-SmbShare -Path "C:\Windows\system32\Profiles\" -Name "Profiles"
#
# Write-Host "Modify folder permissions..." -ForeGroundColor "Green"
# Grant-SmbShareAccess -Name "Profiles" -AccountName Everyone -AccessRight Full -Force
#
# Write-Host "Configure the profile path for Directie..." -ForeGroundColor "Green"
# Set-ADUser -Identity "CN=Kimberly,OU=Directie,DC=red,DC=local" -ProfilePath "\\dc01\profiles\kimberly"
# Set-ADUser -Identity "CN=Arno,OU=Directie,DC=red,DC=local" -ProfilePath "\\dc01\profiles\arno"
#
# Write-Host "Configure the profile path for Administratie..." -ForeGroundColor "Green"
# Set-ADUser -Identity "CN=Joachim,OU=Administratie,DC=red,DC=local" -ProfilePath "\\dc01\profiles\joachim"
# Set-ADUser -Identity "CN=Tibo,OU=Administratie,DC=red,DC=local" -ProfilePath "\\dc01\profiles\tibo"
# Set-ADUser -Identity "CN=Yngvar,OU=Administratie,DC=red,DC=local" -ProfilePath "\\dc01\profiles\yngvar"
# Set-ADUser -Identity "CN=Tim,OU=Administratie,DC=red,DC=local" -ProfilePath "\\dc01\profiles\tim"
# Set-ADUser -Identity "CN=Rik,OU=Administratie,DC=red,DC=local" -ProfilePath "\\dc01\profiles\rik"
#
# Write-Host "Configure the profile path for IT_Administratie..." -ForeGroundColor "Green"
# Set-ADUser -Identity "CN=Laurens,OU=IT_Administratie,DC=red,DC=local" -ProfilePath "\\dc01\profiles\laurens"
# Set-ADUser -Identity "CN=Ferre,OU=IT_Administratie,DC=red,DC=local" -ProfilePath "\\dc01\profiles\ferre"
# Set-ADUser -Identity "CN=Levi,OU=IT_Administratie,DC=red,DC=local" -ProfilePath "\\dc01\profiles\levi"
# Set-ADUser -Identity "CN=Aron,OU=IT_Administratie,DC=red,DC=local" -ProfilePath "\\dc01\profiles\aron"
# Set-ADUser -Identity "CN=Jens,OU=IT_Administratie,DC=red,DC=local" -ProfilePath "\\dc01\profiles\jens"
#
# Write-Host "Configure the profile path for Ontwikkeling..." -ForeGroundColor "Green"
# Set-ADUser -Identity "CN=Jannes,OU=Ontwikkeling,DC=red,DC=local" -ProfilePath "\\dc01\profiles\jannes"
# Set-ADUser -Identity "CN=Jonas,OU=Ontwikkeling,DC=red,DC=local" -ProfilePath "\\dc01\profiles\jonas"
# Set-ADUser -Identity "CN=CedricVDE,OU=Ontwikkeling,DC=red,DC=local" -ProfilePath "\\dc01\profiles\cedricVDE"
# Set-ADUser -Identity "CN=CedricD,OU=Ontwikkeling,DC=red,DC=local" -ProfilePath "\\dc01\profiles\cedricD"
# Set-ADUser -Identity "CN=Robin,OU=Ontwikkeling,DC=red,DC=local" -ProfilePath "\\dc01\profiles\robin"
#
# Write-Host "Configure the profile path for Verkoop..." -ForeGroundColor "Green"
# Set-ADUser -Identity "CN=Matthias,OU=Verkoop,DC=red,DC=local" -ProfilePath "\\dc01\profiles\matthias"
# Set-ADUser -Identity "CN=Robby,OU=Verkoop,DC=red,DC=local" -ProfilePath "\\dc01\profiles\robby"
# Set-ADUser -Identity "CN=Nathan,OU=Verkoop,DC=red,DC=local" -ProfilePath "\\dc01\profiles\nathan"
# Set-ADUser -Identity "CN=Elias,OU=Verkoop,DC=red,DC=local" -ProfilePath "\\dc01\profiles\elias"
# Set-ADUser -Identity "CN=Alister,OU=Verkoop,DC=red,DC=local" -ProfilePath "\\dc01\profiles\alister"
# Set-ADUser -Identity "CN=Sean,OU=Verkoop,DC=red,DC=local" -ProfilePath "\\dc01\profiles\sean"
#>

# Group Policy
# De GPO's worden in de GUI ingesteld. Zie screenshots in het verslag.
# 1. Verbied iedereen uit alle afdelingen behalve IT Administratie de toegang tot het control panel
# 2. Verwijder het games link menu uit het start menu voor alle afdelingen
# 3. Verbied iedereen uit de afdelingen Administratie en Verkoop de toegang tot de eigenschappen van de netwerkadapters

# Eerst worden de GPO's (DisableControlPanel, RemoveGameLink en DisableNetworkadapters) gemaakt.
# Group Policy Management > Forest: red.local > Domains > red.local > rechtsklik > "Create a GPO in this domain, and Link it here..."

# De GPO linken aan de juiste afdelingen
# Group Policy Management > Forest: red.local > Domains > red.local > "Afdeling" > rechtsklik > "Link an Existing GPO..."
# IT_Administratie: RemoveGameLink
# Administratie: DisableControlPanel, RemoveGameLink, DisableNetworkadapters
# Directie: DisableControlPanel, RemoveGameLink
# Verkoop: DisableControlPanel, RemoveGameLink, DisableNetworkadapters
# Ontwikkeling: DisableControlPanel, RemoveGameLink

# GPO's configureren
# Group Policy Management > Forest: red.local > Domains > red.local > Group Policy Objects > "GPO" > rechtsklik > "Edit..."
# DisableControlPanel
# Group Policy Management Editor > User Configuration > Policies > Administratieve Templates: Policy definitions > Control Panel > Display > Disable the Display Control Panel > Enabled > Apply
# RemoveGameLink
# Group Policy Management Editor > User Configuration > Policies > Administratieve Templates: Policy definitions > Start Menu and Taskbar > Remove Games link from Start Menu > Disabled > Apply
# DisableNetworkadapters
# Group Policy Management Editor > User Configuration > Policies > Administratieve Templates: Policy definitions > Network > Network Connections > Prohibit access to properties of a LAN connection > Disabled > Apply

# 5) Start het 999_PrepareADforSCCM.ps1 script als Administrator:
Write-host "Running next script 4_ADSTRUCTURE.ps1 as admin:" -ForeGroundColor "Green"
Start-Process powershell -Verb runAs -ArgumentList "$VBOXdrive\999_PrepareADforSCCM.ps1"


Stop-Transcript
