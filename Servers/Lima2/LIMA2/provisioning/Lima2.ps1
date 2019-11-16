#install windows fileservices 
if (!((Get-WindowsFeature -Name File-Services)).Installed)
{
	Install-WindowsFeature File-Services
}

Install-WindowsFeature -Name FS-Resource-Manager -IncludeManagementTools

Resize-Partition -DiskNumber 0 -PartitionNumber 2 -Size 30GB

#Disk 2 initiliseren. Anders kunnen er geen partities aangemaakt worden.
Get-Disk 0 | Initialize-Disk

#Alle partities aanmaken op disk 0 en deze direct formateren indien deze nog niet bestaan.
if (!(Test-Path D:))
{
	New-Partition -DiskNumber 0 -Size 5GB -DriveLetter D
	Format-Volume -DriveLetter D -FileSystem NTFS -NewFileSystemLabel VerkoopData -Confirm:$False
}

if (!(Test-Path E:))
{
	New-Partition -DiskNumber 0 -Size 5GB -DriveLetter E
	Format-Volume -DriveLetter E -FileSystem NTFS -NewFileSystemLabel OntwikkelingData -Confirm:$False
}

#Disk 1 initiliseren. Anders kunnen er geen partities aangemaakt worden.
Get-Disk 1 | Initialize-Disk

#Alle partities aanmaken op disk 1 en deze direct formateren indien deze nog niet bestaan.
if (!(Test-Path F:))
{
	New-Partition -DiskNumber 1 -Size 5GB -DriveLetter F
	Format-Volume -DriveLetter F -FileSystem NTFS -NewFileSystemLabel ITData -Confirm:$False
}
if (!(Test-Path G:))
{
	New-Partition -DiskNumber 1 -Size 5GB -DriveLetter G
	Format-Volume -DriveLetter G -FileSystem NTFS -NewFileSystemLabel DirData -Confirm:$False
}
if (!(Test-Path H:))
{
	New-Partition -DiskNumber 1 -Size 5GB -DriveLetter H
	Format-Volume -DriveLetter H -FileSystem NTFS -NewFileSystemLabel AdminData -Confirm:$False
}
if (!(Test-Path Y:))
{
	New-Partition -DiskNumber 1 -Size 5GB -DriveLetter Y
	Format-Volume -DriveLetter Y -FileSystem NTFS -NewFileSystemLabel HomeDirs -Confirm:$False
}
if (!(Test-Path P:))
{
	New-Partition -DiskNumber 1 -Size 5GB -DriveLetter P
	Format-Volume -DriveLetter P -FileSystem NTFS -NewFileSystemLabel ProfileDirs -Confirm:$False
}
if (!(Test-Path Q:))
{
	New-Partition -DiskNumber 1 -Size 5GB -DriveLetter Q
	Format-Volume -DriveLetter Q -FileSystem NTFS -NewFileSystemLabel ShareVerkoop -Confirm:$False
}

New-Item -ItemType directory -Path D:\Shares\VerkoopData
New-Item -ItemType directory -Path E:\Shares\OntwikkelingData
New-Item -ItemType directory -Path F:\Shares\ITData
New-Item -ItemType directory -Path G:\Shares\DirData
New-Item -ItemType directory -Path H:\Shares\AdminData
New-Item -ItemType directory -Path Q:\Shares\ShareVerkoop
New-Item -ItemType directory -Path Y:\Shares\HomeDirs
New-Item -ItemType directory -Path P:\Shares\ProfileDirs

