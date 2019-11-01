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
6. Volumes:
![Volumes](https://github.com/HoGentTIN/p3ops-1920-logboek-RobbyDaelman/blob/master/images/Volumes.PNG)
7. Shares:
![Shares](https://github.com/HoGentTIN/p3ops-1920-logboek-RobbyDaelman/blob/master/images/Shares.PNG)
8. Om na te kijken of de shares toegankelijk zijn heb ik tijdelijk een host-only adapter toegevoegd. In de verkenner "\\naamServer" uitvoeren. Dit is het resultaat:
![SharesOpHostSysteem](https://github.com/HoGentTIN/p3ops-1920-logboek-RobbyDaelman/blob/master/images/SharesOpHostSysteem.PNG)

## Configuratie dagelijkse shadow copy

1. De server moet dagelijske een shaduw kopie maken van adminData. Om dit te automatiseren wordt er gebruik gemaakt van de scheduler.
2. Powershell code:

```
Import-Module -Name "ScheduledTasks"
$Sta = New-ScheduledTaskAction -Execute "powershell" -Argument ".\ShadowCopy.ps1" -WorkingDirectory "C:\vagrant\provisioning"
$Stt = New-ScheduledTaskTrigger -Daily -At 5pm
#Zorgt ervoor dat de taak met "highest privileges" wordt gexecuted.
$Stp = New-ScheduledTaskPrincipal -UserId "vagrant" -RunLevel Highest
$StTaskName="TEST10"
$StDescript="test"
#Registreer de taak in de task scheduler 
Register-ScheduledTask -TaskName $StTaskName -Action $Sta -Description $StDescript -Trigger $Stt -Principal $Stp
```

3. Deze code in het script maakt een nieuwe taak aan en voegt deze toe aan de scheduler. Deze taak runt dagelijks om 5pm het script "ShadowCopy.ps1".
4. Powershell code van ShadowCopy.ps1:

```
vssadmin create shadow /for=h:
```

5. De code in dit script is simpel. Het maakt rechtstreeks een schaduw kopie van adminData.
6. Als het eerste script is uitgevoerd, dan ziet de Task Scheduler er zo uit:
![TaskScheduler](https://github.com/HoGentTIN/p3ops-1920-logboek-RobbyDaelman/blob/master/images/TaskScheduler.PNG)
7. Vanaf 5pm wordt de toegevoegde taak een eerste keer uitgevoerd. het resultaat hiervan is te zien op de volgende afbeelding:
![SchaduwKopie](https://github.com/HoGentTIN/p3ops-1920-logboek-RobbyDaelman/blob/master/images/SchaduwKopie.PNG)

## Fileshare permissies


```
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

```
8. Elke blok in deze code configureerd de ACL toegangs permissies voor elke share.
9. alle permissie mogelijkheden zijn bonevaan gedefinëerd voor een vlot verloop van dit proces

## Maximum capaciteit shares
```
New-FSRMQuotaTemplate -Name "AdminData Quota" -Size 100MB
New-FSRMQuotaTemplate -Name "VerkoopData Quota" -Size 100MB
New-FSRMQuotaTemplate -Name "DirDATA Quota" -Size 100MB
New-FSRMQuotaTemplate -Name "OntwikkelingData Quota" -Size 200MB
New-FSRMQuotaTemplate -Name "ITData Quota" -Size 200MB
```
10. deze quota's stellen de maximum capaciteiten in voor de shares die een maximum moesten ingesteld hebben.
