param(
    [string]$IP             = "172.18.1.1",
    [int]$lan_prefix        = 24,
    [string]$DefaultGateway = "172.18.1.7",
    [string]$primary_dns    = "172.18.1.66",
    [string]$secondary_dns  = "172.18.1.67",
    [string]$domain         = "red.local",
    [string]$domain_user    = "Administrator",
    [string]$domain_pw      = "Admin2019"
)

# IP Configuraties

# DHCP rol installeren
Write-Host ">>> Starting installation DHCP in background"
Start-Job -Name InstallDHCP -ScriptBlock {
    Install-WindowsFeature -Name DHCP -IncludeManagementTools
}

Write-Host ">>> Configuring IP"
# $IP = "172.18.1.1"
# $DefaultGateway = "172.18.1.66"
# $DNS = "172.18.1.66"
$InterfaceIndex = Get-NetIPAddress -IPAddress $IP | Select-Object -ExpandProperty InterfaceIndex

Remove-NetIPAddress -InterfaceIndex $InterfaceIndex -Confirm:$false
Remove-NetRoute -InterfaceIndex $InterfaceIndex -Confirm:$false

Set-DnsClientServerAddress -InterfaceIndex $InterfaceIndex -ResetServerAddresses
New-NetIPAddress -InterfaceIndex $InterfaceIndex -IPAddress $IP -PrefixLength $lan_prefix -DefaultGateway $DefaultGateway
Set-DnsClientServerAddress -InterfaceIndex $InterfaceIndex -ServerAddresses($primary_dns, $secondary_dns)

# Add delay to give the server time to adapt to new ip configurations
# If no delay is added the Machine will not be adapted to the new ip configurations and will fail to join the domain

Start-Sleep -s 5
# Toevoegen aan domain

Write-Host ">>> Adding server to Domain"
# $domain = "red.local"
# $password = $domain_pw | ConvertTo-SecureString -AsPlainText -Force
# $username = "Administrator"
$credential = New-Object System.Management.Automation.PSCredential("RED\$domain_user", ($domain_pw | ConvertTo-SecureString -AsPlainText -Force))

Add-Computer -DomainName $domain -DomainCredential $credential -Force


Wait-Job -Name InstallDHCP | Receive-Job
