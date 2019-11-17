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

    Write-Host "--- $info_text"
}

# Usage: debug [-debug_text] [ARG]
#
# Prints all arguments on the standard error stream
Function debug() {
    param([string]$debug_text)

    if ( $debug_output -eq "yes" ) {
        Write-Host ">>> $debug_text"
    }
}

# Usage: error [-error_text] [ARG]
#
# Prints all arguments on the standard error stream
Function error() {
    param([string]$error_text)

    Write-Warning "### $error_text"
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
    Param([string]$zipfile, [string]$outpath)
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

# Usage: join_domain [-domain] <domain_name> [-domain_user] <username> [-domain_pw] <plaintext_pw>
#
# Join the given domain with the given username and password.
# The user joining must have the privileges to do so.
function join_domain() {
    param([string]$domain,[string]$domain_user,[string]$domain_pw)

    $password = $domain_pw | ConvertTo-SecureString -AsPlainText -Force
    $credential = New-Object System.Management.Automation.PSCredential($domain_user, $password)

    Add-Computer -DomainName $domain -DomainCredential $credential -Force
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

    if (!(Test-Path "C:\Program Files\IIS\Microsoft Web Deploy V3\msdeploy.exe")) {
        if (!(Test-Path $file)) {
            debug 'Downloading Webdeploy...'

            (New-Object System.Net.WebClient).DownloadFile($downloadlink, $file)

            debug 'Download complete'
        }
        else {
            debug 'Webdeploy installer already present(skipping)'
        }

        debug 'Installing Webdeploy...'
        msiexec /i $file ADDLOCAL=DelegationScriptsFeature /qn /norestart LicenseAccepted="0"
        debug 'Installed Webdeploy'
    } else {
        debug 'Webdeploy already installed(skipping)'
    }
}

# Usage: install_iis
#
# Installs the IIS feature(Web server and management service)
function install_iis() {
    $serviceWebserver = Get-WindowsFeature Web-Server
    $servicesWebManagement = Get-WindowsFeature Web-Mgmt-Service

    if (!($serviceWebserver).Installed -or !($servicesWebManagement).Installed) {
        debug 'Downloading and installing IIS...'

        Install-WindowsFeature Web-Server, Web-Mgmt-Service -IncludeManagementTools > $null

        debug 'Installed IIS'
    }
    else {
        debug 'IIS already installed(skipping)'
    }
}

# Usage install_asp_dotnet_45
#
# Installs the ASP.NET Framework 4.5 feature
function install_asp_dotnet_45() {
    $serviceAsp45 = Get-WindowsFeature Web-Asp-Net45

    if (!($serviceAsp45).Installed) {
        debug 'Installing .NET Framework support for 4.5 and higher ...'

        Install-WindowsFeature Web-Asp-Net45 > $null

        debug 'Installed .NET Framework 4.5'

        restart_web_services
    }
    else {
        debug '.NET Framework 4.5 already installed(skipping)'
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
        debug 'Downloading zip-file with SSL cmdlets'
        (New-Object System.Net.WebClient).DownloadFile($downloadlink, $file)
        debug 'Download complete'
    }
    else {
        debug 'Zip file is already present(skipping)'
    }

    $outpath = $downloadpath + "\CertificateGenerateCommands"
    $scriptpath = $outpath + "\New-SelfSignedCertificateEx.ps1"

    if (!(Test-Path $scriptpath)) {
        debug 'Unzipping zip-file'
        unzip $file $outpath
    }
    else {
        debug 'Script already exists(skipping)'
    }

    debug 'Sourcing SSL cmdlets'
    . $scriptpath 
}

# Usage: install_asp_dotnet_core_21 [-downloadpath] <c:\foo\bar>
#
# install dotnet core 2.1
function install_asp_dotnet_core_21 {
    param([string]$downloadpath)
    
    $installed = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\ASP.NET Core\Shared Framework\v2.1\2.1.9\" -Name "Version").Version 2> $null

    # install if not installed
    if (!$installed -eq '2.1.9.0') {
        $file = $downloadpath + "\dotnet-hosting-2.1.9-win.exe"
        $downloadlink = "https://download.visualstudio.microsoft.com/download/pr/dc431217-1692-4db1-9e8b-3512c9788292/3070b595006fadcac1ce3b02aff5fadf/dotnet-hosting-2.1.9-win.exe"

        # download if not downloaded
        if (!(Test-Path $file)) {
            debug 'Downloading .NET Core 2.1 installer ...'
            (New-Object System.Net.WebClient).DownloadFile($downloadlink, $file)
            debug 'Download complete'
        } else {
            debug '.NET Core 2.1 installer already present(skipping)'
        }

        debug 'Running the .NET Core 2.1 installer ...'
        Start-Process -FilePath $file -ArgumentList /S, /v, /qn -Wait 

        restart_web_services
    } else {
        debug '.NET Core 2.1 is already installed(skipping)'
    }
}


# Usage: install_asp_dotnet_core_22 [-downloadpath] <c:\foo\bar>
#
# install dotnet core 2.2
function install_asp_dotnet_core_22 {
    param([string]$downloadpath)

    $installed = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\ASP.NET Core\Shared Framework\v2.2\2.2.3\" -Name "Version").Version 2> $null

    # install if not installed
    if (!$installed -eq '2.2.9.0') {
        $file = $downloadpath + "\dotnet-hosting-2.2.3-win.exe"
        $downloadlink = "https://download.visualstudio.microsoft.com/download/pr/a46ea5ce-a13f-47ff-8728-46cb92eb7ae3/1834ef35031f8ab84312bcc0eceb12af/dotnet-hosting-2.2.3-win.exe"

        # download if not downloaded
        if (!(Test-Path $file)) {
            debug 'Downloading .NET Core 2.2 installer ...'
            (New-Object System.Net.WebClient).DownloadFile($downloadlink, $file)
            debug 'Download complete'
        } else {
            debug '.NET Core 2.2 installer already present(skipping)'
        }

        debug 'Running the .NET Core 2.2 installer ...'
        Start-Process -FilePath $file -ArgumentList /S, /v, /qn -Wait 

        restart_web_services
    } else {
        debug '.NET Core 2.2 is already installed(skipping)'
    }
}

# Usage: install_asp_dotnet_core_30 [-downloadpath] <c:\foo\bar>
#
# install dotnet core 3.0
function install_asp_dotnet_core_30 {
    param([string]$downloadpath)

    $installed = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\ASP.NET Core\Shared Framework\v3.0\3.0.0\" -Name "Version").Version 2> $null

    # install if not installed
    if (!$installed -eq '3.0.0.0') {
        $file = $downloadpath + "\dotnet-hosting-3.0.0-win.exe"
        $downloadlink = "https://download.visualstudio.microsoft.com/download/pr/bf608208-38aa-4a40-9b71-ae3b251e110a/bc1cecb14f75cc83dcd4bbc3309f7086/dotnet-hosting-3.0.0-win.exe"

        # download if not downloaded
        if (!(Test-Path $file)) {
            debug 'Downloading .NET Core 3.0 installer ...'
            (New-Object System.Net.WebClient).DownloadFile($downloadlink, $file)
            debug 'Download complete'
        } else {
            debug '.NET Core 3.0 installer already present(skipping)'
        }

        debug 'Running the .NET Core 3.0 installer ...'
        Start-Process -FilePath $file -ArgumentList /S, /v, /qn -Wait 

        restart_web_services
    } else {
        debug '.NET Core 3.0 is already installed(skipping)'
    }
}

# Usage: restart_web_services
#
# restart webservices
function restart_web_services() {
    debug 'Restarting Web Services ...'
    net stop was /y > $null
    net start w3svc > $null
    Start-Sleep -s 10     
}

# Usage: configure_iis [-iisusername] <username> [-iispassword] <password>
#
# Set the permissions on the web space
function configure_iis() {
    param([string]$iisusername, [string]$iispassword)

    $Acl = Get-Acl "C:\inetpub\wwwroot"
    $Acl.SetAccessRule((New-Object  system.security.accesscontrol.filesystemaccessrule("LOCAL SERVICE", "FullControl", "Allow")))
    Set-Acl "C:\inetpub\wwwroot" $Acl

    Try {
        debug "Allow $iisusername to manage the website in IIS"
        [void][System.Reflection.Assembly]::LoadWithPartialName("Microsoft.Web.Management")
        [void][Microsoft.Web.Management.Server.ManagementAuthentication]::CreateUser($iisusername, $iispassword)
        [void][Microsoft.Web.Management.Server.ManagementAuthorization]::Grant($iisusername, "Default Web Site", $FALSE)
    }
    Catch [System.Management.Automation.RuntimeException] {
        debug '$iisusername has alreaddy management permission for the website(skipping)'
    }
}

# Usage: copy_file [-source] <foo> [-destination] <bar>
#
# Wrapper function to copy a file from <foo> to <bar
function copy_file() {
    param([string]$sourcePath,[String]$DestinationPath)

    Copy-Item -Path $sourcePath -Destination $DestinationPath
}

# Usage: create_app_pool [-pool_name] <pool name>
#
# Create a pool for websides to reside in
function create_app_pool() {
    param([string]$pool_name)

    $iis_app_pools = "IIS:\AppPools"

    Import-Module WebAdministration
    New-Item -Path "$iis_app_pools" -Name $pool_name -Type AppPool
    Set-ItemProperty -Path "$iis_app_pools\$pool_name" -name "managedRuntimeVersion" -value "v4.0"
    Set-ItemProperty -Path "$iis_app_pools\$pool_name" -name "enable32BitAppOnWin64" -value $false
    Set-ItemProperty -Path "$iis_app_pools\$pool_name" -name "autoStart" -value $true
    Set-ItemProperty -Path "$iis_app_pools\$pool_name" -name "processModel" -value @{identitytype="ApplicationPoolIdentity"}

    if ([Environment]::OSVersion.Version -ge (new-object 'Version' 6,2)) {
        Set-ItemProperty -Path "$iis_app_pools\$pool_name" -name "startMode" -value "OnDemand"
    }
}

# Usage: create_site [-website_name] <foo> [-publocation] <C:\inetpub\wwwroot\> [-website_domain] <www.red.local> [-pool_name] <pool name>
#
# -website_name    Name of the website
# -publocation     Location where the app will be published 
# -website_domain  Domain name of the website
# -pool_name       Name of the pool where the app will resided
# Create site object in IIS and add this to the given pool
function create_site() {
    param([string]$website_name, [string]$publocation, [string]$website_domain, [string]$pool_name)

    New-Website -Name $website_name -Port 80 -IPAddress "*" -HostHeader $website_domain -PhysicalPath "$publocation\$website_name" -ApplicationPool $pool_name
    Start-Website -Name $website_name

    ### Extended way of creating site {{{
    # New-Item -Path "IIS:\Sites" -Name "RedWebsite" -Type Site -Bindings @{protocol="http";bindingInformation="*:8021:"}
    # Set-ItemProperty -Path "IIS:\Sites\RedWebsite" -name "physicalPath" -value "C:\inetpub\wwwroot\test"
    # Set-ItemProperty -Path "IIS:\Sites\RedWebsite" -Name "id" -Value 4
    # New-ItemProperty -Path "IIS:\Sites\RedWebsite" -Name "bindings" -Value (@{protocol="http";bindingInformation="*:8022:"}, @{protocol="http";bindingInformation="*:8023:"})
    ### }}}
}

# Usage: fix_ssl [-website_name] <foo> [-website_domain] <www.red.local>
#
# -website_name    Name of the website
# -website_domain  Domain name of the website
# Allow all hosts to connect on port 443 and use the SSL certificate to ensure HTTPS
function fix_ssl() {
    param([string]$website_name, [string]$website_domain)

    Import-Module WebAdministration

    #add new binding to site
    New-WebBinding -Name $website_name -IPAddress * -Port 443 -Protocol https

    #create self signed certificate
    #$cert = New-SelfSignedCertfificate -CertStoreLocation "Cert:\LocalMachine\App" -DnsName $website_domain
    $cert = New-SelfSignedCertificate -CertStoreLocation "Cert:\LocalMachine\App" -DnsName $website_domain

    #Attach the certificate to the SSL binding
    $CertPath = "Cert:\LocalMachine\App\$($cert.Thumbprint)"

    #binding to all ip addresses to port 443 | als * niet werkt probeer 0.0.0.0
    $ProviderPath = "IIS:\SSLBindings\*!443" 

    Get-Item $CertPath | New-Item $ProviderPath
}


# Usage: deploy_app [-publocation] <publish location> [-packagelocation] <package location>
#
# Publish a webdeploy package to the given location
# The package is a zip file, containing the app, with config files in the same directory
# function deploy_app() {
#     param([string]$publocation, [string]$packagelocation)
#
#     $directoryInfo = Get-ChildItem $publocation | Measure-Object
#
#     # if publocation is empty, deploy app
#     if (!($directoryInfo.count -eq 0)) {
#         Get-ChildItem -Path $publocation -Include * -File -Recurse | foreach { $_.Delete()}
#         debug 'Deploying Blog Demo ...'
#         $msdeploy = "C:\Program Files\IIS\Microsoft Web Deploy V3\msdeploy.exe"
#         & $msdeploy -verb:sync -source:package=$packagelocation -dest:auto > $null
#     }
# }

# Usage: configure_certs [-downloadpath] <c:\foo\bar>
#
# configure SSL cert for HTTPS access
# function configure_certs() {
#     param(
#         [string]$downloadpath,
#         [string]$website
#     )
#     New-SelfSignedCertificateEx -StoreLocation $downloadpath -DnsName 'www.red.local'
# }
