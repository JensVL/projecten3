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
# Wachtwoord "Admin2019" gaf foutmeldingen. 
$paswoord=ConvertTo-SecureString "Administrator2019" -asPlainText -force
Write-Host "Create users for OU Directie..." -ForeGroundColor "Green"
New-AdUser -Name "Kimberly" -Surname "De Clercq" -SamAccountName "KimberlyDC" -Department "Manager" -Description "Account voor Kimberly" -DisplayName "KimberlyDC" `
           -GivenName "Kimberly" -State "West-Vlaanderen"  -City "Ingelmunster" -PostalCode "8770" -EmailAddress "kimberly@red.local" `
           -Office "B0.001" -EmployeeID "1004" -HomePhone "0444727272" -Initials "KDC" -Path "OU=Directie,DC=red,DC=local" -AccountPassword $paswoord

New-AdUser -Name "Arno" -Surname "Van Nieuwenhove" -SamAccountName "ArnoVN" -Department "Manager" -Description "Account voor Arno" -DisplayName "ArnoVN" `
           -GivenName "Arno" -State "Oost-Vlaanderen"  -City "Ninove" -PostalCode "9404" -EmailAddress "arno@red.local" `
           -Office "B0.002" -EmployeeID "1003" -HomePhone "0444727273" -Initials "AVN" -Path "OU=Directie,DC=red,DC=local" -AccountPassword $paswoord

Write-Host "Create users for OU IT Administratie..." -ForeGroundColor "Green"
New-AdUser -Name "Laurens" -Surname "Blancquaert-Cassaer" -SamAccountName "LaurensBC" -Department "IT_Administration" -Description "Account voor Laurens" -DisplayName "LaurensBC" `
           -GivenName "Laurens" -State "Oost-Vlaanderen" -City "Gent" -PostalCode "9000" -EmailAddress "laurens@red.local" `
           -Office "B4.037" -EmployeeID "2015" -HomePhone "0444727280" -Initials "LBC" -Path "OU=IT_Administratie,DC=red,DC=local" -AccountPassword $paswoord

New-AdUser -Name "Ferre" -Surname "Verstichelen" -SamAccountName "FerreV" -Department "IT_Administration" -Description "Account voor Ferre" -DisplayName "FerreV" `
           -GivenName "Ferre" -State "West-Vlaanderen" -City "Wervik" -PostalCode "8940" -EmailAddress "ferre@red.local" `
           -Office "B4.037" -EmployeeID "8425" -HomePhone "0444727281" -Initials "FV" -Path "OU=IT_Administratie,DC=red,DC=local" -AccountPassword $paswoord

New-AdUser -Name "Levi" -Surname "Goessens" -SamAccountName "LeviG" -Department "IT_Administration" -Description "Account voor Levi" -DisplayName "LeviG" `
           -GivenName "Levi" -State "Oost-Vlaanderen" -City "Denderwindeke" -PostalCode "9400" -EmailAddress "levi@red.local" `
           -Office "B4.037" -EmployeeID "2014" -HomePhone "0444727284" -Initials "LG" -Path "OU=IT_Administratie,DC=red,DC=local" -AccountPassword $paswoord

New-AdUser -Name "Aron" -Surname "Marckx" -SamAccountName "AronM" -Department "IT_Administration" -Description "Account voor Aron" -DisplayName "AronM" `
           -GivenName "Aron" -State "Oost-Vlaanderen" -City "Meldert" -PostalCode "9310" -EmailAddress "aron@red.local" `
           -Office "B4.037" -EmployeeID "8424" -HomePhone "0444727285" -Initials "AM" -Path "OU=IT_Administratie,DC=red,DC=local" -AccountPassword $paswoord

New-AdUser -Name "Jens" -Surname "Van Liefferinge" -SamAccountName "JensVL" -Department "IT_Administration" -Description "Account voor Jens" -DisplayName "JensVL" `
           -GivenName "Jens" -State "Oost-Vlaanderen" -City "Lokeren" -PostalCode "9160" -EmailAddress "jens@red.local" `
           -Office "B4.037" -EmployeeID "8653" -HomePhone "0444727282" -Initials "JVL" -Path "OU=IT_Administratie,DC=red,DC=local" -AccountPassword $paswoord

