

// configure hostonlyadapter
New-NetIPAddress -IPAddress 172.18.1.3 -PrefixLength 24 -InterfaceIndex (Get-NetAdapter).InterfaceIndex

// configure dns 
Set-DnsClientServerAddress -interfaceAlias ethernet -serveraddresses 172.18.1.66

//change domain 
//moet nog verbeterd worden zodat credentials automatisch zijn moet adds credentials zijn
 Add-Computer -DomainName red.local

//change computername met adds credentials
rename-computer -computername "$env:computername" -newname "mike2" -domaincredential Administrator'

//install prerequisites voor sharepoint moet access tot internet hebben  
//dit hangt af van waar de shared folder is
  \\VBOXSVR\windows_school_vm\sharepoint\PrerequisiteInstaller.exe /unattended

//install sql internet nodig

 \\VBOXSVR\windows_school_vm\SQLServer2016-SSEI-Eval.exe  /Iacceptsqlserverlicenseterms /q
