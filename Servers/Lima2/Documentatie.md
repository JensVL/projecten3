### Technische documentatie

## Creatie windows server 2019

1. Voor een eerste opzetting van de file server maken we gebruik van een windows_2019 Vagrant box.
2. Deze box is te vinden op deze pagina: https://app.vagrantup.com/StefanScherer/boxes/windows_2019
3. Maak een nieuwe map aan op het host systeem en open de Git Bash
4. Voer uit: "vagrant init StefanScherer/windows_2019"
5. Voer uit: "vagrant up"
6. Zet de machine uit nadat deze is aangemaakt.
7. Voor de file server hebben we 2 disks nodig, dus er moet nog een toegevoegd worden.
8. Een host-only adapter om de samba shares te testen via het host-systeem.

## De file server configureren

1. Powershell code:

```
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
```

2. Dit deel van het script installeert de nodige services voor een file server. 
3. Het maakt nieuwe partities aan en formateert de volumes.
4. Vervolgens worden de nieuwe shares aangemaakt.
5. Enkele afbeelding hoe de server eruit ziet na de uitvoering van het script.
![Volumes](https://github.com/HoGentTIN/p3ops-1920-logboek-RobbyDaelman/blob/master/images/Volumes.PNG)
![Volumes](https://github.com/HoGentTIN/p3ops-1920-logboek-RobbyDaelman/blob/master/images/Shares.PNG)
![Volumes](https://github.com/HoGentTIN/p3ops-1920-logboek-RobbyDaelman/blob/master/images/SharesOpHostSysteem.PNG)