Write-Host "Create users for Administratie..." -ForeGroundColor "Green"
New-AdUser -Name "Joachim" -Surname "Van de Keere" -SamAccountName "JoachimVDK" -Department "Administration" -Description "Account voor Joachim" -DisplayName "JoachimVDK" `
            -GivenName "Joachim" -State "Oost-Vlaanderen" -City "Sint-Martens-Latem" -Postalcode "9830" -EmailAddress "joachim@red.local" `
            -Office "B4.002" -EmployeeID "2531" -HomePhone "0444727260" -Initials "JVDK" -Path "OU=Administratie,DC=red,DC=local" -AccountPassword $paswoord

New-AdUser -Name "Tibo" -Surname "Vanhercke" -SamAccountName "TiboV"-Department "Administration" -Description "Account voor Tibo" -DisplayName "TiboV" `
            -GivenName "Tibo" -State "West-Vlaanderen" -City "Ingooigem" -Postalcode "8570" -EmailAddress "tibo@red.local" `
            -Office "B4.002" -EmployeeID "6312" -HomePhone "0444727261" -Initials "TV" -Path "OU=Administratie,DC=red,DC=local" -AccountPassword $paswoord

New-AdUser -Name "Yngvar" -Surname "Samyn" -SamAccountName "YngvarS"-Department "Administration" -Description "Account voor Yngvar" -DisplayName "YngvarS" `
            -GivenName "Yngvar" -State "West-Vlaanderen" -City "Ingooigem" -Postalcode "8570" -EmailAddress "yngvar@red.local" `
            -Office "B4.002" -EmployeeID "2210" -HomePhone "0444727262" -Initials "YS" -Path "OU=Administratie,DC=red,DC=local" -AccountPassword $paswoord

New-AdUser -Name "Tim" -Surname "Grijp" -SamAccountName "TimG" -Department "Administration" -Description "Account voor Tim" -DisplayName "TimG" `
            -GivenName "Tim" -State "Oost-Vlaanderen" -City "Sint-Martens-Latem" -Postalcode "9830" -EmailAddress "tim@red.local" `
            -Office "B4.002" -EmployeeID "2532" -HomePhone "0444727263" -Initials "TG" -Path "OU=Administratie,DC=red,DC=local" -AccountPassword $paswoord

New-AdUser -Name "Rik" -Surname "Claeyssens" -SamAccountName "RikC" -Department "Administration" -Description "Account voor Rik" -DisplayName "RikC" `
            -GivenName "Rik" -State "Oost-Vlaanderen" -City "Sint-Martens-Latem" -Postalcode "9830" -EmailAddress "rik@red.local" `
            -Office "B4.002" -EmployeeID "2731" -HomePhone "0444727264" -Initials "RC" -Path "OU=Administratie,DC=red,DC=local" -AccountPassword $paswoord

Write-Host "Create users for OU Ontwikkeling..." -ForeGroundColor "Green"
New-AdUser -Name "Jannes" -Surname "Van Wonterghem" -SamAccountName "JannesVW" -Department "Development" -Description "Account voor Jannes" -DisplayName "JannesVW" `
           -GivenName "Jannes" -State "Antwerpen" -City "Zoersel" -PostalCode "2980" -EmailAddress "jannes@red.local" `
           -Office "B1.018" -EmployeeID "5078" -HomePhone "0444727290" -Initials "JVW" -Path "OU=Ontwikkeling,DC=red,DC=local" -AccountPassword $paswoord

New-AdUser -Name "Jonas" -Surname "Vandegehuchte" -SamAccountName "JonasV"-Department "Development" -Description "Account voor Jonas" -DisplayName "JonasV" `
           -GivenName "Jonas" -State "Vlaams-Brabant" -City "Bierbeek" -PostalCode "3360" -EmailAddress "jonas@red.local" `
           -Office "B1.018" -EmployeeID "1578" -HomePhone "0444727291" -Initials "JV" -Path "OU=Ontwikkeling,DC=red,DC=local" -AccountPassword $paswoord

