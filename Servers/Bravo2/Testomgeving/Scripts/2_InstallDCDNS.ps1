# VARIABLES:
$VBOXdrive = "Z:"
$Land = "eng-BE"
$IpAddress = "172.18.1.67"
$IpAlfa2 = "172.18.1.66"
$CIDR = "27"
$default_gateway  = "172.18.1.65"
$AdapterNaam = "LAN"
$DSRM = ConvertTo-SecureString "Admin2019" -asPlainText -force

# 1) Stel Datum/tijd correct in:
# Romance standard time = Brusselse tijd
Write-host "Setting correct timezone and time format settings:" -ForeGroundColor "Green"
Set-Culture -CultureInfo $Land
set-timezone -Name "Romance Standard Time"

# 3) Zorgen voor juist LAN adapter. Via intern netwerk.
Write-host "Changing NIC adapter names:" -ForeGroundColor "Green"
Get-NetAdapter -Name "Ethernet 2" | Rename-NetAdapter -NewName $AdapterNaam

# 4) Prefixlength = CIDR notatie van subnet (in ons geval 255.255.255.224)
Write-host "Setting correct ipv4 settings:" -ForeGroundColor "Green"

$existing_ip=(Get-NetAdapter -Name $AdapterNaam | Get-NetIPAddress -AddressFamily IPv4).IPAddress
if("$existing_ip" -ne "$IpAddress") {
    Write-host "Setting correct ipv4 settings:" -ForeGroundColor "Green"
    New-NetIPAddress -InterfaceAlias "$AdapterNaam" -IPAddress "$IpAddress" -PrefixLength $CIDR -DefaultGateway "$default_gateway"
}

# 5) Overbodige Adapter disablen
Disable-NetAdapter -Name "Ethernet" -Confirm:$false

# 6) DNS van LAN van Alfa2 instellen op Hogent DNS servers:
Set-DnsClientServerAddress -InterfaceAlias "$AdapterNaam" -ServerAddress "$IpAlfa2","$IpAddress"

# 7) Configure Administrator account
Set-LocalUser -Name Administrator -AccountNeverExpires -Password $DSRM -PasswordNeverExpires:$true -UserMayChangePassword:$true

# 8) Installatie ADDS:
Write-host "Starting installation of ADDS role:" -ForeGroundColor "Green"
Install-WindowsFeature AD-domain-services -IncludeManagementTools
import-module ADDSDeployment


# 9) DSRM instellen
$creds = New-Object System.Management.Automation.PSCredential ("RED\Administrator", (ConvertTo-SecureString "Admin2019" -AsPlainText -Force))


# 10) Joinen van domein "red.local":
Write-host "Domain joinen:" -ForeGroundColor "Green"

install-ADDSDomainController 
                  -DomainName "red.local" `
                  -ReplicationSourceDC "Alfa2.red.local" `
                  -credential $creds `
                  -installDns:$true `
                  -createDNSDelegation:$false `
                  -NoRebootOnCompletion:$true `
                  -SafeModeAdministratorPassword $DSRM `
                  -force:$true