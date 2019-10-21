# Dit script moet uitgevoerd worden na de installatie van beide DC'S en nadat Papa2 (SCCM Deployment Server) !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! NIET VERGETEN UIT TE VOEREN NADAT PAPA2 IN DOMEIN ZIT EN VOOR SCCM INSTALLATIe!
# aan het domein is toegevoegd Het script zal de AD voorbereiden op de installatie van SCCM
# en ervoor zorgen dat alles goed werkt
# Elke stap wordt uitgelegd met zijn eigen comment

############################################## BELANGRIJK #####################################################################################
# VOER DIT SCRIPT UIT ALS ADMINISTRATOR!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
############################################## BELANGRIJK #####################################################################################

# VARIABLES:
$VBOXdrive = "Z:"
$SCCMAdmin = "SCCMadmin"

# PREFERENCE VARIABLES: (Om Debug,Verbose en informaation info in de Start-Transcript log files te zien)
$DebugPreference = "Continue"
$VerbosePreference = "Continue"
$InformationPreference = "Continue"

# LOG SCRIPT TO FILE (+ op het einde van het script Stop-Transcript doen):
Start-Transcript "C:\ScriptLogs\999_PrepareADforSCCMlog.txt"

# 1) Maakt een admin account aan voor SCCM (SCCMAdmin) en maak hem lid van de Domain Admin group:
# 1.1) Met het Get-Credential command openen we opnieuw een prompt zodat het wachtwoord van deze account
# kan ingegeven worden (password wordt opgeslaan in $SCCMPassword en wordt daarna converted naar een secure string)
$CurrentCredentials = Get-Credential -UserName $env:USERNAME -Message "Credentials required for SCCMAdmin account"
$SCCMPassword = $CurrentCredentials.GetNetworkCredential().Password
$SecureStringPwd = ConvertTo-SecureString "$SCCMPassword" -AsPlainText -Force

# 1.2) Het aanmaken van de SCCM account zelf:
Write-Host "Creating SCCMAdmin account in the AD for the Papa2 server:" -ForeGroundColor "Green"
New-ADUser -GivenName "SCCM" -Surname "Admin" -Name "$SCCMAdmin" -PasswordNeverExpires $true -AccountPassword $SecureStringPwd
New-ADComputer -Name "Papa2"
set-adUser -Enabled $true -Identity "$SCCMAdmin"

# 1.3) Voeg nu de SCCM acocunt toe aan de Domain Admin en Administrators groups zodat hij full domain admin rechten heeft:
Write-host "Adding SCCMAdmin to Domain Admin en Administrators group:" -ForeGroundColor "Green"
Add-ADGroupMember -Identity "Domain Admins" -Members "$SCCMAdmin"
Add-ADGroupMember -Identity "Administrators" -Members "$SCCMAdmin"

# 2) Nu moeten we in ADSIedit (Waar al de instellingen van ADDS staan) een System Management container maken onder de "System"
# 2.1) Verbind met ADSIedit:
# Opmerking: cn=System Zal rechtsreeks verbinding maken met de System container waarin wij onze container in willen opslaan:
$ASDIconnection = [ADSI]"LDAP://localhost:389/cn=System,dc=red,dc=local"

# 2.2) Maak de System Management container aan in ADSIedit:
Write-Host "Creating System Management container in ADSIedit:" -ForeGroundColor "Green"
$SysManContainer = $ASDIconnection.Create("container", "cn=System Management")
$SysManContainer.SetInfo()

# 3) Nu moeten we de permissies (ALLE PERMISSIES!) van deze System Management container delegeren aan de Papa2 server
# Belangrijk hier is dat je ook de instelling "Applies to this object and all descendant objects" moet selecteren
# 3.1) Geef ALLE permissies van deze container aan de Papa2 server:
# Connect met System Management container:
$SystemManagementCN = [ADSI]("LDAP://localhost:389/cn=System Management,cn=System,dc=red,dc=local")

# 3.2) Get Papa2 als computer object:
$SCCMserver = get-adcomputer "Papa2"

# 3.3) Get identity reference van het computer object:
$SID = [System.Security.Principal.SecurityIdentifier] $SCCMserver.SID
$ServerIdentity = [System.Security.Principal.IdentityReference] $SID

# 3.4) Stel permissions in als ALLOW full control (full control = GenericAll hieronder):
# ActiveDirectorySecurityInheritance = Stel permissies in op:
# de System Management container zelf + ALLE DESCENDANT OBJECTS!
$permissions = [System.DirectoryServices.ActiveDirectoryRights] "GenericAll"
$allow = [System.Security.AccessControl.AccessControlType] "Allow"
$inheritanceAll = [System.DirectoryServices.ActiveDirectorySecurityInheritance] "All"

# 3.5) Dit zal de gekozen permissies toepassen op de System Management container:
# in ADSIedit noemt een permission rule "Access rule" (AddAccessRule methode)
Write-Host "Setting permissions of System Management container to Papa2 server" -ForeGroundColor "Green"
$PermissionsRule = New-Object System.DirectoryServices.ActiveDirectoryAccessRule `
$ServerIdentity,$permissions,$allow,$inheritanceAll

$SystemManagementCN.psbase.ObjectSecurity.AddAccessRule($PermissionsRule)
$SystemManagementCN.psbase.commitchanges()

# 4) Extend Active Directory Schema:
# In de SCCM installation folder zit een script (extadsch) dat je moet uitvoeren dat je AD zal uitbereiden
# met additionele attributen waar SCCM gebruik van maakt.
# Dit script staat klaar in de virtualbox shared folder root/ExtendADschema

#4.1) Eerst de folder "ExtendADSchema" uit de VB share folder lokaal kopiëren naar Alfa2 server:
# Dit moet omdat je anders een warning "This file might be unsafe" krijgt.
Copy-Item "$VBOXdrive\ExtendADschema" -Destination "C:\Users\Administrator.red\Desktop" -Recurse

# 4.2) Dan voer je het script (ALS ADMINISTRATOR!) uit om de AD schema te extenden:
Write-Host "Extending AD Schema:" -ForeGroundColor "Green"
Start-Process -Verb RunAs C:\Users\Administrator.red\Desktop\ExtendADschema\extadsch.exe

# NOG STEEDS FAILED TO EXTEND AD SCHEMA ERROR Error 8224?
# Oplossing was: Tweede DomainController stond niet aan. Deze moet aanstaan (voor replication redenen)
# C:\ExtADSch.log check deze log file om te zien of extenden van het AD schema succesvol was

Remove-Item -Path "C:\Users\Administrator.red\Desktop\ExtendADschema" -Force
# Verplaats bovengenoemde log naar desktop van domain admin:
Move-item -Path "C:\ExtADSch.log" -Destination "C:\Users\Administrator.red\Desktop"

 

Stop-Transcript