New-AdUser -Name "Cédric" -Surname "Van den Eede" -SamAccountName "CedricVDE"-Department "Development" -Description "Account voor Cédric" -DisplayName "CedricVDE" `
           -GivenName "Cédric" -State "Oost-Vlaanderen" -City "Meldert" -PostalCode "9310" -EmailAddress "cedric@red.local" `
           -Office "B1.018" -EmployeeID "5079" -HomePhone "0444727292" -Initials "CVDE" -Path "OU=Ontwikkeling,DC=red,DC=local" -AccountPassword $paswoord

New-AdUser -Name "CedricD" -Surname "Detemmerman" -SamAccountName "CedricD"-Department "Development" -Description "Account voor Cedric" -DisplayName "CedricD" `
           -GivenName "Cedric" -State "Oost-Vlaanderen" -City "Haaltert" -PostalCode "3360" -EmailAddress "cedricd@red.local" `
           -Office "B1.018" -EmployeeID "1558" -HomePhone "0444727293" -Initials "CD" -Path "OU=Ontwikkeling,DC=red,DC=local" -AccountPassword $paswoord

New-AdUser -Name "Robin" -Surname "Van de Walle" -SamAccountName "RobinVDW"-Department "Development" -Description "Account voor Robin" -DisplayName "RobinVDW" `
           -GivenName "Robin" -State "Oost-Vlaanderen" -City "Haaltert" -PostalCode "3360" -EmailAddress "robin@red.local" `
           -Office "B1.018" -EmployeeID "1658" -HomePhone "0444727295" -Initials "RVDW" -Path "OU=Ontwikkeling,DC=red,DC=local" -AccountPassword $paswoord

Write-Host "Create users for Verkoop..." -ForeGroundColor "Green"
New-AdUser -Name "Matthias" -Surname "Van de Velde" -SamAccountName "MatthiasVDV"-Department "Sale" -Description "Account voor Matthias" -DisplayName "MatthiasVDV" `
           -GivenName "Matthias" -State "West-Vlaanderen" -City "Koksijde" -PostalCode "8670" -EmailAddress "matthias@red.local" `
           -Office "B0.015" -EmployeeID "4732" -HomePhone "0444727200" -Initials "MVDV" -Path "OU=Verkoop,DC=red,DC=local" -AccountPassword $paswoord

New-AdUser -Name "Robby" -Surname "Daelman" -SamAccountName "RobbyD" -Department "Sale" -Description "Account voor Roby" -DisplayName "RobbyD" `
           -GivenName "Robby" -State "Oost-Vlaanderen" -City "Lede" -PostalCode "9340" -EmailAddress "robby@red.local" `
           -Office "B0.015" -EmployeeID "4736" -HomePhone "0444727204" -Initials "RD" -Path "OU=Verkoop,DC=red,DC=local" -AccountPassword $paswoord

New-AdUser -Name "Nathan" -Surname "Cammerman" -SamAccountName "NathanC"-Department "Sale" -Description "Account voor Nathan" -DisplayName "NathanC" `
           -GivenName "Nathan" -State "West-Vlaanderen" -City "Torhout" -PostalCode "8820" -EmailAddress "nathan@red.local" `
           -Office "B0.015" -EmployeeID "5822" -HomePhone "0444727201" -Initials "NC" -Path "OU=Verkoop,DC=red,DC=local" -AccountPassword $paswoord

New-AdUser -Name "Elias" -Surname "Waterschoot" -SamAccountName "EliasW"-Department "Sale" -Description "Account voor Elias" -DisplayName "EliasW" `
           -GivenName "Elias" -State "West-Vlaanderen" -City "Torhout" -PostalCode "8820" -EmailAddress "elias@red.local" `
           -Office "B0.015" -EmployeeID "5423" -HomePhone "0444727202" -Initials "EW" -Path "OU=Verkoop,DC=red,DC=local" -AccountPassword $paswoord

New-AdUser -Name "Alister" -Surname "Adutwum" -SamAccountName "AlisterA"-Department "Sale" -Description "Account voor Alister" -DisplayName "AlisterA" `
           -GivenName "Alister" -State "West-Vlaanderen" -City "Torhout" -PostalCode "8820" -EmailAddress "alister@red.local" `
           -Office "B0.015" -EmployeeID "7215" -HomePhone "0444727206" -Initials "AA" -Path "OU=Verkoop,DC=red,DC=local" -AccountPassword $paswoord