#Alle shares aanmaken indien deze nog niet bestaan.
if(!(Get-SmbShare -Name VerkoopData -ea 0))
{
	New-SmbShare -Name "VerkoopData" -Path "D:\Shares\VerkoopData" -ChangeAccess "red\IT_Administratie" -FullAccess "red\Verkoop"
}
if(!(Get-SmbShare -Name OntwikkelingData -ea 0))
{
	New-SmbShare -Name "OntwikkelingData" -Path "E:\Shares\OntwikkelingData" -ChangeAccess "red\IT_Administratie" -FullAccess "red\Ontwikkeling"
}
if(!(Get-SmbShare -Name ItData -ea 0))
{
	New-SmbShare -Name "ITData" -Path "F:\Shares\ITData" -ChangeAccess "red\IT_Administratie" 
}
if(!(Get-SmbShare -Name DirData -ea 0))
{
	New-SmbShare -Name "DirData" -Path "G:\Shares\DirData" -ChangeAccess "red\IT_Administratie" -FullAccess "red\Directie"
}
if(!(Get-SmbShare -Name AdminData -ea 0))
{
	New-SmbShare -Name "AdminData" -Path "H:\Shares\AdminData" -ChangeAccess "red\IT_Administratie"
}
if(!(Get-SmbShare -Name HomeDirs -ea 0))
{
	New-SmbShare -Name "HomeDirs" -Path "Y:\Shares\HomeDirs" -ChangeAccess "red\IT_Administratie" -FullAccess "everyone"
}
if(!(Get-SmbShare -Name ProfileDirs -ea 0))
{
	New-SmbShare -Name "ProfileDirs" -Path "P:\Shares\ProfileDirs"  -ChangeAccess "red\IT_Administratie" -FullAccess "everyone"
}
if(!(Get-SmbShare -Name ShareVerkoop -ea 0))
{
	New-SmbShare -Name "ShareVerkoop" -Path "Q:\Shares\ShareVerkoop" -ChangeAccess "red\IT_Administratie" -ReadAccess "red\Ontwikkeling"
}

#Deze blok maakt een nieuwe scheduled task aan.
#Als de taak nog niet bestaat wordt er 2000mb shadowstorage toegevoegd aan adminData.
#Deze taak bevat enkele belangrijke variabelen:
#Sta: Zorgt ervoor dat deze scheduled task het script ShadowCopy.ps1 uitvoert.
#Stt: De trigger die ervoor zorgt dat het elke dag uitgevoerd wordt.
#Op het einde wordt deze taak geregistreerd in de scheduler.

#Configure shadow storage voor adminData
vssadmin add shadowstorage /for=h: /on=h: /maxsize=2000mb
#Hier komt ps code voor dagelijkse schadow copy te maken
Import-Module -Name "ScheduledTasks"
$Sta = New-ScheduledTaskAction -Execute "powershell" -Argument "-ExecutionPolicy Bypass C:\Scripts_ESXI\Lima2\ShadowCopy.ps1"
$Stt = New-ScheduledTaskTrigger -Daily -At 5pm
#Zorgt ervoor dat de taak met "highest privileges" wordt gexecuted.
$Stp = New-ScheduledTaskPrincipal -UserId "Administrator" -RunLevel Highest
$StTaskName="ShadowCopy"
$StDescript="Maakt een dagelijske shaduw kopie van AdminData"
#Registreer de taak in de task scheduler 
Register-ScheduledTask -TaskName $StTaskName -Action $Sta -Description $StDescript -Trigger $Stt -Principal $Stp
Start-sleep 10

###Setting share permissions 

$permessiesVerkoopDeny = "red\Verkoop","FullControl","Deny"
$permessiesOntwikkelingDeny = "red\Ontwikkeling","FullControl","Deny"
#$permessiesITDeny = "red\IT_Administratie","FullControl","Deny"
$permessiesDirectieDeny = "red\Directie","FullControl","Deny"

$permessiesVerkoopAllow = "red\Verkoop","Write","Allow"
$permessiesOntwikkelingAllow = "red\Ontwikkeling","Write","Allow"
$permessiesITAllow = "red\IT_Administratie","FullControl","Allow"
$permessiesDirectieAllow = "red\Directie","FullControl","Allow"

$permessiesOntwikkelingRead = "red\Directie","Read","Allow"

