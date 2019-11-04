Write-host "Servernaam wijzigen naar Oscar2" -ForeGroundColor "Green"
Rename-Computer -NewName Oscar2 -Force

Write-host "Oscar 2 toevoegen aan domein red.local" -ForeGroundColor "Green"
Add-Computer -ComputerName 'Oscar2' -DomainName 'red.local'-Credential red.local\Administrator

Restart-Computer -Force