## Managers per groep toekennen
Write-Host "Allocate managers to groups..." -ForeGroundColor "Green"
Set-ADGroup -Identity "CN=Administratie,OU=Administratie,DC=red,DC=local" -ManagedBy "CN=Joachim,OU=Administratie,DC=red,DC=local"
Set-ADGroup -Identity "CN=Directie,OU=Directie,DC=red,DC=local" -ManagedBy "CN=Kimberly,OU=Directie,DC=red,DC=local"
Set-ADGroup -Identity "CN=Ontwikkeling,OU=Ontwikkeling,DC=red,DC=local" -ManagedBy "CN=Jannes,OU=Ontwikkeling,DC=red,DC=local"
Set-ADGroup -Identity "CN=Verkoop,OU=Verkoop,DC=red,DC=local" -ManagedBy "CN=Matthias,OU=Verkoop,DC=red,DC=local"
Set-ADGroup -Identity "CN=IT_Administratie,OU=IT_Administratie,DC=red,DC=local" -ManagedBy "CN=Laurens,OU=IT_Administratie,DC=red,DC=local"

## Groepmembers maken
Write-Host "Add members to groups..." -ForeGroundColor "Green"
Add-ADGroupMember -Identity "CN=Directie,OU=Directie,DC=red,DC=local" -Members "CN=Kimberly,OU=Directie,DC=red,DC=local", "CN=Arno,OU=Directie,DC=red,DC=local"
Add-ADGroupMember -Identity "CN=Administratie,OU=Administratie,DC=red,DC=local" -Members "CN=Joachim,OU=Administratie,DC=red,DC=local", "CN=Tibo,OU=Administratie,DC=red,DC=local", "CN=Yngvar,OU=Administratie,DC=red,DC=local", "CN=Tim,OU=Administratie,DC=red,DC=local", "CN=Rik,OU=Administratie,DC=red,DC=local"
Add-ADGroupMember -Identity "CN=IT_Administratie,OU=IT_Administratie,DC=red,DC=local" -Members "CN=Laurens,OU=IT_Administratie,DC=red,DC=local", "CN=Ferre,OU=IT_Administratie,DC=red,DC=local", "CN=Levi,OU=IT_Administratie,DC=red,DC=local", "CN=Aron,OU=IT_Administratie,DC=red,DC=local", "CN=Jens,OU=IT_Administratie,DC=red,DC=local"
Add-ADGroupMember -Identity "CN=Verkoop,OU=Verkoop,DC=red,DC=local" -Members "CN=Matthias,OU=Verkoop,DC=red,DC=local", "CN=Robby,OU=Verkoop,DC=red,DC=local", "CN=Nathan,OU=Verkoop,DC=red,DC=local", "CN=Elias,OU=Verkoop,DC=red,DC=local", "CN=Alister,OU=Verkoop,DC=red,DC=local"
Add-ADGroupMember -Identity "CN=Ontwikkeling,OU=Ontwikkeling,DC=red,DC=local" -Members "CN=Jannes,OU=Ontwikkeling,DC=red,DC=local", "CN=Jonas,OU=Ontwikkeling,DC=red,DC=local", "CN=Cédric,OU=Ontwikkeling,DC=red,DC=local", "CN=CedricD,OU=Ontwikkeling,DC=red,DC=local", "CN=Robin,OU=Ontwikkeling,DC=red,DC=local"

## Managers per OU toekennen
Write-Host "Allocate managers to OU's..." -ForeGroundColor "Green"
Set-ADOrganizationalUnit -Identity "OU=Verkoop,DC=red,DC=local" -ManagedBy "CN=Matthias,OU=Verkoop,DC=red,DC=local"
Set-ADOrganizationalUnit -Identity "OU=Ontwikkeling,DC=red,DC=local" -ManagedBy "CN=Jannes,OU=Ontwikkeling,DC=red,DC=local"
Set-ADOrganizationalUnit -Identity "OU=Directie,DC=red,DC=local" -ManagedBy "CN=Kimberly,OU=Directie,DC=red,DC=local"
Set-ADOrganizationalUnit -Identity "OU=Administratie,DC=red,DC=local" -ManagedBy "CN=Joachim,OU=Administratie,DC=red,DC=local"
Set-ADOrganizationalUnit -Identity "OU=IT_Administratie,DC=red,DC=local" -ManagedBy "CN=Laurens,OU=IT_Administratie,DC=red,DC=local"

