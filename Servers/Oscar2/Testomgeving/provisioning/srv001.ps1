$scriptList =
@(
'.\ASP-script.ps1'
'.\IIS-script.ps1'
'.\SQL-script.ps1'
)

foreach($script in $scriptList)
{
	Start-Process -FilePath "$PSHOME\powershell.exe" -ArgumentList "-command '& $script'" -Wait
}