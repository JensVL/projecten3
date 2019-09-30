# Technical documentation

## Config parameters

Config-file: vagrant-hosts.yml

* name                -- Name of the base box
* box                 -- name of the used base box, will be downloaded from Atlas
* box_url             -- Download the base box from the specified URL insteas of from Atlas
* ip                  -- Fixed IP address, by default an IP will be assigned from DHCP
* netmask             -- Fixed subnet, by default, the network mask is 255.255.255.0
* gui                 -- Wether to launch the virtualbox gui or not(true/false)
* memory              -- RAM assigned to vm
* cpus                -- Amount of cpus assigned to vm
* webapp              -- WebApp specific settings
    * demo            -- Wether to deploy a demo app or not(true/false)
    * publocation     -- Location where the website will we hosted on the server (e.g. C:\inetpub\wwwroot\)
    * packagelocation -- Location of the app that will be deployed (e.g. C:\vagrant\app\app.zip)
* downloadpath        -- Location where all the downloadeds regarding the provisioning will be stored
* forwarded_ports     -- Ports to forward between host and guest
    * guest           -- Guest port
    * host            -- Host port
* iis                 -- IIS specific settings
    * username        -- IIS username
    * password        -- IIS password
* asp                 -- Version of ASP.NET that will be installed
    * asp35           -- .NET Framework 3.5(true/false)
    * asp45           -- .NET Framework 4.5(true/false)
    * dotnetcore21    -- .NET Core 2.1(true/false)
    * dotnetcore22    -- .NET Core 2.2(true/false)
    * dotnetcore30    -- .NET Core 3.0(true/false)


## Provisioning steps
TODO