## Manager toekennen aan elke user
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
Set-ADUser -Identity "CN=Cédric,OU=Ontwikkeling,DC=red,DC=local" -Manager "CN=Jannes,OU=Ontwikkeling,DC=red,DC=local"
Set-ADUser -Identity "CN=CedricD,OU=Ontwikkeling,DC=red,DC=local" -Manager "CN=Jannes,OU=Ontwikkeling,DC=red,DC=local"
Set-ADUser -Identity "CN=Robin,OU=Ontwikkeling,DC=red,DC=local" -Manager "CN=Jannes,OU=Ontwikkeling,DC=red,DC=local"

Write-Host "Allocate manager OU Verkoop Matthias..." -ForeGroundColor "Green"
Set-ADUser -Identity "CN=Robby,OU=Verkoop,DC=red,DC=local" -Manager "CN=Matthias,OU=Verkoop,DC=red,DC=local"
Set-ADUser -Identity "CN=Nathan,OU=Verkoop,DC=red,DC=local" -Manager "CN=Matthias,OU=Verkoop,DC=red,DC=local"
Set-ADUser -Identity "CN=Elias,OU=Verkoop,DC=red,DC=local" -Manager "CN=Matthias,OU=Verkoop,DC=red,DC=local"
Set-ADUser -Identity "CN=Alister,OU=Verkoop,DC=red,DC=local" -Manager "CN=Matthias,OU=Verkoop,DC=red,DC=local"

# Elk user-account unlocken.
Write-Host "Unlock accounts..." -ForeGroundColor "Green"
Enable-ADAccount -Identity "CN=Kimberly,OU=Directie,DC=red,DC=local"
Enable-ADAccount -Identity "CN=Arno,OU=Directie,DC=red,DC=local"
Enable-ADAccount -Identity "CN=Laurens,OU=IT_Administratie,DC=red,DC=local"
Enable-ADAccount -Identity "CN=Ferre,OU=IT_Administratie,DC=red,DC=local"
Enable-ADAccount -Identity "CN=Levi,OU=IT_Administratie,DC=red,DC=local"
Enable-ADAccount -Identity "CN=Aron,OU=IT_Administratie,DC=red,DC=local"
Enable-ADAccount -Identity "CN=Jens,OU=IT_Administratie,DC=red,DC=local"
Enable-ADAccount -Identity "CN=Joachim,OU=Administratie,DC=red,DC=local"
Enable-ADAccount -Identity "CN=Tibo,OU=Administratie,DC=red,DC=local"
Enable-ADAccount -Identity "CN=Yngvar,OU=Administratie,DC=red,DC=local"
Enable-ADAccount -Identity "CN=Tim,OU=Administratie,DC=red,DC=local"
Enable-ADAccount -Identity "CN=Rik,OU=Administratie,DC=red,DC=local"
Enable-ADAccount -Identity "CN=Jannes,OU=Ontwikkeling,DC=red,DC=local"
Enable-ADAccount -Identity "CN=Jonas,OU=Ontwikkeling,DC=red,DC=local"
Enable-ADAccount -Identity "CN=Cédric,OU=Ontwikkeling,DC=red,DC=local"
Enable-ADAccount -Identity "CN=CedricD,OU=Ontwikkeling,DC=red,DC=local"
Enable-ADAccount -Identity "CN=Robin,OU=Ontwikkeling,DC=red,DC=local"
Enable-ADAccount -Identity "CN=Matthias,OU=Verkoop,DC=red,DC=local"
Enable-ADAccount -Identity "CN=Robby,OU=Verkoop,DC=red,DC=local"
Enable-ADAccount -Identity "CN=Nathan,OU=Verkoop,DC=red,DC=local"
Enable-ADAccount -Identity "CN=Elias,OU=Verkoop,DC=red,DC=local"
Enable-ADAccount -Identity "CN=Alister,OU=Verkoop,DC=red,DC=local"

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

