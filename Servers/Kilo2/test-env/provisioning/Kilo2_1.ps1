# Variables

$domain = "red.local"
$password = "Admin2019" | ConvertTo-SecureString -AsPlainText -Force
$username = "Administrator"
$credential = New-Object System.Management.Automation.PSCredential($username, $password)

## Configurations IP
$IP = "172.18.1.1"
$DefaultGateway = "172.18.1.66"
$DNS = "172.18.1.66"
$InterfaceIndex = Get-NetIPAddress -IPAddress $IP | select -ExpandProperty InterfaceIndex

# IP Configuraties

# DHCP rol installeren
Write-Host ">>> Starting installation DHCP in background"
Start-Job -Name InstallDHCP -ScriptBlock {
    Install-WindowsFeature -Name DHCP -IncludeManagementTools
}

# Configuring network adapters
Write-Host ">>> Configuring IP"
Remove-NetIPAddress -InterfaceIndex $InterfaceIndex -Confirm:$false
Remove-NetRoute -InterfaceIndex $InterfaceIndex -Confirm:$false
Set-DnsClientServerAddress -InterfaceIndex $InterfaceIndex -ResetServerAddresses
New-NetIPAddress -InterfaceIndex $InterfaceIndex -IPAddress $IP -PrefixLength 24 -DefaultGateway $DefaultGateway
Set-DnsClientServerAddress -InterfaceIndex $InterfaceIndex -ServerAddresses $DNS

# Add delay to give the server time to adapt to new ip configurations
# If no delay is added the Machine will not be adapted to the new ip configurations and will fail to join the domain

Start-Sleep -s 5
# Toevoegen aan domain
Write-Host ">>> Adding server to Domain"

Add-Computer -DomainName $domain -Credential $credential -Force

Wait-Job -Name InstallDHCP
Receive-Job -Name InstallDHCP