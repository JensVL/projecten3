# Test plan

## Deliverables

1. Website accessible over HTTP and HTTPS
2. Website accessible using "www" from all hosts in all domains
3. Dynamic ASP.NET demo app
4. App uses MS SQL Server


## Requirements

1. Setup basic environment
2. Install IIS
3. Configure website on IIS
5. Install .NET Framework 4.5
6. Install .NET Core 2.1
7. Install .NET Core 2.2
8. Install .NET Core 3.0
9. Build WebApp
10. Deploy WebApp
11. Generate SSL certificate


## Test steps

### Setup basic environment

`vagrant up --no-provision`

- *Expected*: Output of the box launching

`vagrant ssh`

- *Expected*: prompt (i.e. TODO)

`powershell`

- *Expected*: powershell prompt


### Install IIS

`(Get-WindowsFeature Web-Server).Installed`

- *Expected*: True

`(Get-WindowsFeature Web-Mgmt-Service).Installed`

- *Expected*: True


### Configure website on IIS

TODO: Nathan


### Install .NET Framework 4.5

`(Get-WindowsFeature Web-Asp-Net45).Installed`

- *Expected*: True


### Install .NET Core 2.1

`(Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\ASP.NET Core\Shared Framework\v2.1\2.1.9\" -Name "Version").Version`

- *Expected*: TODO


### Install .NET Core 2.2

`(Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\ASP.NET Core\Shared Framework\v2.2\2.2.3\" -Name "Version").Version`

- *Expected*: TODO


### Install .NET Core 3.0

`(Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\ASP.NET Core\Shared Framework\v3.0\3.0.0\" -Name "Version").Version`

- *Expected*: TODO


### Build WebApp

TODO: Nathan


### Deploy WebApp

TODO: Nathan


### Generate SSL certificate

TODO: Nathan