Write-Host "Create workstations for Ontwikkeling..." -ForeGroundColor "Green"
New-ADComputer "Ontwikkeling_001" -SamAccountName "Ontwikkeling001" -Path "CN=Computers,DC=red,DC=local" -Enabled $True -Location "Gent,BE" -ManagedBy "CN=Jannes,OU=Ontwikkeling,DC=red,DC=local"
New-ADComputer "Ontwikkeling_002" -SamAccountName "Ontwikkeling002" -Path "CN=Computers,DC=red,DC=local" -Enabled $True -Location "Gent,BE" -ManagedBy "CN=Jonas,OU=Ontwikkeling,DC=red,DC=local"
New-ADComputer "Ontwikkeling_003" -SamAccountName "Ontwikkeling003" -Path "CN=Computers,DC=red,DC=local" -Enabled $True -Location "Aalst,BE" -ManagedBy "CN=Cédric,OU=Ontwikkeling,DC=red,DC=local"
New-ADComputer "Ontwikkeling_004" -SamAccountName "Ontwikkeling004" -Path "CN=Computers,DC=red,DC=local" -Enabled $True -Location "Aalst,BE" -ManagedBy "CN=CedricD,OU=Ontwikkeling,DC=red,DC=local"
New-ADComputer "Ontwikkeling_005" -SamAccountName "Ontwikkeling005" -Path "CN=Computers,DC=red,DC=local" -Enabled $True -Location "Gent,BE" -ManagedBy "CN=Robin,OU=Ontwikkeling,DC=red,DC=local"

Write-Host "Create workstations for IT_Administratie..." -ForeGroundColor "Green"
New-ADComputer "ITAdministratie_001" -SamAccountName "ITAdmin001" -Path "CN=Computers,DC=red,DC=local" -Enabled $True -Location "Gent,BE" -ManagedBy "CN=Laurens,OU=IT_Administratie,DC=red,DC=local"
New-ADComputer "ITAdministratie_002" -SamAccountName "ITAdmin002" -Path "CN=Computers,DC=red,DC=local" -Enabled $True -Location "Gent,BE" -ManagedBy "CN=Ferre,OU=IT_Administratie,DC=red,DC=local"
New-ADComputer "ITAdministratie_003" -SamAccountName "ITAdmin003" -Path "CN=Computers,DC=red,DC=local" -Enabled $True -Location "Aalst,BE" -ManagedBy "CN=Levi,OU=IT_Administratie,DC=red,DC=local"
New-ADComputer "ITAdministratie_004" -SamAccountName "ITAdmin004" -Path "CN=Computers,DC=red,DC=local" -Enabled $True -Location "Aalst,BE" -ManagedBy "CN=Aron,OU=IT_Administratie,DC=red,DC=local"
New-ADComputer "ITAdministratie_005" -SamAccountName "ITAdmin005" -Path "CN=Computers,DC=red,DC=local" -Enabled $True -Location "Gent,BE" -ManagedBy "CN=Jens,OU=IT_Administratie,DC=red,DC=local"

####################################################################################################################################### TODO MAG WSS WEG

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
# Set-ADUser -Identity "CN=Cédric,OU=Ontwikkeling,DC=red,DC=local" -ProfilePath "\\dc01\profiles\cédric"
# Set-ADUser -Identity "CN=CedricD,OU=Ontwikkeling,DC=red,DC=local" -ProfilePath "\\dc01\profiles\cedricD"
# Set-ADUser -Identity "CN=Robin,OU=Ontwikkeling,DC=red,DC=local" -ProfilePath "\\dc01\profiles\robin"
#
# Write-Host "Configure the profile path for Verkoop..." -ForeGroundColor "Green"
# Set-ADUser -Identity "CN=Matthias,OU=Verkoop,DC=red,DC=local" -ProfilePath "\\dc01\profiles\matthias"
# Set-ADUser -Identity "CN=Robby,OU=Verkoop,DC=red,DC=local" -ProfilePath "\\dc01\profiles\robby"
# Set-ADUser -Identity "CN=Nathan,OU=Verkoop,DC=red,DC=local" -ProfilePath "\\dc01\profiles\nathan"
# Set-ADUser -Identity "CN=Elias,OU=Verkoop,DC=red,DC=local" -ProfilePath "\\dc01\profiles\elias"
# Set-ADUser -Identity "CN=Alister,OU=Verkoop,DC=red,DC=local" -ProfilePath "\\dc01\profiles\alister"

