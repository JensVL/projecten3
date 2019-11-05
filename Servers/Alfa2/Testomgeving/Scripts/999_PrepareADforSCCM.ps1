# Dit script moet uitgevoerd worden na de installatie van beide DC'S en nadat Papa2 (SCCM Deployment Server) !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! NIET VERGETEN UIT TE VOEREN NADAT PAPA2 IN DOMEIN ZIT EN VOOR SCCM INSTALLATIe!
# aan het domein is toegevoegd Het script zal de AD voorbereiden op de installatie van SCCM
# en ervoor zorgen dat alles goed werkt
# Elke stap wordt uitgelegd met zijn eigen comment

############################################## BELANGRIJK #####################################################################################
# VOER DIT SCRIPT UIT ALS ADMINISTRATOR ACCOUNT RED\Administrator (password= Admin2019) TIJDENS DE DEMO
############################################## BELANGRIJK #####################################################################################

# VARIABLES:
# --------------------------------------------------------------------------------------------------------
# VOOR INTEGRATIE:
$VBOXdrive = "C:\Scripts_ESXI\Alfa2"

# VOOR VIRTUALBOX TESTING:
# $VBOXdrive = "Z:"
# --------------------------------------------------------------------------------------------------------

$Account = "RED\Administrator"

# PREFERENCE VARIABLES: (Om Debug,Verbose en informaation info in de Start-Transcript log files te zien)
$DebugPreference = "Continue"
$VerbosePreference = "Continue"
$InformationPreference = "Continue"

# LOG SCRIPT TO FILE (+ op het einde van het script Stop-Transcript doen):
Start-Transcript "C:\ScriptLogs\999_PrepareADforSCCMlog.txt"

# 1) Password instellen op Admin2019
$password=ConvertTo-SecureString "Admin2019" -asPlainText -force

# 2) Het aanmaken van de Papa2 computer zelf:
New-ADComputer -Name "Papa2"

# 3) Voeg nu de SCCM acocunt toe aan de Domain Admin en Administrators groups zodat hij full domain admin rechten heeft:
Write-host "Adding Vagrant to Domain Admin en Administrators group:" -ForeGroundColor "Green"
Add-ADGroupMember -Identity "Domain Admins" -Members "Vagrant"
Add-ADGroupMember -Identity "Schema Admins" -Members "Vagrant"
Add-ADGroupMember -Identity "Administrators" -Members "Vagrant"

# 4) Nu moeten we in ADSIedit (Waar al de instellingen van ADDS staan) een System Management container maken onder de "System"
# 4.1) Verbind met ADSIedit:
# Opmerking: cn=System Zal rechtsreeks verbinding maken met de System container waarin wij onze container in willen opslaan:
$ASDIconnection = [ADSI]"LDAP://localhost:389/cn=System,dc=red,dc=local"

# 4.2) Maak de System Management container aan in ADSIedit:
Write-Host "Creating System Management container in ADSIedit:" -ForeGroundColor "Green"
$SysManContainer = $ASDIconnection.Create("container", "cn=System Management")
$SysManContainer.SetInfo()

# 5) Nu moeten we de permissies (ALLE PERMISSIES!) van deze System Management container delegeren aan de Papa2 server
# Belangrijk hier is dat je ook de instelling "Applies to this object and all descendant objects" moet selecteren
# 5.1) Geef ALLE permissies van deze container aan de Papa2 server:
# Connect met System Management container:
$SystemManagementCN = [ADSI]("LDAP://localhost:389/cn=System Management,cn=System,dc=red,dc=local")

# 5.2) Get Papa2 als computer object:
$SCCMserver = get-adcomputer "Papa2"

# 5.3) Get identity reference van het computer object:
$SID = [System.Security.Principal.SecurityIdentifier] $SCCMserver.SID
$ServerIdentity = [System.Security.Principal.IdentityReference] $SID

# 5.4) Stel permissions in als ALLOW full control (full control = GenericAll hieronder):
# ActiveDirectorySecurityInheritance = Stel permissies in op:
# de System Management container zelf + ALLE DESCENDANT OBJECTS!
$permissions = [System.DirectoryServices.ActiveDirectoryRights] "GenericAll"
$allow = [System.Security.AccessControl.AccessControlType] "Allow"
$inheritanceAll = [System.DirectoryServices.ActiveDirectorySecurityInheritance] "All"

# 5.5) Dit zal de gekozen permissies toepassen op de System Management container:
# in ADSIedit noemt een permission rule "Access rule" (AddAccessRule methode)
Write-Host "Setting permissions of System Management container to Papa2 server" -ForeGroundColor "Green"
$PermissionsRule = New-Object System.DirectoryServices.ActiveDirectoryAccessRule `
$ServerIdentity,$permissions,$allow,$inheritanceAll

$SystemManagementCN.psbase.ObjectSecurity.AddAccessRule($PermissionsRule)
$SystemManagementCN.psbase.commitchanges()

# 6) Extend Active Directory Schema:
# In de SCCM installation folder zit een script (extadsch) dat je moet uitvoeren dat je AD zal uitbereiden
# met additionele attributen waar SCCM gebruik van maakt.
# Dit script staat klaar in de virtualbox shared folder root/ExtendADschema

# 6.1) Eerst de folder "ExtendADSchema" uit de VB share folder lokaal kopiëren naar Alfa2 server:
# Dit moet omdat je anders een warning "This file might be unsafe" krijgt.
Copy-Item "$VBOXdrive\ExtendADschema" -Destination "C:\Users\Administrator\Desktop" -Recurse

# 6.2) Dan voer je het script (ALS ADMINISTRATOR!) uit om de AD schema te extenden:
Write-Host "Extending AD Schema:" -ForeGroundColor "Green"
Start-Process "C:\Users\Administrator\Desktop\ExtendADschema\extadsch.exe"

# C:\ExtADSch.log check deze log file om te zien of extenden van het AD schema succesvol was

Stop-Transcript
