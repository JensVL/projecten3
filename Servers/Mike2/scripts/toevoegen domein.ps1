start-transcript "C:\ScriptLogs\1.txt"
# Auto run script prerquisites na reboot

Set-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce' -Name ResumeScript `
                -Value 'C:\Windows\system32\WindowsPowerShell\v1.0\Powershell.exe -executionpolicy bypass -file "\\VBOXSVR\scripts voor mike2\prerequisites.ps1"'

Write-Output "add password credentials"

$password = ConvertTo-SecureString "Admin19" -AsPlainText -Force
$Cred = New-Object System.Management.Automation.PSCredential ("Administrator", $password)

$Username = $Cred.GetNetworkCredential().UserName
$Password = $Cred.GetNetworkCredential().Password
$Uservalue= "red.local\$Username"

# instellen velden voor automatisch in te loggen na opstarten
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name DefaultUserName -Value $Uservalue
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name DefaultPassword -Value $Password
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name AutoAdminLogon -Value 1
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name ForceAutoLogon -Value 1

# configure hostonlyadapter

Write-Output "configure hostonlyadapter"
New-NetIPAddress -IPAddress 172.18.1.3 -PrefixLength 24 -InterfaceIndex (Get-NetAdapter -Name "Ethernet").InterfaceIndex

# configure dns 
Write-Output "configure dns"
Set-DnsClientServerAddress -interfaceAlias "Ethernet" -serveraddresses 172.18.1.66

Write-host "Waiting 10 seconds before continuing"
start-sleep -s 10

#change domain met ADDS Credentials

Write-Output "set domain to red"
Add-Computer -DomainName red -Credential $Cred

# change computername met adds credentials

Write-Output "set computername to mike2v5"
rename-computer -computername "$env:computername" -newname "mike2" -DomainCredential $cred

Write-host "Waiting 10 seconds before continuing"
start-sleep -s 10





stop-transcript

restart-computer