####################################################################################################################################### TODO MAG WSS WEG

## TO DO: Group policy
# Verbied iedereen uit alle afdelingen behalve IT Administratie de toegang tot het control panel
Write-Host "Forbid everyone from all departments except IT Administration access to the control panel..." -ForeGroundColor "Green"
New-GPO "DisablingControlPanel" -Comment "Disable Control Panel"
# GPO aan OU linken
New-GPLink -Name "DisablingControlPanel" -Target "OU=Administratie,DC=red,DC=local"
New-GPLink -Name "DisablingControlPanel" -Target "OU=Verkoop,DC=red,DC=local"
New-GPLink -Name "DisablingControlPanel" -Target "OU=Ontwikkeling,DC=red,DC=local"
New-GPLink -Name "DisablingControlPanel" -Target "OU=Directie,DC=red,DC=local"
$GPOSession = Open-NetGPO -PolicyStore "red.local\DisablingControlPanel"

# Review GPO
Get-GPO -Name "DisablingControlPanel" | Get-GPOReport -ReportType HTML
# Extra beveiliging om GPO's te blocken van de parent OU
Set-GPInheritance -Target "OU=Administratie,DC=red,DC=local" -IsBlocked 1

# Verwijder het games link menu uit het start menu voor alle afdelingen
Write-Host "Remove the games link menu from the start menu..." -ForeGroundColor "Green"
New-GPO "DisablingGameLink" -Comment "Disable Game link menu uit start menu"
# GPO aan OU linken
New-GPLink -Name "DisablingGameLink" -Target "OU=IT_Administratie,DC=red,DC=local"
New-GPLink -Name "DisablingGameLink" -Target "OU=Verkoop,DC=red,DC=local"
New-GPLink -Name "DisablingGameLink" -Target "OU=Ontwikkeling,DC=red,DC=local"
New-GPLink -Name "DisablingGameLink" -Target "OU=Administratie,DC=red,DC=local"
New-GPLink -Name "DisablingGameLink" -Target "OU=Directie,DC=red,DC=local"
$GPOSession = Open-NetGPO -PolicyStore "red.local\DisablingGameLink"

# Verbied iedereen uit de afdelingen Administratie en Verkoop de toegang tot de eigenschappen van de netwerkadapters
Write-Host "Forbid everyone from the Administration and Sales departments access to the properties of the network adapters..." -ForeGroundColor "Green"
New-GPO "DisableNetwerkadapters" -Comment "Disable Netwerkadapters voor de afdelingen Administratie en Verkoop"
New-GPLink -Name "DisableNetwerkadapters" -Target "OU=Administratie,DC=red,DC=local"
New-GPLink -Name "DisableNetwerkadapters" -Target "OU=Verkoop,DC=red,DC=local"
$GPOSession = Open-NetGPO -PolicyStore "red.local\DisableNetwerkadapters"

# GPO opslaan
Save-NetGPO -GPOSession $GPOSession

## Juiste toegangsgroepen voor de fileserver (Modify/Read/Full) en voeg de juiste personen en/of groepen toe
Set-GPPermission -Name "DisablingControlPanel" -TargetName "Users" -TargetType User -PermissionLevel None
Set-GPPermission -Name "DisablingControlPanel" -TargetName "OU=IT_Administratie,DC=red,DC=local" -TargetType User -PermissionLevel GPOApply

# Import the settings from the latest backup to another directory in the same domain
##  Import-GPO -BackupId "A491D730-F3ED-464C-B8C9-F50562C536AA" -TargetName "BackupGPO" -path "c:\backups" -CreateIfNeeded
# Import the settings from specified backup in the same directory in the same domain
##  Import-GPO -BackupGPOName "BackupGPO" -Path "D:\Backups" -TargetName "BackupGPO" -MigrationTable "D:\Tables\Migtable1.migtable" -CreateIfNeeded

## Copy-NetFirewallRule -Name ""
# New-GPLink -Name "Control Panel" -Target "OU=Verkoop,dc=red,dc=local" -LinkEnabled Yes -Enforced Yes

Stop-Transcript
