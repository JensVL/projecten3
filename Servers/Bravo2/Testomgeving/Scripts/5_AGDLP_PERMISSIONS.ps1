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
net use g: $DirData /P:Yes
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

New-ADGroup -Name "ALLE_AFDELINGEN" -Path "DC=red,DC=local" -GroupCategory "Security" -GroupScope "DomainLocal"

New-ADGroup -Name "R_SHAREVERKOOP" -Path "DC=red,DC=local" -GroupCategory "Security" -GroupScope "DomainLocal"
New-ADGroup -Name "RW_SHAREVERKOOP" -Path "DC=red,DC=local" -GroupCategory "Security" -GroupScope "DomainLocal"


# 4) Voeg de Domain local groups toe als members juiste van de global groups:
Add-LocalGroupMember -Group "RW_VERKOOP" -Member "Verkoop"
Add-LocalGroupMember -Group "RW_ONTWIKKELING" -Member "Ontwikkeling"
Add-LocalGroupMember -Group "RW_DIRECTIE" -Member "Directie"
Add-LocalGroupMember -Group "RW_ADMIN" -Member "Administratie"

Add-LocalGroupMember -Group "FullAccess_IT" -Member "IT_Administratie"

# PROFILESDIR EN HOMEDIRS => alle afdelingen in ALLE_AFDELINGEN group:
Add-LocalGroupMember -Group "ALLE_AFDELINGEN" -Member "Verkoop","Ontwikkeling","Directie","Administratie","IT_Administratie"

# Shareverkoop RW en R permissies apart:
Add-LocalGroupMember -Group "RW_SHAREVERKOOP" -Member "Verkoop"
Add-LocalGroupMember -Group "R_SHAREVERKOOP" -Member "Ontwikkeling"

# 5) Geef de nodige permissies/rechten op de shared folders volgens de opdrachtomschrijving:
Write-Host "Assigning permissions to the Lima2:" -ForeGroundColor "Green"


# 5.1) Verkoopdata: (+ RW voor ShareVerkoop folder)
$ACL = Get-ACL "$Verkoopdata"
$Permissies = New-Object System.Security.AccessControl.FileSystemAccessRule("RW_VERKOOP","Read", `
                         "ContainerInherit,ObjectInherit","InheritOnly","Allow")  # Read permissions
$ACL.SetAccessRule($Permissies)

$Permissies = New-Object System.Security.AccessControl.FileSystemAccessRule("RW_VERKOOP","Write", `
                         "ContainerInherit,ObjectInherit","InheritOnly","Allow")  # Write permissions
$ACL.AddAccessRule($Permissies)

Set-ACL "$Verkoopdata" $ACL
# ook read write permissions aan shareverkoop folder geven:
Set-ACL "$ShareVerkoop" $ACL


# 5.2) Ontwikkelingdata:
$ACL = Get-ACL "$OntwikkelingData"
$Permissies = New-Object System.Security.AccessControl.FileSystemAccessRule("RW_ONTWIKKELING","Read", `
                         "ContainerInherit,ObjectInherit","InheritOnly","Allow")  # Read permissions
$ACL.SetAccessRule($Permissies)

$Permissies = New-Object System.Security.AccessControl.FileSystemAccessRule("RW_ONTWIKKELING","Write", `
                         "ContainerInherit,ObjectInherit","InheritOnly","Allow")  # Write permissions
$ACL.AddAccessRule($Permissies)

Set-ACL "$OntwikkelingData" $ACL


# 5.3) Dirdata:
$ACL = Get-ACL "$DirData"
$Permissies = New-Object System.Security.AccessControl.FileSystemAccessRule("RW_DIRECTIE","Read", `
                         "ContainerInherit,ObjectInherit","InheritOnly","Allow")  # Read permissions
$ACL.SetAccessRule($Permissies)

$Permissies = New-Object System.Security.AccessControl.FileSystemAccessRule("RW_DIRECTIE","Write", `
                         "ContainerInherit,ObjectInherit","InheritOnly","Allow")  # Write permissions
$ACL.AddAccessRule($Permissies)

Set-ACL "$DirData" $ACL


