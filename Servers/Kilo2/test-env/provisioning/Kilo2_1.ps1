# IP Configuraties

# DHCP rol installeren
Start-Job -Name InstallDHCP -ScriptBlock {
    Install-WindowsFeature -Name DHCP -IncludeManagementTools
}

Start-Job -Name ConfiguringIP -ScriptBlock {
    Write-Host "Configuring IP..."
    $IP = "172.18.1.1"
    $DefaultGateway = "172.18.1.66"
    $DNS = "172.18.1.66"
    $InterfaceIndex = Get-NetIPAddress -IPAddress $IP | select -ExpandProperty InterfaceIndex
    Remove-NetIPAddress -InterfaceIndex $InterfaceIndex -Confirm:$false
    Remove-NetRoute -InterfaceIndex $InterfaceIndex -Confirm:$false
    Set-DnsClientServerAddress -InterfaceIndex $InterfaceIndex -ResetServerAddresses
    New-NetIPAddress -InterfaceIndex $InterfaceIndex -IPAddress $IP -PrefixLength 24 -DefaultGateway $DefaultGateway
    Set-DnsClientServerAddress -InterfaceIndex $InterfaceIndex -ServerAddresses $DNS
    Start-Sleep -s 5
    Write-Host "Ip Configured"
}

# Add delay to give the server time to adapt to new ip configurations
# If no delay is added the Machine will not be adapted to the new ip configurations and will fail to join the domain

Wait-Job -Name ConfiguringIP
# Toevoegen aan domain
Start-Job -Name AddToDomain -ScriptBlock {
    Write-Host "Adding server to Domain..."
    $domain = "red.local"
    $password = "vagrant" | ConvertTo-SecureString -AsPlainText -Force
    $username = "Administrator"
    $credential = New-Object System.Management.Automation.PSCredential($username, $password)

    Add-Computer -DomainName $domain -Credential $credential -Force
    Write-Host "Server added to Domain"
}

Wait-Job
Receive-Job -Name KeyboardSetting, ConfiguringIP, AddToDomain, InstallDHCP