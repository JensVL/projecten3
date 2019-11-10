# Parameters username en password
$Username = "Administrator"
$Password = "Admin2019"

Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name DefaultUserName -Value $Username
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name DefaultPassword -Value $Password
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name AutoAdminLogon -Value 1
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name ForceAutoLogon -Value 1

    Import-Module -Name "ScheduledTasks"
    $Sta = New-ScheduledTaskAction -Execute "powershell" -Argument "-ExecutionPolicy Bypass Z:\Lima2.ps1"
    $Stt = New-ScheduledTaskTrigger -AtLogOn
    $Stp = New-ScheduledTaskPrincipal -UserId "Administrator" -RunLevel Highest
    $StTaskName = "ConfigLima2"
    Register-ScheduledTask -TaskName $StTaskName -Action $Sta -Trigger $Stt -Principal $Stp -Force

# Parameters voor de netwerk adapter
$local_ip = "172.18.1.67"
$lan_prefix = "27"
$default_gateway = ""
$preferred_dns_ip = "172.18.1.66"

# De naam van de huidige adapter veranderen naar LAN
$temp = (Get-NetAdapter).Name
if ($temp -ne "LAN") { Get-NetAdapter | Rename-NetAdapter -NewName "LAN" }
else { Write-Host("Nothing to do") }
# De LAN adapter configuren met static ip en subnet masker
$temp = (Get-NetAdapter -Name "LAN" | Get-NetIPAddress -AddressFamily IPv4).IPAddress
if ($temp -ne $local_ip) { New-NetIPAddress -InterfaceAlias "LAN" -IPAddress $local_ip -PrefixLength $lan_prefix } 
else { Write-Host("Nothing to do") }
# DNS server instellen
Set-DnsClientServerAddress -InterfaceAlias "LAN" -ServerAddresses($preferred_dns_ip)

$test = Get-Credential
# De host hernoemen naar Lima2
if ($env:COMPUTERNAME -ne "Lima2") { Rename-Computer Lima2 }
else { Write-Host("Nothing to do") }
$temp = (Get-WmiObject Win32_ComputerSystem).Domain
if ($temp -ne "red.local") { Add-Computer -DomainName red.local -NewName Lima2 -Credential $test -Restart -Force }
else { Write-Host("Nothing to do") }

Restart-Computer

