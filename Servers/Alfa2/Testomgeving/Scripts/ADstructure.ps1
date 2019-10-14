Import-Module ActiveDirectory

## Groepen
Write-Host "Make Organizational Unit Verkoop..."
New-ADOrganizationalUnit "Verkoop”

Write-Host "Make Organizational Unit Administratie..."
New-ADOrganizationalUnit -Name "Administratie" -Path "DC=red,DC=local" -OtherAttributes @{seeAlso="CN=HumanResourceManagers,OU=Groups,OU=Managed,DC=red,DC=local";managedBy="CN=TomC,DC=FABRIKAM,DC=COM"}

Write-Host "Make Organizational Unit IT Administratie in OU Administratie..."
# Sub OU
New-ADOrganizationalUnit “IT Administratie” –Path “OU=Administratie,DC=red,DC=local”

Write-Host "Make Organizational Unit Ontwikkeling..."
New-ADOrganizationalUnit "Ontwikkeling”

Write-Host "Make Organizational Unit Directie..."
New-ADOrganizationalUnit "Directie”


## Gebruikers
Write-Host "Generate passwords..."
$paswoordje=ConverTo-SecureString "Admin2019" -asPlainText -force

Write-Host "Create users..."

Write-Host "Create Manager Kimberly..."
New-AdUser -Name "Kimberly" -Surname "De Clercq" -Department "Manager" -Description "Account voor Kimberly" -DisplayName "KimberlyDC" -GivenName "Kimberly" -State "West-Vlaanderen"  -City "Ingelmunster" -PostalCode "8770" -EmailAddress "kimberly@red.be" -Office "B0.001" -EmployeeID "1004" -HomePhone "0444727272" -Initials "KDC" -Path 'ou=Directie,DC=red,DC=local' -AccountPassword $paswoordje

Write-Host "Create IT Administrator Laurens..."
New-AdUser -Name "Laurens" -Surname "Blancquaert-Cassaer" -Department "IT Administration" -Description "Account voor Laurens" -DisplayName "LaurensBC" -GivenName "Laurens" -State "Oost-Vlaanderen" -City "Gent" -PostalCode "9000" -EmailAddress "laurens@red.be" -Office "B4.037" -EmployeeID "2015" -HomePhone "0444727274" -Initials "LBC" -Path 'ou=IT Administratie,DC=red,DC=local' -AccountPassword $paswoordje

Write-Host "Create Ontwikkeling Jan..."
New-AdUser -Name "Jan" -Surname "Janssens" -Department "Development" -Description "Account voor Jan" -DisplayName "JanJ" -GivenName "Jan" -State "Antwerpen" -City "Zoersel" -"2980" -EmailAddress "jan@red.be" -Office "B1.018" -EmployeeID "5078" -HomePhone "0444727280" -Initials "JJ" -Path 'ou=Ontwikkeling,DC=red,DC=local' -AccountPassword $paswoordje

Write-Host "Create Verkoop Mieke..."
New-AdUser -Name "Mieke" -Surname "Dobbels" -Department "Sale" -Description "Account voor Mieke" -DisplayName "MiekeD" -GivenName "Mieke" -State "West-Vlaanderen" -City "Koksijde" -"8670" -EmailAddress "mieke@red.be" -Office "B0.015" -EmployeeID "4245" -HomePhone "0444727275" -Initials "MD" -Path 'ou=Verkoop,DC=red,DC=local' -AccountPassword $paswoordje

Write-Host "Create Verkoop Piet..."
New-AdUser -Name "Piet" -Surname "Pietser" -Department "Administration" -Description "Account voor Piet" -DisplayName "PietP" -GivenName "Piet" -State "Oost-Vlaanderen" -City "Sint-Martens-Latem" -"9830" -EmailAddress "piet@red.be" -Office "B4.002" -EmployeeID "2531" -HomePhone "0444727273" -Initials "MD" -Path 'ou=Administratie,DC=red,DC=local' -AccountPassword $paswoordje

## Manager toekennen
Write-Host "Allocate manager ..."
Set-ADUser -Identity "Laurens" -Manager "CN=Kimberly,OU=Directie,DC=red,DC=local"
Set-ADUser -Identity "Jan" -Manager "CN=Kimberly,OU=Directie,DC=red,DC=local"
Set-ADUser -Identity "Mieke" -Manager "CN=Kimberly,OU=Directie,DC=red,DC=local"
Set-ADUser -Identity "Piet" -Manager "CN=Kimberly,OU=Directie,DC=red,DC=local"

Write-Host "Unlock accounts..."
Enable-ADAccount -Identity "Kimberly"
Enable-ADAccount -Identity "Laurens"
Enable-ADAccount -Identity "Jan"
Enable-ADAccount -Identity "Mieke"
Enable-ADAccount -Identity "¨Piet"


## Computers
Write-Host "Create workstation for Administratie ..."
New-ADComputer -Name "Admin001" -SamAccountName "Admin001-SRV1" -Path "OU=Computers,OU=Administratie,DC=red,DC=local"

Write-Host "Create workstation for IT Administratie ..."
New-ADComputer -Name "ITAdmin001" -SamAccountName "ITAdmin001-SRV1" -Path "OU=Computers,OU=Adminsitratie,OU=IT Administratie,DC=red,DC=local" -Enabled $True -Location "Gent,BE"

Write-Host "Create workstation for Verkoop ..."
New-ADComputer -Name "Verkoop001" -SamAccountName "Verkoop001-SRV1" -Path "OU=Computers,OU=Verkoop,DC=red,DC=local"

Write-Host "Create workstation for Ontwikkeling ..."
New-ADComputer -Name "Ontwikkeling001" -SamAccountName "Ontwikkeling001-SRV1" -Path "OU=Computers,OU=Ontwikkeling,DC=red,DC=local"

Write-Host "Create workstation for Directie ..."
New-ADComputer -Name "Directie001" -SamAccountName "Directie001-SRV1" -Path "OU=Computers,OU=Directie,DC=red,DC=local"


## Group policy
New-GPLink -Name "Block Software" -Target "OU=Districts,OU=IT,dc=enterprise,dc=com" -LinkEnabled Yes -Enforced Yes
