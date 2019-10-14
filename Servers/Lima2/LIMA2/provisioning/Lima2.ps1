#Installeert de File-Services rol
if (-not (Get-WindowsFeature -Name File-Services).Installed)
{
    Install-WindowsFeature -Name File-Services
}
#Installeert de FS resource manager en management tools
if (-not (Get-WindowsFeature -Name FS-Resource-Manager).Installed)
{
    Install-WindowsFeature –Name FS-Resource-Manager –IncludeManagementTools
}
#Init disk 0, zodat nieuwe partities aangemaakt kunnen worden. Daarna worden de volumes geformateerd.
Get-Disk 0 | Initialize-Disk
Resize-Partition -DiskNumber 0 -PartitionNumber 2 -Size (30GB)
New-Partition -DiskNumber 0 -Size 5GB -DriveLetter D
New-Partition -DiskNumber 0 -Size 5GB -DriveLetter E
Format-Volume -DriveLetter D -FileSystem NTFS -NewFileSystemLabel VerkoopData -Confirm:$False
Format-Volume -DriveLetter E -FileSystem NTFS -NewFileSystemLabel OntwikkelingData -Confirm:$False
#Init disk 1
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
#Nieuwe shares worden aangemaak, benoemd en krijgen een pad.
New-SmbShare -Name "VerkoopData" -Path "D:\"
New-SmbShare -Name "OntwikkelingData" -Path "E:\"
New-SmbShare -Name "ItData" -Path "F:\"
New-SmbShare -Name "DirData" -Path "G:\"
New-SmbShare -Name "AdminData" -Path "H:\"
New-SmbShare -Name "HomeDirs" -Path "Y:\"
New-SmbShare -Name "ProfileDirs" -Path "Z:\"
#Configure shadow storage voor adminData
vssadmin add shadowstorage /for=h: /on=h: /maxsize=2000mb
#Hier komt ps code voor dagleijske schaduw copy te maken


###Creating a new file share:
You'll need to make sure the folder path exists prior to running this command:
New-SmbShare -Name Logs -Description "Log Files" -Path C:\Shares\Logs


###Create groups (MUST BE DONE BY DC TECHNICALLY)


###Setting share permissions 
#https://docs.microsoft.com/en-us/powershell/module/smbshare/grant-smbshareaccess?view=win10-ps

Grant-SmbShareAccess -Name Loggs -AccountName AvalonSoft\Managers -AccessRight Read
