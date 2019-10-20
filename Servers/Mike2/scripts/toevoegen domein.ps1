start-transcript "C:\ScriptLogs\1.txt"

$VBOXdrive = "Z:\"

# Auto run script prerquisites na reboot

Set-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce' -Name ResumeScript `
                -Value 'C:\Windows\system32\WindowsPowerShell\v1.0\Powershell.exe -executionpolicy bypass -file "$VBOXdrive\scripts voor mike2\prerequisites.ps1"'

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


# configure dns 
Write-Output "configure dns"
Set-DnsClientServerAddress -interfaceAlias "Ethernet" -serveraddresses 172.18.1.66

Write-host "Waiting 15 seconds before continuing"
start-sleep -s 15


# change computername met adds credentials

Write-Output "set computername to mike2 and add to domain red"

add-Computer -DomainName red.local -ComputerName "$env:computername" -newname mike2v6 -DomainCredential $Cred



stop-transcript

restart-computer
