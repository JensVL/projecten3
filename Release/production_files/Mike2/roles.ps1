Write-Host "Start configuring roles..."
Write-Host "Importing Modules..."  
Import-Module Servermanager

Install-WindowsFeature Net-Framework-Core -source f:\sources\sxs
Install-WindowsFeature NET-HTTP-Activation -source f:\sources\sxs
Install-WindowsFeature NET-Non-HTTP-Activ -source f:\sources\sxs
Install-WindowsFeature NET-WCF-HTTP-Activation45 

Install-WindowsFeature Web-Server -IncludeAllSubFeature -IncludeManagementTools -source f:\sources\sxs

Install-WindowsFeature Web-Common-Http 

Install-WindowsFeature Web-Static-Content 

Install-WindowsFeature Web-Default-Doc 

Install-WindowsFeature Web-Dir-Browsing 

Install-WindowsFeature Web-Http-Errors

Install-WindowsFeature Web-App-Dev 

Install-WindowsFeature Web-Asp-Net -source f:\sources\sxs

Install-WindowsFeature Web-ISAPI-Ext 

Install-WindowsFeature Web-ISAPI-Filter

Install-WindowsFeature Web-Health 

Install-WindowsFeature Web-Http-Logging 

Install-WindowsFeature Web-Log-Libraries

Install-WindowsFeature Web-Request-Monitor

Install-WindowsFeature Web-Http-Tracing 

Install-WindowsFeature Web-Security 

Install-WindowsFeature Web-Basic-Auth 

Install-WindowsFeature Web-Filtering 

Install-WindowsFeature Web-Digest-Auth

Install-WindowsFeature Web-Performance

Install-WindowsFeature Web-Stat-Compression

Install-WindowsFeature Web-Dyn-Compression 

Install-WindowsFeature Web-Mgmt-Tools 

Install-WindowsFeature Web-Mgmt-Console 

Install-WindowsFeature Web-Mgmt-Compat 

Install-WindowsFeature Web-Metabase 

Install-WindowsFeature Was -IncludeAllSubFeature -source f:\sources\sxs

Install-WindowsFeature Web-Lgcy-Scripting 

Install-WindowsFeature Windows-Identity-Foundation 

Install-WindowsFeature Server-Media-Foundation 

Install-WindowsFeature Xps-Viewer 

Install-WindowsFeature BITS-IIS-Ext 

Install-WindowsFeature WinRM-IIS-Ext 

Install-WindowsFeature Web-Scripting-Tools

Install-WindowsFeature Web-WMI

Install-WindowsFeature Web-IP-Security

Install-WindowsFeature Web-url-Auth

Install-WindowsFeature Web-Cert-Auth

Install-WindowsFeature Web-Client-Auth
