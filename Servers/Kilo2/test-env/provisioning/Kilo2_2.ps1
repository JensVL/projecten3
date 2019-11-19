

$domain = "red.local"
$domain_user = "Administrator"
$domain_pw = "Admin2019"

Write-Host ">>> Adding server to Domain"

$credential = New-Object System.Management.Automation.PSCredential("RED\$domain_user", ($domain_pw | ConvertTo-SecureString -AsPlainText -Force))

Add-Computer -DomainName $domain -DomainCredential $credential -Force

