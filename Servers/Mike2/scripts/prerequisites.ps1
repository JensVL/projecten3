start-transcript "C:\ScriptLogs\2.txt"
Write-host "Waiting 5 seconds before continuing"
start-sleep -s 5
Write-Output "installing prerequisites"
# install prerequisites voor sharepoint moet access tot internet hebben  
# dit hangt af van waar de shared folder is heeft confirmatie nodig van uac
start-process Z:\sharepoint\PrerequisiteInstaller.exe /unattended -wait

# //install sql internet nodig
# \\VBOXSVR\windows_school_vm\SQLServer2016-SSEI-Eval.exe  /Iacceptsqlserverlicenseterms /q

Write-host "Waiting 5 seconds before continuing"
start-sleep -s 5


& "Z:\scripts voor mike2\SPsetup.ps1"


stop-transcript



