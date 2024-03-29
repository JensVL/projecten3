# Utility functions that are useful in all provisioning scripts.

#------------------------------------------------------------------------------
# Variables
#------------------------------------------------------------------------------

# Set to 'yes' if debug messages should be printed.
New-Variable -Name debug_output -Value "yes" -Option Constant

#------------------------------------------------------------------------------
# Sourcing
#------------------------------------------------------------------------------
Add-Type -AssemblyName System.IO.Compression.FileSystem

#------------------------------------------------------------------------------
# Logging and debug output
#------------------------------------------------------------------------------

# Usage: info [-info_text] [ARG]
#
# Prints argument on the standard output stream
Function info() {
    param([string]$info_text)

    Write-Host $info_text
}

# Usage: debug [-debug_text] [ARG]
#
# Prints all arguments on the standard error stream
Function debug() {
    param([string]$debug_text)

    if ( $debug_output -eq "yes" ) {
        Write-Host $debug_text
    }
}

# Usage: error [-error_text] [ARG]
#
# Prints all arguments on the standard error stream
Function error() {
    param([string]$error_text)

    Write-Error $error_text
}

#------------------------------------------------------------------------------
# Helper functions
#------------------------------------------------------------------------------
# Usage: unzip [-zipfile] <c:\foo\bar> [-outpath] <c:\foo\bar>
#
# creates unzip function so we can unzip the downloaded zipped powershell file
function unzip {
    param([string]$zipfile, [string]$outpath)

    [System.IO.Compression.ZipFile]::ExtractToDirectory($zipfile, $outpath)
}
# Usage: zip [-zipfile] <c:\foo\bar> [-outpath] <c:\foo\bar>
#
# creates zip function so we can zip the files
function zip {
    Param([string]$zipfile,[string]$outpath)
    $compress = @{
        Path             = $zipfile
        CompressionLevel = "Optimal"
        DestinationPath  = $outpath
    }
    Compress-Archive @compress
}
# Usage: ensure_download_path [-downloadpath] <c:\foo\bar>
#
# Ensures the folder exists where the downloaded installation files are stored
function ensure_download_path() {
    param([string]$downloadpath)

    if ($downloadpath.EndsWith("\")) {
        $computerName.Remove($computerName.LastIndexOf("\"))
    }

    if (!(Test-Path $downloadpath)) {
        mkdir $downloadpath
    }
}

#------------------------------------------------------------------------------
# Install features and roles
#------------------------------------------------------------------------------
# Usage: install_webdeploy [-downloadpath] <c:\foo\bar>
#
# Downloads the installer to $downloadpath and executes the installer
function install_webdeploy() {
    param([string]$downloadpath)

    $file = $downloadpath + "\WebDeploy_amd64_en-US.msi"
    $downloadlink = "https://download.microsoft.com/download/0/1/D/01DC28EA-638C-4A22-A57B-4CEF97755C6C/WebDeploy_amd64_en-US.msi"

    if (!(Test-Path $file)) {
        Write-Host('Downloading Webdeploy...')

        (New-Object System.Net.WebClient).DownloadFile($downloadlink, $file)

        Write-Host('Download complete')
    }
    else {
        Write-Host('Webdeploy installer already present(skipping)')
    }

    # TODO: check if installed
    # if (!$installed) {
    Write-Host('Installing Webdeploy...')
    msiexec /i $file ADDLOCAL=DelegationScriptsFeature /qn /norestart LicenseAccepted="0"
    Write-Host('Installed Webdeploy')
    # } else {
    #     Write-Host('Webdeploy already installed(skipping)')
    # }
}

# Usage: install_iis
#
# Installs the IIS feature(Web server and management service)
function install_iis() {
    $serviceWebserver = Get-WindowsFeature Web-Server
    $servicesWebManagement = Get-WindowsFeature Web-Mgmt-Service

    if (!($serviceWebserver).Installed -or !($servicesWebManagement).Installed) {
        Write-Host('Downloading and installing IIS...')

        Install-WindowsFeature Web-Server, Web-Mgmt-Service -IncludeManagementTools > $null

        Write-Host('Installed IIS')
    }
    else {
        Write-Host('IIS already installed(skipping)')
    }
}

# Usage install_asp_dotnet_45
#
# Installs the ASP.NET Framework 4.5 feature
function install_asp_dotnet_45() {
    $serviceAsp45 = Get-WindowsFeature Web-Asp-Net45

    if (!($serviceAsp45).Installed) {
        Write-Host('Installing .NET Framework support for 4.5 and higher ...')

        Install-WindowsFeature Web-Asp-Net45 > $null

        Write-Host('Installed .NET Framework 4.5')

        restart_web_services
    }
    else {
        Write-Host('.NET Framework 4.5 already installed(skipping)')
    }
}

# Usage: download_ssl_cmdlets [-downloadpath] <c:\foo\bar>
#
# download SSL cmdLets for powershell so we can generate our own certificate
function download_ssl_cmdlets() {
    param([string]$downloadpath)

    $file = $downloadpath + "\GenerateCertificateCommands.zip"
    $downloadlink = "https://gallery.technet.microsoft.com/scriptcenter/Self-signed-certificate-5920a7c6/file/101251/2/New-SelfSignedCertificateEx.zip"

    if (!(Test-Path $file)) {
        Write-Host('Downloading zip-file with SSL cmdlets')
        (New-Object System.Net.WebClient).DownloadFile($downloadlink, $file)
        Write-Host('Download complete')
    }
    else {
        Write-Host('Zip file is already present(skipping)')
    }

    $outpath = $downloadpath + "\CertificateGenerateCommands"
    $scriptpath = $outpath + "\New-SelfSignedCertificateEx.ps1"

    if (!(Test-Path $scriptpath)) {
        Write-Host('Unzipping zip-file')
        unzip $file $outpath
    }
    else {
        Write-Host('Script already exists(skipping)')
    }

    Write-Host('Sourcing SSL cmdlets')
    . $scriptpath 
}

# Usage: install_asp_dotnet_core_21 [-downloadpath] <c:\foo\bar>
#
# install dotnet core 2.1
function install_asp_dotnet_core_21 {
    param([string]$downloadpath)
    
    $installed = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\ASP.NET Core\Shared Framework\v2.1\2.1.9\" -Name "Version").Version

    $file = $downloadpath + "\dotnet-hosting-2.1.9-win.exe"
    $downloadlink = "https://download.visualstudio.microsoft.com/download/pr/dc431217-1692-4db1-9e8b-3512c9788292/3070b595006fadcac1ce3b02aff5fadf/dotnet-hosting-2.1.9-win.exe"

    # download if not downloaded
    if (!(Test-Path $file)) {
        Write-Host('Downloading .NET Core 2.1 installer ...')
        (New-Object System.Net.WebClient).DownloadFile($downloadlink, $file)
        Write-Host('Download complete')
    }
    else {
        Write-Host('.NET Core 2.1 installer already present(skipping)')
    }

    
    # run installer if not installed
    Write-Host $installed
    if (!$installed -eq '2.1.9.0') {
        Write-Host('Running the .NET Core 2.1 installer ...')
        Start-Process -FilePath $file -ArgumentList /S, /v, /qn -Wait 
    }
    else {
        Write-Host('.NET Core 2.1 is already installed(skipping)')
    }

    # restart web server
    restart_web_services
}


# Usage: install_asp_dotnet_core_22 [-downloadpath] <c:\foo\bar>
#
# install dotnet core 2.2
function install_asp_dotnet_core_22 {
    param([string]$downloadpath)

    $installed = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\ASP.NET Core\Shared Framework\v2.2\2.2.3\" -Name "Version").Version

    $file = $downloadpath + "\dotnet-hosting-2.2.3-win.exe"
    $downloadlink = "https://download.visualstudio.microsoft.com/download/pr/a46ea5ce-a13f-47ff-8728-46cb92eb7ae3/1834ef35031f8ab84312bcc0eceb12af/dotnet-hosting-2.2.3-win.exe"

    # download if not downloaded
    if (!(Test-Path $file)) {
        Write-Host('Downloading .NET Core 2.2 installer ...')
        (New-Object System.Net.WebClient).DownloadFile($downloadlink, $file)
        Write-Host('Download complete')
    }
    else {
        Write-Host('.NET Core 2.2 installer already present(skipping)')
    }

    
    # run installer if not installed
    # Write-Host $installed
    if (!$installed -eq '2.2.9.0') {
        Write-Host('Running the .NET Core 2.2 installer ...')
        Start-Process -FilePath $file -ArgumentList /S, /v, /qn -Wait 
    }
    else {
        Write-Host('.NET Core 2.2 is already installed(skipping)')
    }

    # restart web server
    restart_web_services
}

function install_asp_dotnet_core_30 {
    param([string]$downloadpath)

    $installed = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\ASP.NET Core\Shared Framework\v3.0\3.0.0\" -Name "Version").Version

    $file = $downloadpath + "\dotnet-hosting-3.0.0-win.exe"
    $downloadlink = "https://download.visualstudio.microsoft.com/download/pr/bf608208-38aa-4a40-9b71-ae3b251e110a/bc1cecb14f75cc83dcd4bbc3309f7086/dotnet-hosting-3.0.0-win.exe"

    # download if not downloaded
    if (!(Test-Path $file)) {
        Write-Host('Downloading .NET Core 3.0 installer ...')
        (New-Object System.Net.WebClient).DownloadFile($downloadlink, $file)
        Write-Host('Download complete')
    }
    else {
        Write-Host('.NET Core 3.0 installer already present(skipping)')
    }

    
    # run installer if not installed
    # Write-Host $installed
    if (!$installed -eq '3.0.0.0') {
        Write-Host('Running the .NET Core 3.0 installer ...')
        Start-Process -FilePath $file -ArgumentList /S, /v, /qn -Wait 
    }
    else {
        Write-Host('.NET Core 3.0 is already installed(skipping)')
    }

    # restart web server
    restart_web_services
}

# Usage: restart_web_services
#
# restart webservices
function restart_web_services {
    Write-Host('Restarting Web Services ...')
    net stop was /y > $null
    net start w3svc > $null
    Start-Sleep -s 10     
}

# TODO
#
#
function configure_iis() {
    param($iisusername, $iispassword)
    $Acl = Get-Acl "C:\inetpub\wwwroot"
    $Acl.SetAccessRule((New-Object  system.security.accesscontrol.filesystemaccessrule("LOCAL SERVICE", "FullControl", "Allow")))
    Set-Acl "C:\inetpub\wwwroot" $Acl
    Write-Host('Acl permissions set')
    Try {
        [void][System.Reflection.Assembly]::LoadWithPartialName("Microsoft.Web.Management")
        [void][Microsoft.Web.Management.Server.ManagementAuthentication]::CreateUser($iisusername, $iispassword)
        [void][Microsoft.Web.Management.Server.ManagementAuthorization]::Grant($iisusername, "Default Web Site", $FALSE)
    }
    Catch [System.Management.Automation.RuntimeException] {
        Write-Host('User vagrant already exists(skipping)')
    }
}

# TODO
#
# $packagelocation is a zip file with the app
function deploy_app() {
    param(
        [string]$publocation,
        [string]$packagelocation
    )
    $directoryInfo = Get-ChildItem $publocation | Measure-Object

    # if publocation is empty, deploy app
    if (!($directoryInfo.count -eq 0)) {
        Get-ChildItem -Path $publocation -Include * -File -Recurse | foreach { $_.Delete()}

        debug 'Deploying Blog Demo ...'
        $msdeploy = "C:\Program Files\IIS\Microsoft Web Deploy V3\msdeploy.exe"

        & $msdeploy -verb:sync -source:package=$packagelocation -dest:auto > $null
    }
}

# Usage: configure_certs [-downloadpath]  <c:\foo\bar>
#
# configure SSL cert for HTTPS access
function configure_certs() {
    param(
        [string]$downloadpath,
        [string]$website
    )

    New-SelfSignedCertificateEx -StoreLocation $downloadpath -DnsName 'www.red.local'
}
# imports webadministration tool for pool and site creation
function prerequisites_Application_Pool (){
    Import-Module WebAdministration
}
#create an applicationpool where our application will be a part off
function create_App_Pool(){
    New-Item -Path "IIS:\AppPools" -Name "Delta2Red" -Type AppPool
    Set-ItemProperty -Path "IIS:\AppPools\Delta2Red" -name "managedRuntimeVersion" -value "v4.0"
    Set-ItemProperty -Path "IIS:\AppPools\Delta2Red" -name "enable32BitAppOnWin64" -value $false
    Set-ItemProperty -Path "IIS:\AppPools\Delta2Red" -name "autoStart" -value $true
    Set-ItemProperty -Path "IIS:\AppPools\Delta2Red" -name "processModel" -value @{identitytype="ApplicationPoolIdentity"}
    if ([Environment]::OSVersion.Version -ge (new-object 'Version' 6,2)) {
        Set-ItemProperty -Path "IIS:\AppPools\Delta2Red" -name "startMode" -value "OnDemand"
    }
    # New-WebAppPool -name "Delta2Red"
    # New-Item -Path "IIS:\AppPools" -Name "Delta2Red" -Type AppPool
    # $appPool = Get-Item -name "Delta2Red" 
    # $appPool.processModel.identityType = "NetworkService"
    # $appPool.enable32BitAppOnWin64 = 1
    # $appPool | Set-Item
}

# create a site in iis where we will later move our application to
function create_Site(){
    New-Website -Name "RedWebsite" -Port 80 -IPAddress "*" -HostHeader "www.red.be" -PhysicalPath "C:\inetpub\wwwroot\test"
    Start-Website -Name "RedWebsite"
    ##advanced way of creating site
    # New-Item -Path "IIS:\Sites" -Name "RedWebsite" -Type Site -Bindings @{protocol="http";bindingInformation="*:8021:"}
    # Set-ItemProperty -Path "IIS:\Sites\RedWebsite" -name "physicalPath" -value "C:\inetpub\wwwroot\test"
    # Set-ItemProperty -Path "IIS:\Sites\RedWebsite" -Name "id" -Value 4
    # New-ItemProperty -Path "IIS:\Sites\RedWebsite" -Name "bindings" -Value (@{protocol="http";bindingInformation="*:8022:"}, @{protocol="http";bindingInformation="*:8023:"})

    # Start-Website -Name "RedWebsite"
    #-----previous code
    # $SiteFolderPath = "C:\inetpub\wwwroot\test" # Website Folder
    # $SiteAppPool = "Delta2Red"                  # Application Pool Name
    # $SiteName = "RedWebsite"                           # IIS Site Name
    # $SiteHostName = "www.red.be"                # Host Header

    # New-Item $SiteFolderPath -type Directory
    # Set-Content $SiteFolderPath\Default.htm "<h1>Hello IIS</h1>"
    # New-Item IIS:\AppPools\$SiteAppPool
    # New-Item IIS:\Sites\$SiteName -physicalPath $SiteFolderPath -bindings @{protocol="https";bindingInformation=":80:"+$SiteHostName}
    # Set-ItemProperty IIS:\Sites\$SiteName -name applicationPool -value $SiteAppPool
}

#assigning our application to the pool
function assignApplicationToPool(){
    Set-ItemProperty -Path "C:\inetpub\wwwroot\test" -name "applicationPool" -value "Delta2Red"
}