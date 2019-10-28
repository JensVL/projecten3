Write-host "Installatie Exchange Server Script 5" -ForeGroundColor "Red"

# LOG SCRIPT TO FILE (+ op het einde van het script Stop-Transcript doen):
Start-Transcript "C:\ScriptLogs\5_configureExchangeServer.txt"

# Start-Sleep zal 60 seconden wachten voor hij aan het eerste commando van dit script begint om zeker te zijn dat de server klaar is met het starten van zijn services na de reboot
Write-host "60 seconden wachten om de server op te starten" -ForeGroundColor "Green"
start-sleep -s 60

Write-host "Mailbox activeren voor alle AD-gebruikers" -ForeGroundColor "Green"
Add-PSSnapin Microsoft.Exchange.Management.PowerShell.SnapIn
$ADUsers = Get-ADUser -filter {userAccountControl -eq 512} -properties *
$ADUsers | foreach{enable-mailbox -Identity $_.Name -Database (get-mailboxdatabase).name}
Write-host "Send connector aanmaken" -ForeGroundColor "Green"
New-SendConnector -Name 'E-mail SMTP' -AddressSpaces * -Internet -SourceTransportServer Charlie2.red.local

Write-host "Auto-login uitschakelen" -ForeGroundColor "Green"
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name DefaultPassword -Value ""
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name AutoAdminLogon -Value 0
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name ForceAutoLogon -Value 0

Write-host "Installatie is beëindigd" -ForeGroundColor "Red"

Stop-Transcript