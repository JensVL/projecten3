#install windows fileservices 

Install-WindowsFeature File-Services
Install-WindowsFeature –Name FS-Resource-Manager –IncludeManagementTools


Resize-Partition -DiskNumber 0 -PartitionNumber 2 -Size 30GB
Resize-Partition -DiskNumber 0 -PartitionNumber 1 -Size 30GB

Get-Disk 0 | Initialize-Disk
New-Partition -DiskNumber 0 -Size 5GB -DriveLetter D
New-Partition -DiskNumber 0 -Size 5GB -DriveLetter E

Format-Volume -DriveLetter D -FileSystem NTFS -NewFileSystemLabel VerkoopData -Confirm:$False
Format-Volume -DriveLetter E -FileSystem NTFS -NewFileSystemLabel OntwikkelingData -Confirm:$False
Get-Disk 1 | Initialize-Disk
New-Partition -DiskNumber 1 -Size 5GB -DriveLetter F
New-Partition -DiskNumber 1 -Size 5GB -DriveLetter G
New-Partition -DiskNumber 1 -Size 5GB -DriveLetter H
New-Partition -DiskNumber 1 -Size 5GB -DriveLetter Y
New-Partition -DiskNumber 1 -Size 5GB -DriveLetter Z
New-Partition -DiskNumber 1 -Size 5GB -DriveLetter Q
Format-Volume -DriveLetter F -FileSystem NTFS -NewFileSystemLabel ITData -Confirm:$False
Format-Volume -DriveLetter G -FileSystem NTFS -NewFileSystemLabel DirData -Confirm:$False
Format-Volume -DriveLetter H -FileSystem NTFS -NewFileSystemLabel AdminData -Confirm:$False
Format-Volume -DriveLetter Y -FileSystem NTFS -NewFileSystemLabel HomeDirs -Confirm:$False
Format-Volume -DriveLetter Z -FileSystem NTFS -NewFileSystemLabel ProfileDirs -Confirm:$False
Format-Volume -DriveLetter Q -FileSystem NTFS -NewFileSystemLabel ShareVerkoop -Confirm:$False

New-Item -ItemType directory -Path D:\Shares\VerkoopData
New-Item -ItemType directory -Path E:\Shares\OntwikkelingData
New-Item -ItemType directory -Path F:\Shares\ITData
New-Item -ItemType directory -Path G:\Shares\DirDATA
New-Item -ItemType directory -Path H:\Shares\AdminData
New-Item -ItemType directory -Path Q:\Shares\ShareVerkoop
New-Item -ItemType directory -Path Y:\Shares\HomeDirs
New-Item -ItemType directory -Path Z:\Shares\ProfileDirs

New-SmbShare -Name "VerkoopData" -Path "D:\Shares\VerkoopData" -ChangeAccess "red\IT_Administratie" -FullAccess "red\Verkoop"
New-SmbShare -Name "OntwikkelingData" -Path "E:\Shares\OntwikkelingData" -ChangeAccess "red\IT_Administratie" -FullAccess "red\Ontwikkeling"
New-SmbShare -Name "ItData" -Path "F:\Shares\ITData" -ChangeAccess "red\IT_Administratie" 
New-SmbShare -Name "DirData" -Path "G:\Shares\DirData" -ChangeAccess "red\IT_Administratie" -FullAccess "red\Directie" 
New-SmbShare -Name "AdminData" -Path "H:\Shares\AdminData" -ChangeAccess "red\IT_Administratie" 
New-SmbShare -Name "HomeDirs" -Path "Y:\Shares\HomeDirs" -ChangeAccess "red\IT_Administratie" -FullAccess "everyone"
New-SmbShare -Name "ProfileDirs" -Path "Z:\Shares\ProfileDirs"  -ChangeAccess "red\IT_Administratie" -FullAccess "everyone"
New-SmbShare -Name "ShareVerkoop" -Path "Q:\Shares\ShareVerkoop" -ChangeAccess "red\IT_Administratie" -ReadAccess "red\Ontwikkeling"
#Configure shadow storage voor adminData
vssadmin add shadowstorage /for=h: /on=h: /maxsize=2000mb
#Hier komt ps code voor dagleijske schaduw copy te maken

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

$permessiesOntwikkelingRead = "red\Directie","FullControl","Allow"


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

$acl1 = Get-Acl E:/Shares/OntwikkelingData
$newRule1 = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule($permessiesVerkoopDeny)
$newRule2 = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule($permessiesITAllow)
$newRule3 = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule($permessiesDirectieDeny)
$newRule4 = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule($permessiesOntwikkelingAllow)
$acl1.SetAccessRule($newRule1)
Set-Acl E:/Shares/VerkoopData -AclObject $acl1
$acl1.SetAccessRule($newRule2)
Set-Acl E:/Shares/VerkoopData -AclObject $acl1
$acl1.SetAccessRule($newRule3)
Set-Acl E:/Shares/VerkoopData -AclObject $acl1
$acl1.SetAccessRule($newRule4)
Set-Acl E:/Shares/VerkoopData -AclObject $acl1

Start-sleep 5

$acl1 = Get-Acl F:/Shares/ItData
$newRule1 = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule($permessiesVerkoopDeny)
$newRule2 = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule($permessiesITAllow)
$newRule3 = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule($permessiesDirectieDeny)
$newRule4 = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule($permessiesOntwikkelingDeny)
$acl1.SetAccessRule($newRule1)
Set-Acl F:/Shares/VerkoopData -AclObject $acl1
$acl1.SetAccessRule($newRule2)
Set-Acl F:/Shares/VerkoopData -AclObject $acl1
$acl1.SetAccessRule($newRule3)
Set-Acl F:/Shares/VerkoopData -AclObject $acl1
$acl1.SetAccessRule($newRule4)
Set-Acl F:/Shares/VerkoopData -AclObject $acl1