$acl1 = Get-Acl D:/Shares/VerkoopData
$newRule1 = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule($permessiesVerkoopAllow)
$newRule2 = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule($permessiesITAllow)
$newRule3 = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule($permessiesDirectieDeny)
$newRule4 = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule($permessiesOntwikkelingDeny)
$acl1.SetAccessRule($newRule1)
Set-Acl D:/Shares/VerkoopData -AclObject $acl1
$acl1.SetAccessRule($newRule2)
Set-Acl D:/Shares/VerkoopData -AclObject $acl1
$acl1.SetAccessRule($newRule3)
Set-Acl D:/Shares/VerkoopData -AclObject $acl1
$acl1.SetAccessRule($newRule4)
Set-Acl D:/Shares/VerkoopData -AclObject $acl1

Start-sleep 5

$acl2 = Get-Acl E:/Shares/OntwikkelingData
$newRule1 = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule($permessiesVerkoopDeny)
$newRule2 = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule($permessiesITAllow)
$newRule3 = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule($permessiesDirectieDeny)
$newRule4 = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule($permessiesOntwikkelingAllow)
$acl2.SetAccessRule($newRule1)
Set-Acl E:/Shares/OntwikkelingData -AclObject $acl2
$acl2.SetAccessRule($newRule2)
Set-Acl E:/Shares/OntwikkelingData -AclObject $acl2
$acl2.SetAccessRule($newRule3)
Set-Acl E:/Shares/OntwikkelingData -AclObject $acl2
$acl2.SetAccessRule($newRule4)
Set-Acl E:/Shares/OntwikkelingData -AclObject $acl2

Start-sleep 5

$acl3 = Get-Acl F:/Shares/ITData
$newRule1 = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule($permessiesVerkoopDeny)
$newRule2 = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule($permessiesITAllow)
$newRule3 = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule($permessiesDirectieDeny)
$newRule4 = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule($permessiesOntwikkelingDeny)
$acl3.SetAccessRule($newRule1)
Set-Acl F:/Shares/ITData -AclObject $acl3
$acl3.SetAccessRule($newRule2)
Set-Acl F:/Shares/ITData -AclObject $acl3
$acl3.SetAccessRule($newRule3)
Set-Acl F:/Shares/ITData -AclObject $acl3
$acl3.SetAccessRule($newRule4)
Set-Acl F:/Shares/ITData -AclObject $acl3

Start-sleep 5

$acl4 = Get-Acl G:/Shares/DirData
$newRule1 = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule($permessiesVerkoopDeny)
$newRule2 = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule($permessiesITAllow)
$newRule3 = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule($permessiesDirectieAllow)
$newRule4 = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule($permessiesOntwikkelingDeny)
$acl4.SetAccessRule($newRule1)
Set-Acl G:/Shares/DirData -AclObject $acl4
$acl4.SetAccessRule($newRule2)
Set-Acl G:/Shares/DirData -AclObject $acl4
$acl4.SetAccessRule($newRule3)
Set-Acl G:/Shares/DirData -AclObject $acl4
$acl4.SetAccessRule($newRule4)
Set-Acl G:/Shares/DirData -AclObject $acl4

Start-sleep 5

$acl5 = Get-Acl H:/Shares/AdminData
$newRule1 = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule($permessiesVerkoopDeny)
$newRule2 = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule($permessiesITAllow)
$newRule3 = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule($permessiesDirectieDeny)
$newRule4 = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule($permessiesOntwikkelingDeny)
$acl5.SetAccessRule($newRule1)
Set-Acl H:/Shares/AdminData -AclObject $acl5
$acl5.SetAccessRule($newRule2)
Set-Acl H:/Shares/AdminData -AclObject $acl5
$acl5.SetAccessRule($newRule3)
Set-Acl H:/Shares/AdminData -AclObject $acl5
$acl5.SetAccessRule($newRule4)
Set-Acl H:/Shares/AdminData -AclObject $acl5

Start-sleep 5

