# Technical documentation


Base-box: gusztavvargadr/windows-server (hosted on Atlas)
OS: Windows Server 2019


## Config parameters

* name                -- Name of the base box
* box                 -- name of the used base box, will be downloaded from Atlas
* box_url             -- Download the base box from the specified URL insteas of from Atlas
* ip                  -- Fixed IP address, by default an IP will be assigned from DHCP
* netmask             -- Fixed subnet, by default, the network mask is 255.255.255.0
* gui                 -- Wether to launch the virtualbox gui or not(true/false)
* memory              -- RAM assigned to vm
* cpus                -- Amount of cpus assigned to vm
* webapp
    * demo            -- Wether to deploy a demo app or not(true/false)
    * publocation     -- Location where the website will we hosted on the server (e.g. C:\inetpub\wwwroot\)
    * packagelocation -- Location of the app that will be deployed (e.g. C:\vagrant\app\app.zip)
* downloadpath        -- Location where all the downloads regarding the provisioning will be stored
* forwarded_ports
    * guest           -- Guest port
    * host            -- Host port
* iis
    * username        -- IIS username
    * password        -- IIS password
* asp
    * asp35           -- Install .NET Framework 3.5(true/false)
    * asp45           -- Install .NET Framework 4.5(true/false)
    * dotnetcore21    -- Install .NET Core 2.1(true/false)
    * dotnetcore22    -- Install .NET Core 2.2(true/false)
    * dotnetcore30    -- Install .NET Core 3.0(true/false)


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
6. Configure the website in IIS
7. Deploy the demo webapp:
    * Currently, we only supported to deploy using a .zip package
8. Download powershell script, used to generate a SSL certificate for the website
9. Add the certificate to the website on IIS
