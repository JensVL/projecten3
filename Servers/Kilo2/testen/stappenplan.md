Stappenplan DHCP-Server KILO2 met vagrant

1) Open git-bash in de testomgeving (\p3ops-1920-red\Servers\Kilo2\test-env)

2) Controleer of de server aanwezig is met het commando "vagrant status"
    output: Kilo2                     not created (virtualbox)

3) Maak de server aan met het commando "vagrant up Kilo2"

4) Controleer of de server aangemaakt is met het commando "vagrant status"
    output: Kilo2                     running (virtualbox)

5) Connecteer met de server met het commando "vagrant ssh Kilo2"

6) Ga in powershell mode met het commando "powershell"

7) Ga na of de DHCPServer aan staat met het commando "gsv -Name *dhcp* -ComputerName Kilo2"
    output: Status   Name               DisplayName
            ------   ----               -----------
            Running  Dhcp               DHCP Client
            Running  DHCPServer         DHCP Server

8) Controleer de DHCP scopes met het commando "Get-DhcpServerv4Scope"
    output: ScopeId         SubnetMask      Name           State    StartRange      EndRange
            -------         ----------      ----           -----    ----------      -------
            172.18.0.0      255.255.255.0   Vlan 200       Active   172.18.0.2      172....
            172.18.1.0      255.255.255.192 Vlan 300       Active   172.18.1.1      172....
            172.18.1.64     255.255.255.224 Vlan 500       Active   172.18.1.65     172....
            172.18.1.96     255.255.255.252 Vlan 400       Active   172.18.1.97     172....
            172.18.1.100    255.255.255.252 Vlan 600       Active   172.18.1.101    172....
            172.18.1.104    255.255.255.252 Vlan 700       Active   172.18.1.105    172....

