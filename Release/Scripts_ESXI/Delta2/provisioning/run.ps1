# Script for bootstrapping Delta2

delta2.ps1 -downloadpath "C:\SetupMedia" -iisusername "vagrant" -iispassword "vagrant" -stringasp45 "$false" -stringdotnetcore21 "$false" -stringdotnetcore22 "$false" -stringdotnetcore30 "$false" -stringdemo "$false" -app_name "App" -pool_name "Delta2Red" -website_domain "www.red.local" -publocation "C:\inetpub\wwwroot\" -packagelocation "C:\vagrant\app\app.zip" -domain "red.local" -domain_user "Administrator" -domain_pw "Admin2019" -wan_adapter_name "NAT" -lan_adapter_name "LAN" -local_ip "172.18.1.69" -lan_prefix 27 -default_gateway "172.18.1.65" -primary_dns "172.18.1.66" -secondary_dns "172.18.1.67" -stringlinter "$false" 
