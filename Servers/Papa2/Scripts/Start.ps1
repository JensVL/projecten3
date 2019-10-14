#Variabelen
$computername = "Papa2"
$hostname = "sscm"
$domain = "red.local"
$password = "Admin2019" | ConvertTo-SecureString -asPlainText -Force
$username = "$domain\Administrator"

## Computer instellen voor Papa2
Rename-Computer -ComputerName $env:computername  -newName $hostname -Force -Restart

## Prerequisites dat moeten worden geïnstalleerd
Get-Module servermanager
Install-WindowsFeature BITS
Install-WindowsFeature NET-Framework-Features
Install-WindowsFeature NET-HTTP-Activation
Install-WindowsFeature NET-Non-HTTP-Activ
Install-WindowsFeature RDC
Install-WindowsFeature WDS
Install-WindowsFeature Web-Asp-Net
Install-WindowsFeature Web-Asp-Net45
Install-WindowsFeature Web-ISAPI-Ext
Install-WindowsFeature Web-Metabase
Install-WindowsFeature Web-WMI
Install-WindowsFeature Web-Windows-Auth         
dism /online /enable-feature /featurename:NetFX3 /all /Source:d:\sources\sxs /LimitAccess

# Joinen van domein en aanmelden administrator
$credential = New-Object System.Management.Automation.PSCredential($username,$password)
Add-Computer -DomainName $domain -Credential $credential

