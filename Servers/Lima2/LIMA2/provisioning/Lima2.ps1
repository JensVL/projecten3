#install windows fileservices 

Install-WindowsFeature File-Services
Install-WindowsFeature –Name FS-Resource-Manager –IncludeManagementTools
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
Format-Volume -DriveLetter F -FileSystem NTFS -NewFileSystemLabel ITData -Confirm:$False
Format-Volume -DriveLetter G -FileSystem NTFS -NewFileSystemLabel DirData -Confirm:$False
Format-Volume -DriveLetter H -FileSystem NTFS -NewFileSystemLabel AdminData -Confirm:$False
Format-Volume -DriveLetter Y -FileSystem NTFS -NewFileSystemLabel HomeDirs -Confirm:$False
Format-Volume -DriveLetter Z -FileSystem NTFS -NewFileSystemLabel ProfileDirs -Confirm:$False
New-SmbShare -Name "VerkoopData" -Path "D:\" -ChangeAccess AvalonSoft\Administrators `  -FullAccess "AvalonSoft\sales"
New-SmbShare -Name "OntwikkelingData" -Path "E:\" -ChangeAccess AvalonSoft\Administrators `  -FullAccess "AvalonSoft\technical"
New-SmbShare -Name "ItData" -Path "F:\" -ChangeAccess AvalonSoft\Administrators `  -FullAccess "AvalonSoft\IT"
New-SmbShare -Name "DirData" -Path "G:\" -ChangeAccess AvalonSoft\Administrators `  -FullAccess "AvalonSoft\management"
New-SmbShare -Name "AdminData" -Path "H:\" -ChangeAccess AvalonSoft\Administrators `  -FullAccess "AvalonSoft\Administrators"
New-SmbShare -Name "HomeDirs" -Path "Y:\" -ChangeAccess AvalonSoft\Administrators `  -FullAccess "AvalonSoft\*"
New-SmbShare -Name "ProfileDirs" -Path "Z:\" -ChangeAccess AvalonSoft\Administrators `  -FullAccess "AvalonSoft\*"
New-SmbShare -Name "ShareVerkoop" -Path "Z:\" -ChangeAccess AvalonSoft\Administrators `  -FullAccess "AvalonSoft\*"
#Configure shadow storage voor adminData
vssadmin add shadowstorage /for=h: /on=h: /maxsize=2000mb
#Hier komt ps code voor dagleijske schaduw copy te maken
Import-Module -Name "ScheduledTasks"
$Sta = New-ScheduledTaskAction -Execute "powershell" -Argument ".\ShadowCopy.ps1" -WorkingDirectory "C:\vagrant\provisioning"
$Stt = New-ScheduledTaskTrigger -Daily -At 5pm
#Zorgt ervoor dat de taak met "highest privileges" wordt gexecuted.
$Stp = New-ScheduledTaskPrincipal -UserId "vagrant" -RunLevel Highest
$StTaskName="TEST10"
$StDescript="test"
#Registreer de taak in de task scheduler 
Register-ScheduledTask -TaskName $StTaskName -Action $Sta -Description $StDescript -Trigger $Stt -Principal $Stp

New-FsrmQuota -Path "D:\" -Description "limit usage to 0.2GB" -Size 200MB

New-FsrmQuota -Path "E:\" -Description "limit usage to 200MB" -Size 200MB


###Connecting to domain controller using PowerShell
winrm quickconfig
Set-ExecutionPolicy Unrestricted -F
Netsh interface ip set wins name="Local Area Connection" source=static addr=10.0.0.10

#(command not functional yet: keeps opening up credentials prompt AKA not automated! so use in powershell first)
#Add-Computer -ComputerName "Lima2" -LocalCredential "Lima2\vagrant" -DomainName "AvalonSoft.net" -Credential vagrant\vagrant -Restart -Force -Verbose

 

###Creating a new file share:
You'll need to make sure the folder path exists prior to running this command:
New-Item "C:\Shared" –type directory
New-SmbShare -Name Logs -Description "Log Files" -Path C:\Shares\Logs


###Setting share permissions 
#https://docs.microsoft.com/en-us/powershell/module/smbshare/new-smbshare?view=win10-ps
#https://docs.microsoft.com/en-us/powershell/module/smbshare/grant-smbshareaccess?view=win10-ps
#Show all AD users= Get-ADUser -Filter *
#Grant-SmbShareAccess -Name Loggs -AccountName AvalonSoft\Managers -AccessRight Read

#New-SMBShare –Name "Shared" –Path "C:\Shared" ` -ChangeAccess AvalonSoft\Administrators `  -FullAccess "AvalonSoft\sales"

###Setting maximum size for each share

New-FsrmQuota -Path "C:\Shares" -Description "limit usage to 0.2GB" -Size 200MB

