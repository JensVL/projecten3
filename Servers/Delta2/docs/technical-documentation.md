# Technical documentation

## Description

This document aims to explain all parameters and how to adjust the settings to your needs.
The provisioning is by design [idempotent](https://en.wikipedia.org/wiki/Idempotence). You can run run the provisioning over and over, the server will stay configured according to the config file.


Base-box: gusztavvargadr/windows-server (hosted on Atlas)
OS: Windows Server 2019


## Config parameters

* name                -- Name of the base box
* box                 -- name of the used base box, will be downloaded from Atlas
* box_url             -- Download the base box from the specified URL insteas of from Atlas
* ip                  -- Fixed IP address, by default an IP will be assigned from DHCP
* netmask             -- Fixed subnet, by default, the network mask is 255.255.255.0
* gui                 -- Wether to launch the virtualbox gui or not (true/false)
* memory              -- RAM assigned to vm
* cpus                -- Amount of cpus assigned to vm
* forwarded_ports
    * guest           -- Guest port
    * host            -- Host port
* downloadpath        -- Location where all the downloads regarding the provisioning will be stored
* iis
    * username        -- IIS username
    * password        -- IIS password
* asp
    * asp45           -- Install .NET Framework 4.5 (true/false)
    * dotnetcore21    -- Install .NET Core 2.1 (true/false)
    * dotnetcore22    -- Install .NET Core 2.2 (true/false)
    * dotnetcore30    -- Install .NET Core 3.0 (true/false)
* webapp
    * demo            -- Wether to deploy a demo app or not (true/false)
    * publocation     -- Location where the website will we hosted on the server (e.g. C:\inetpub\wwwroot\)
    * packagelocation -- Location of the app that will be deployed (e.g. C:\vagrant\app\app.zip)
* include_linter      -- Wether to install PSScriptAnalyser or not (true/false)


## Provisioning steps

1. Run [PSScriptAnalyser](https://github.com/PowerShell/PSScriptAnalyzer) (Powershell Linting Tool)
2. Ensure download path for installation files exists (set by downloadpath in config file)
3. Install the IIS Windows Feature/Role
4. Download and install Webdeploy. Used to deploy the ASP.NET demo webapp
5. Install .NET support:
    * .NET Framework 3.5 will not be installed:
        - This is a common error and as of 02/10/2019 there is stil no fix
        - There is however a [workaround](https://sysmanrec.com/installing-net-framework-3-5-on-server-2019-fails)
    * .NET Framework 4.5 installs like a normal Feature/Role
    * ASP .NET Core/.NET Core 2.1, 2.2 and 3.0 are installed by downloading the [Runtime & Hosting Bundle](https://dotnet.microsoft.com/download/dotnet-core)
    * After the installation of .NET, the webservices are restarted
<!-- 6. Configure the website in IIS
7. Deploy the demo webapp:
    * Currently, we only supported to deploy using a .zip package
8. Download powershell script, used to generate a SSL certificate for the website
9. Add the certificate to the website on IIS -->
6. configure Acl rules
7. Deploy the webapplication in wwwroot folder.
8. Create a site pool.
9. create a site with the physical path to the deployed webapplication. The site must also be added to the pool when it is created.
10. Generate SSL certificate so we can add the SSL-WebBinding to the created site.s
