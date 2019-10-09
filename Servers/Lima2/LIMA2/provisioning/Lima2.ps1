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
New-SmbShare -Name "VerkoopData" -Path "D:\"
New-SmbShare -Name "OntwikkelingData" -Path "E:\"
New-SmbShare -Name "ItData" -Path "F:\"
New-SmbShare -Name "DirData" -Path "G:\"
New-SmbShare -Name "AdminData" -Path "H:\"
New-SmbShare -Name "HomeDirs" -Path "Y:\"
New-SmbShare -Name "ProfileDirs" -Path "Z:\"



###Creating a new file share:
You'll need to make sure the folder path exists prior to running this command:
New-SmbShare -Name Logs -Description "Log Files" -Path C:\Shares\Logs


###Create groups (MUST BE DONE BY DC TECHNICALLY)


###Setting share permissions 
#https://docs.microsoft.com/en-us/powershell/module/smbshare/grant-smbshareaccess?view=win10-ps

Grant-SmbShareAccess -Name Loggs -AccountName AvalonSoft\Managers -AccessRight Read
