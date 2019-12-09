$password = "Admin2019" | ConvertTo-SecureString -AsPlainText -Force
$username = "RED\Administrator"
$credential = New-Object System.Management.Automation.PSCredential($username, $password)
Start-Job -Name Test -Credential $credential -ScriptBlock {
    'Check name and domain:'
    Get-WmiObject Win32_ComputerSystem | Select-Object -Property Name, Domain | Format-List | Out-String    
    'Check IP Address:'
    Get-NetIPAddress -AddressFamily IPv4 | Select-Object -Property InterfaceAlias, IPAddress, PrefixLength | Format-List | Out-String
    'Check Default Gateway:'
    Get-NetRoute -AddressFamily IPv4 -DestinationPrefix "0.0.0.0/0" | Select-Object -Property InterfaceAlias, NextHop | Format-List | Out-String
    'Check DNS Server Addresses:'
    Get-DnsClientServerAddress -AddressFamily IPv4 | Select-Object -Property InterfaceAlias, ServerAddresses | Format-List | Out-String
    'Check if IIS is installed'
    (Get-WindowsFeature Web-Server).Installed
    'Check if execution policy is on Bypass'
    Get-ExecutionPolicy
    'Check if .NET Framework 4.5 is installed'
    (Get-WindowsFeature Web-Asp-Net45).Installed
    'checking which .NET Core version is installed'
    (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\ASP.NET Core\Shared Framework\v2.1\2.1.9\" -Name "Version").Version 2> $null
    (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\ASP.NET Core\Shared Framework\v2.2\2.2.3\" -Name "Version").Version 2> $null
    (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\ASP.NET Core\Shared Framework\v3.0\3.0.0\" -Name "Version").Version 2> $null
    'Checking is webdeploy is installed'
    Test-Path "C:\Program Files\IIS\Microsoft Web Deploy V3\msdeploy.exe"
    'Check if WebAppPool'
    Get-WebAppPoolState -name 'Delta2TRed'
    'Check if site is created'
    Get-Website -name 'App'
    Get-IISSite -name 'App'
    'Check configuration IIS website'
    Get-WebBinding
    'Check SSL certificate'
    Get-WebBinding 'App'
}
Wait-Job -Name Test
Receive-Job -Name Test