$acl6 = Get-Acl Y:/Shares/HomeDirs
$newRule1 = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule($permessiesVerkoopAllow)
$newRule2 = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule($permessiesITAllow)
$newRule3 = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule($permessiesDirectieAllow)
$newRule4 = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule($permessiesOntwikkelingAllow)
$acl6.SetAccessRule($newRule1)
Set-Acl Y:/Shares/HomeDirs -AclObject $acl6
$acl6.SetAccessRule($newRule2)
Set-Acl Y:/Shares/HomeDirs -AclObject $acl6
$acl6.SetAccessRule($newRule3)
Set-Acl Y:/Shares/HomeDirs -AclObject $acl6
$acl6.SetAccessRule($newRule4)
Set-Acl Y:/Shares/HomeDirs -AclObject $acl6

Start-sleep 5

$acl7 = Get-Acl P:/Shares/ProfileDirs
$newRule1 = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule($permessiesVerkoopAllow)
$newRule2 = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule($permessiesITAllow)
$newRule3 = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule($permessiesDirectieAllow)
$newRule4 = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule($permessiesOntwikkelingAllow)
$acl7.SetAccessRule($newRule1)
Set-Acl P:/Shares/ProfileDirs -AclObject $acl7
$acl7.SetAccessRule($newRule2)
Set-Acl P:/Shares/ProfileDirs -AclObject $acl7
$acl7.SetAccessRule($newRule3)
Set-Acl P:/Shares/ProfileDirs -AclObject $acl7
$acl7.SetAccessRule($newRule4)
Set-Acl P:/Shares/ProfileDirs -AclObject $acl7

Start-sleep 5

$acl8 = Get-Acl Q:/Shares/ShareVerkoop
$newRule1 = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule($permessiesVerkoopAllow)
$newRule2 = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule($permessiesITAllow)
$newRule3 = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule($permessiesDirectieDeny)
$newRule4 = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule($permessiesOntwikkelingRead)
$acl8.SetAccessRule($newRule1)
Set-Acl Q:/Shares/ShareVerkoop -AclObject $acl8
$acl8.SetAccessRule($newRule2)
Set-Acl Q:/Shares/ShareVerkoop -AclObject $acl8
$acl8.SetAccessRule($newRule3)
Set-Acl Q:/Shares/ShareVerkoop -AclObject $acl8
$acl8.SetAccessRule($newRule4)
Set-Acl Q:/Shares/ShareVerkoop -AclObject $acl8
Start-sleep 5

#configureer maximum capaciteits quotas
#New-FSRMQuota -Name "AdminData Quota" -Size 100MB
#New-FSRMQuota -Name "VerkoopData Quota" -Size 100MB
#New-FSRMQuota -Name "DirData Quota" -Size 100MB
#New-FSRMQuota -Name "OntwikkelingData Quota" -Size 200MB
#New-FSRMQuota -Name "ITData Quota" -Size 200MB

New-FSRMQuota -Path "H:\" -Size 100MB
New-FSRMQuota -Path "D:\" -Size 100MB
New-FSRMQuota -Path "G:\" -Size 100MB
New-FSRMQuota -Path "E:\" -Size 200MB
New-FSRMQuota -Path "F:\" -Size 200MB

#Firewall uitzetten
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False

###Connecting to domain controller using PowerShell
#winrm quickconfig
#Set-ExecutionPolicy Unrestricted -F
#Netsh interface ip set wins name="Local Area Connection" source=static addr=10.0.0.10

#(command not functional yet: keeps opening up credentials prompt AKA not automated! so use in powershell first)
#Add-Computer -ComputerName "Lima2" -LocalCredential "Lima2\vagrant" -DomainName "AvalonSoft.net" -Credential vagrant\vagrant -Restart -Force -Verbose

###Setting share permissions 
#https://docs.microsoft.com/en-us/powershell/module/smbshare/new-smbshare?view=win10-ps
#https://docs.microsoft.com/en-us/powershell/module/smbshare/grant-smbshareaccess?view=win10-ps
#Show all AD users= Get-ADUser -Filter *
#Grant-SmbShareAccess -Name Loggs -AccountName AvalonSoft\Managers -AccessRight Read

#New-SMBShare –Name "Shared" –Path "C:\Shared" ` -ChangeAccess RED\Verkoop`  -FullAccess "RED\Verkoop"