# 5.4) Admindata:
$ACL = Get-ACL "$AdminData"
$Permissies = New-Object System.Security.AccessControl.FileSystemAccessRule("RW_ADMIN","Read", `
                         "ContainerInherit,ObjectInherit","InheritOnly","Allow")  # Read permissions
$ACL.SetAccessRule($Permissies)

$Permissies = New-Object System.Security.AccessControl.FileSystemAccessRule("RW_ADMIN","Write", `
                         "ContainerInherit,ObjectInherit","InheritOnly","Allow")  # Write permissions
$ACL.AddAccessRule($Permissies)

Set-ACL "$AdminData" $ACL


# 5.5) Full Access IT data:
$ACL = Get-ACL "$ITData"
$Permissies = New-Object System.Security.AccessControl.FileSystemAccessRule("FullAccess_IT","FullControl", `
                         "ContainerInherit,ObjectInherit","InheritOnly","Allow")  # Full Control for FullAccess_IT group
$ACL.SetAccessRule($Permissies)
Set-ACL "$ITData" $ACL

Set-ACL "$VerkoopData" $ACL
Set-ACL "$OntwikkelingData" $ACL
Set-ACL "$DirData" $ACL
Set-ACL "$AdminData" $ACL
Set-ACL "$Shareverkoop" $ACL
Set-ACL "$Profiledirs" $ACL
Set-ACL "$Homedirs" $ACL


# 5.6 Shareverkoop:
$ACL = Get-ACL "$ShareVerkoop"
$Permissies = New-Object System.Security.AccessControl.FileSystemAccessRule("RW_ONTWIKKELING","Read", `
                         "ContainerInherit,ObjectInherit","InheritOnly","Allow")  # Read permissions ontwikkeling
$ACL.SetAccessRule($Permissies)

Set-ACL "$ShareVerkoop" $ACL


# 5.7) Profile en home dirs algemeen per afdeling read / write:
      $ACL = Get-Acl "$Homedirs"
      $Permissies = New-Object System.Security.AccessControl.FileSystemAccessRule("ALLE_AFDELINGEN","Read", `
                               "ContainerInherit,ObjectInherit","InheritOnly","Allow")  # Read permissions ontwikkeling
      $ACL.SetAccessRule($Permissies)
      $Permissies = New-Object System.Security.AccessControl.FileSystemAccessRule("ALLE_AFDELINGEN","Write", `
                               "ContainerInherit,ObjectInherit","InheritOnly","Allow")  # Write permissions verkoop
      $ACL.AddAccessRule($Permissies)

      Set-ACL "$Homedirs" $ACL
      Set-ACL "$Profiledirs" $ACL

# 5.8) Profile en Home dirs individueel per gebruiker:
# TODO: USERNAMEN INVULLEN HIER (SAMacocuntname?) + checken of Home/profile via new-aduser moet worden aangemaakt TODO TODO TODO
 $REDLOCALUSERS = @
                  ("user1", "user2", "user3")
                  @

Write-Host "Assigning correct permissions to each AD user's profile and home directory:"
ForEach ($GEBRUIKER in $REDLOCALUSERS) {
#     HOMEFOLDERS:  Permissions op modify zetten
      $HomeFolder = $Homedirs\$GEBRUIKER
      $ACL = Get-ACL "$HomeFolder"

      $Permissies = New-Object System.Security.AccessControl.FileSystemAccessRule("$GEBRUIKER","Modify", `
                               "ContainerInherit,ObjectInherit","InheritOnly","Allow")  # Read permissions ontwikkeling
      $ACL.SetAccessRule($Permissies)

      Set-ACL "$HomeFolder" $ACL

#    PROFILE FOLDERS: Permissions op modify zetten
      $ProfileFolder = $Profiledirs\$GEBRUIKER
      $ACL = Get-ACL "$ProfileFolder"

      $Permissies = New-Object System.Security.AccessControl.FileSystemAccessRule("$GEBRUIKER","Modify", `
                               "ContainerInherit,ObjectInherit","InheritOnly","Allow")  # Read permissions ontwikkeling
      $ACL.SetAccessRule($Permissies)

      Set-ACL "$ProfileFolder" $ACL
 }

# 6) Zet Auto login terug af:
 Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name AutoAdminLogon -Value 0
 Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name ForceAutoLogon -Value 0

Stop-Transcript