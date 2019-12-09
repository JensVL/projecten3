# VARIABLES:
$VBOXdrive = "C:\Scripts_ESXI\Bravo2"

#$VBOXdrive = "Z:"

# LOG SCRIPT TO FILE (+ op het einde van het script Stop-Transcript doen):
Start-Transcript "C:\ScriptLogs\1_RUNFIRSTlog.txt"
Set-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce' -Name ResumeScript `
                -Value "C:\Windows\system32\WindowsPowerShell\v1.0\Powershell.exe -executionpolicy bypass -file `"$VBOXdrive\DNSInstall.ps1`""

$RegPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
$DefaultUsername = "Administrator"
$DefaultPassword = "Admin2019"

Set-ItemProperty $RegPath "AutoAdminLogon" -Value "1" -type String 
Set-ItemProperty $RegPath "DefaultUsername" -Value "$DefaultUsername" -type String 
Set-ItemProperty $RegPath "DefaultPassword" -Value "$DefaultPassword" -type String
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name DefaultUserName -Value $DefaultUsername
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name DefaultPassword -Value $DefaultPassword
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name AutoAdminLogon -Value 1
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name ForceAutoLogon -Value 1

#Invoke-Command -FilePath $VBOXdrive\DNSInstall.ps1
#Invoke-Command -FilePath $VBOXdrive\DNSConfig.ps1

Rename-Computer -NewName Bravo2 -Force 
Stop-Transcript
Restart-Computer -Force
