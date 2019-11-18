# Om het script uit te voeren:
#./TestplanNovember2.ps1 -name 'November2' -ipaddress '172.18.1.4' -defaultgateway '172.18.1.1' -ethernet 'Ethernet'


#Hier gaan we alle basis configuraties testen:

#params
param([String]$name='November2',
	[String]$ipaddress='172.18.1.4',
	[String]$defaultgateway='172.18.1.7',
	[String]$ethernet='Ethernet'
)

#Variables
$passed = 0
$failed = 0

# Green checkmark (Dit is om te greenCheck & redCheck een rode en groene kleur mee te geven)
$greenCheck = @{
	Object = [Char]8730
	ForegroundColor = 'Green'
	NoNewLine = $true
}

$redCheck = @{
	Object = [Char]120
	ForegroundColor = 'Red'
	NoNewLine = $true
}

function check-name{
	$hostname = Hostname
	if($hostname -eq $name){
		write-host @greenCheck
		write-host 'Computernaam is correct geconfigureerd'
		$Script:passed++
	}else{
		write-host @redCheck
		write-host 'Computernaam is NIET correct geconfigureerd'
		$Script:failed++
	}
}

function check-ip-settings{
	$ip = Test-Connection -ComputerName (hostname) -Count 1  | Select -ExpandProperty IPV4Address
	if($ip.IPAddressToString -eq $ipaddress){
		write-host @greenCheck
		write-host 'IP Address is correct geconfigureerd'
		$Script:passed++
	}else{
		write-host @redCheck
		write-host 'IP Address is NIET correct geconfigureerd'
		$Script:failed++
	}
	
	$sm = Get-NetIPAddress -InterfaceAlias $ethernet -AddressFamily IPv4 | Select -ExpandProperty PrefixLength
	if($sm -eq 27){
		write-host @greenCheck
		write-host 'Subnet Mask is correct geconfigureerd'
		$Script:passed++
	}else{
		write-host @redCheck
		write-host 'Subnet Mask is NIET correct geconfigureerd'
		$Script:failed++
	}
	
	$dg = Get-NetIPConfiguration | Foreach IPv4DefaultGateway | Select -ExpandProperty NextHop
	if($dg -eq $defaultgateway){
		write-host @greenCheck
		write-host 'Default Gateway is correct geconfigureerd'
		$Script:passed++
	}else{
		write-host @redCheck
		write-host 'Default Gateway is NIET correct geconfigureerd'
		$Script:failed++
	}
	
	$dns_raw = Get-DnsClientServerAddress | Select-Object -ExpandProperty ServerAddresses
	$dns_splitted = $dns_raw -Split "`r`n"
	if($dns_splitted.Contains('172.18.1.66')){
		write-host @greenCheck
		write-host 'ALFA2 is goed geconfigureerd als DNS Server'
		$Script:passed++
	}else{
		write-host @redCheck
		write-host 'ALFA2 is NIET geconfigureerd als DNS Server'
		$Script:failed++
	}
	if($dns_splitted.Contains('172.18.1.67')){
		write-host @greenCheck
		write-host 'BRAVO2 is goed geconfigureerd als backup DNS Server'
		$Script:passed++
	}else{
		write-host @redCheck
		write-host 'BRAVO2 is NIET geconfigureerd als backup DNS Server'
		$Script:failed++
	}
}

function check-firewall{
	$statePriv = netsh advfirewall show private | select-string -pattern "State " | Out-String
	$statePub = netsh advfirewall show public | select-string -pattern "State " | Out-String
	$stateDom = netsh advfirewall show private | select-string -pattern "State " | Out-String
	
	if($statePriv.replace(' ','').replace('State','').replace("`n","").replace("`r","") -eq 'OFF'){
		write-host @greenCheck
		write-host 'Private firewall is disabled'
		$Script:passed++
	}else{
		write-host @redCheck
		write-host 'Private firewall is nog enabled'
		$Script:failed++
	}
	if($stateDom.replace(' ','').replace('State','').replace("`n","").replace("`r","") -eq 'OFF'){
		write-host @greenCheck
		write-host 'Domain firewall is disabled'
		$Script:passed++
	}else{
		write-host @redCheck
		write-host 'Domain Firewall is still enabled'
		$Script:failed++
	}
	if($statePub.replace(' ','').replace('State','').replace("`n","").replace("`r","") -eq 'OFF'){
		write-host @greenCheck
		write-host 'Public firewall is disabled'
		$Script:passed++
	}else{
		write-host @redCheck
		write-host 'Public firewall is nog enabled'
		$Script:failed++
	}


}
check-name
check-ip-settings
check-firewall
read-host "$passed test(s) passes, $failed test(s) failed"
