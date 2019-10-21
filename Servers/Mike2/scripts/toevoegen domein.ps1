start-transcript "C:\ScriptLogs\1.txt"

# remove script restrictions

 Set-ExecutionPolicy Unrestricted -force

# Auto run script prerquisites na reboot

Set-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce' -Name ResumeScript `
                -Value 'C:\Windows\system32\WindowsPowerShell\v1.0\Powershell.exe -executionpolicy bypass -file "Z:\scripts voor mike2\prerequisites.ps1"'

Write-Output "add password credentials"

$password = ConvertTo-SecureString "Admin2019" -AsPlainText -Force
$Cred = New-Object System.Management.Automation.PSCredential ("Administrator", $password)

$Username = $Cred.GetNetworkCredential().UserName
$Password = $Cred.GetNetworkCredential().Password
$Uservalue= "red\$Username"

# instellen velden voor automatisch in te loggen na opstarten
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name DefaultUserName -Value $Uservalue
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name DefaultPassword -Value $Password
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name AutoAdminLogon -Value 1
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name ForceAutoLogon -Value 1

# configure hostonlyadapter

Write-Output "configure hostonlyadapter"
New-NetIPAddress -IPAddress 172.18.1.3 -PrefixLength 24 -InterfaceIndex (Get-NetAdapter -Name "Ethernet").InterfaceIndex


#Disable Firewall
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False