Start-sleep 5

$acl1 = Get-Acl G:/Shares/directory
$newRule1 = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule($permessiesVerkoopDeny)
$newRule2 = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule($permessiesITAllow)
$newRule3 = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule($permessiesDirectieAllow)
$newRule4 = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule($permessiesOntwikkelingDeny)
$acl1.SetAccessRule($newRule1)
Set-Acl G:/Shares/VerkoopData -AclObject $acl1
$acl1.SetAccessRule($newRule2)
Set-Acl G:/Shares/VerkoopData -AclObject $acl1
$acl1.SetAccessRule($newRule3)
Set-Acl G:/Shares/VerkoopData -AclObject $acl1
$acl1.SetAccessRule($newRule4)
Set-Acl G:/Shares/VerkoopData -AclObject $acl1

Start-sleep 5

$acl1 = Get-Acl H:/Shares/AdminData
$newRule1 = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule($permessiesVerkoopDeny)
$newRule2 = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule($permessiesITAllow)
$newRule3 = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule($permessiesDirectieDeny)
$newRule4 = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule($permessiesOntwikkelingDeny)
$acl1.SetAccessRule($newRule1)
Set-Acl H:/Shares/VerkoopData -AclObject $acl1
$acl1.SetAccessRule($newRule2)
Set-Acl H:/Shares/VerkoopData -AclObject $acl1
$acl1.SetAccessRule($newRule3)
Set-Acl H:/Shares/VerkoopData -AclObject $acl1
$acl1.SetAccessRule($newRule4)
Set-Acl H:/Shares/VerkoopData -AclObject $acl1

Start-sleep 5

$acl1 = Get-Acl Y:/Shares/HomeDirs
$newRule1 = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule($permessiesVerkoopAllow)
$newRule2 = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule($permessiesITAllow)
$newRule3 = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule($permessiesDirectieAllow)
$newRule4 = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule($permessiesOntwikkelingAllow)
$acl1.SetAccessRule($newRule1)
Set-Acl Y:/Shares/VerkoopData -AclObject $acl1
$acl1.SetAccessRule($newRule2)
Set-Acl Y:/Shares/VerkoopData -AclObject $acl1
$acl1.SetAccessRule($newRule3)
Set-Acl Y:/Shares/VerkoopData -AclObject $acl1
$acl1.SetAccessRule($newRule4)
Set-Acl Y:/Shares/VerkoopData -AclObject $acl1

Start-sleep 5

$acl1 = Get-Acl Z:/Shares/ProfileDirs
$newRule1 = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule($permessiesVerkoopAllow)
$newRule2 = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule($permessiesITAllow)
$newRule3 = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule($permessiesDirectieAllow)
$newRule4 = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule($permessiesOntwikkelingAllow)
$acl1.SetAccessRule($newRule1)
Set-Acl Z:/Shares/VerkoopData -AclObject $acl1
$acl1.SetAccessRule($newRule2)
Set-Acl Z:/Shares/VerkoopData -AclObject $acl1
$acl1.SetAccessRule($newRule3)
Set-Acl Z:/Shares/VerkoopData -AclObject $acl1
$acl1.SetAccessRule($newRule4)
Set-Acl Z:/Shares/VerkoopData -AclObject $acl1

Start-sleep 5

$acl8 = Get-Acl Q:/Shares/ShareVerkoop
$newRule1 = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule($permessiesVerkoopAllow)
$newRule2 = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule($permessiesITAllow)
$newRule3 = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule($permessiesDirectieDeny)
$newRule4 = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule($permessiesOntwikkelingRead)
$acl1.SetAccessRule($newRule1)
Set-Acl Y:/Shares/VerkoopData -AclObject $acl1
$acl1.SetAccessRule($newRule2)
Set-Acl Y:/Shares/VerkoopData -AclObject $acl1
$acl1.SetAccessRule($newRule3)
Set-Acl Y:/Shares/VerkoopData -AclObject $acl1
$acl1.SetAccessRule($newRule4)
Set-Acl Y:/Shares/VerkoopData -AclObject $acl1
Start-sleep 5



#configureer maximum capaciteits quotas
New-FSRMQuotaTemplate -Name "AdminData Quota" -Size 100MB
New-FSRMQuotaTemplate -Name "VerkoopData Quota" -Size 100MB
New-FSRMQuotaTemplate -Name "DirDATA Quota" -Size 100MB
New-FSRMQuotaTemplate -Name "OntwikkelingData Quota" -Size 200MB
New-FSRMQuotaTemplate -Name "ITData Quota" -Size 200MB


###Connecting to domain controller using PowerShell
winrm quickconfig
#Set-ExecutionPolicy Unrestricted -F
Netsh interface ip set wins name="Local Area Connection" source=static addr=10.0.0.10

#(command not functional yet: keeps opening up credentials prompt AKA not automated! so use in powershell first)
#Add-Computer -ComputerName "Lima2" -LocalCredential "Lima2\vagrant" -DomainName "AvalonSoft.net" -Credential vagrant\vagrant -Restart -Force -Verbose

###Setting share permissions 
#https://docs.microsoft.com/en-us/powershell/module/smbshare/new-smbshare?view=win10-ps
#https://docs.microsoft.com/en-us/powershell/module/smbshare/grant-smbshareaccess?view=win10-ps
#Show all AD users= Get-ADUser -Filter *
#Grant-SmbShareAccess -Name Loggs -AccountName AvalonSoft\Managers -AccessRight Read

#New-SMBShare –Name "Shared" –Path "C:\Shared" ` -ChangeAccess RED\Verkoop`  -FullAccess "RED\Verkoop"

