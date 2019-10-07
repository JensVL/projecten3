# VARIABLES:
$VBOXdrive = "Z:"

# PREFERENCE VARIABLES: (Om Debug,Verbose en informaation info in de Start-Transcript log files te zien)
$DebugPreference = "Continue"
$VerbosePreference = "Continue"
$InformationPreference = "Continue"

# LOG SCRIPT TO FILE (+ op het einde van het script Stop-Transcript doen):
Start-Transcript "C:\ScriptLogs\3_ConfigDCDNSlog.txt"
Write-Host "DNS CONFIG INCOMING ;)"
Stop-Transcript
