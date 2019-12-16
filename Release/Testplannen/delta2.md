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

- *Expected*: prompt (vagrant@DELTA2 C:\\Users\\vagrant>)

`powershell`

- *Expected*: powershell prompt (PS C:\\Users\\vagrant>)


### Install IIS

`(Get-WindowsFeature Web-Server).Installed`

- *Expected*: True

`(Get-WindowsFeature Web-Server).Installed`

- *Expected*: True


### Check Powershell policy

`Get-ExecutionPolicy`

- *Expected*: Bypass

### Install .NET Framework 4.5

`(Get-WindowsFeature Web-Asp-Net45).Installed`

- *Expected*: True


### Install .NET Core 2.1

`(Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\ASP.NET Core\Shared Framework\v2.1\2.1.9\" -Name "Version").Version 2> $null`

- *Expected*: 2.1.9.0


### Install .NET Core 2.2

`(Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\ASP.NET Core\Shared Framework\v2.2\2.2.3\" -Name "Version").Version 2> $null`

- *Expected*: 2.2.3.0


### Install .NET Core 3.0

`(Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\ASP.NET Core\Shared Framework\v3.0\3.0.0\" -Name "Version").Version 2> $null`

- *Expected*: 3.0.0.0


### Install Webdepoly

`Test-Path "C:\Program Files\IIS\Microsoft Web Deploy V3\msdeploy.exe")`

- *Expected*: True


### Deploy WebApp

* Open a webbrowser ans surf to http://localhost/
* Open a webbrowser ans surf to https://localhost/
* Open a webbrowser ans surf to http://www.red.local/
* Open a webbrowser ans surf to https://www.red.local/

- Expected: The Blogifier webpage
- **NOTE**: when visiting the https site, you might receive an error regarding the certificat. This is normal and is caused by using the default self-signed certificate.

### Create WebAppPool

`Get-WebAppPoolState -name 'Delta2TRed'`

| Value            | 
| ---------------- |
| Started          |

### Create site

`Get-Website -name 'Default Web Site'` or `Get-IISSite -name 'Default Web Site'`

- *Expected*:

| Name | ID | State   | Physical Path             | Bindings                                                |
| ---- | -  | ------- | ----------------------    | :-----------------------------------------------------: |
| App  | 2  | Started | C:\\inetpub\\wwwroot\\App | http  *:80:www.red.local<br>https *:443: sslFlags=0  |
  

### Configure website on IIS

`Get-WebBinding`

| Protocol         | Binding Information | SSL Flags      |
| ---------------- | :-----------------: | -------------: |
| http             | *:80:www.red.local  | 0              |


### Generate SSL certificate

`Get-WebBinding 'Default Web Site'`

- *Expected*: 

| Protocol         | Binding Information | SSL Flags      |
| ---------------- | :-----------------: | -------------: |
| http             | *:80:www.red.local  | 0              |
| https            | *:443:www.red.local | 0              |



