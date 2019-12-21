# p3ops: Team Repository - Red

## In this repository

- Assignment description (this file)
- Assigned members per task, with assigned testers
- IP & VLAN tables
- Directory structure:
  - Branch per server or feature
    - Source code & scripts
    - Documentation
      - Specifications
      - Technical documentation
      - Research
      - Installation guides
      - Testplans
      - Testreports
- Sequence & chart for production release
- Testprotocols for integration
- Stand-up reports

## Assignment

The global assignment consists of a fully integrated Windows and Linux server structure as shown in the topology below:

### Topology

![topology](Network/network-topology.jpg)

### General requirements

- De gehele opstelling moet volledig geautomatiseerd zijn. Dat betekent datop het moment van een productie-release het netwerk “from scratch” kanopgezet worden.
  - Use Ansible for the Linux domain
  - Use Powershell scripts for the Windows domain
- Provide an Administrator account on every server for remote access. (Linux via ssh, Windows via WinRM/HTTPS).
- Every component in the network transmits information to the monitoring server.
- It is possible to use VirtualBox and Vagrant in a test environment. The production environment has to be on another platform. Examples are: KVM-QEMU (Linux), Hyper-V (Windows), VMWare ESXi, ...
- Old computers (Dell Optiplex 760) can be used as clients for the production environment. Make sure these are ready.
- Optional: implement IPv6 within the red.local domain

### Domains

The following are the assigned domain names and IP ranges per team:

- green.local: 172.16.0.0/16 (Linux)
- red.local: 172.18.0.0/16 (Windows)

The green.local domain is fully based on Linux. The red.local domain is fully based on Windows. Network devices are Cisco routers and switches.

Use VLSM to split the above IP ranges over the assigned devices.

Routing between the VLANS is static.

Every domain has 4 switches and 5 VLANs:

- 2 L2 switches: Connects all computer systems inside a VLAN
- 2 L3 switches: Provide inter-VLAN connections
- VLAN 20, 200: internal clients
  - Private, dynamic IP addresses (via DHCP)
  - Access to public servers from other domains
- VLAN 30, 300: internal servers
  - Static IP adresses
  - Only reachable by hosts on the same domain
- VLAN 40, 400: Connection between the 2 L3 switches
  - Static IP adresses
- VLAN 50, 500: publcly accessible servers
  - Static IP adresses
  - Reachable by hosts on both domains
- VLAN 60, 600: Connection to PFSense Firewall
- VLAN 70, 700: Connection to router network and internet

### Routers & switches

All routers are connected using serial or UTP cables and use a dynamic routing algorithm. Connection to internet gets attached to a PFsense firewall.

ACLs on the routers and/or switches limit incoming traffic to the public servers and their services.

Create a proof of concept using Packet Tracer. Automate the physical device configuration using scripts or with a configuration management system.

Router4, which acts as edge router, is a shared responsibility between the 2 teams.

### Servers

#### alfa2

Domaincontroller with DNS. This is the Master DNS server for the red.local domain. External DNS-requests get passed on to the most suited DNS server. Has an alias of "ns1".

Workstations do not have own users, authentication always goes through the domaincontroller. Add the following departments (groups):

- IT Administration
- Sales
- Administration
- Development
- Management

Differentiate clearly between user, computers and groups. Add a few users and at least 5 workstations. (one in IT Administration, one in Development, one in Sales, one in Administration and one in Management). Use roaming profiles.

Configure the following policy rules on user level:

- Restrict access to the control panel for every department except the IT Administration department
- Delete the games link menu from the start menu for all departmens
- Restrict access to the network adapter settings for the Administration and Sales departments

Provide correct access rights for the fileserver (Modify/Read/Full) and add the relevant users and groups. More info available under **lima2**. Use AGDLP (Account, Global, Domain Local, Permission) to develop a group structure.

#### bravo2

A second Domain controller which acts as a second DNS server for the red.local domain. Has an alias of "ns2".

#### charlie2

A mailserver (Exchange Server) with SMTP and IMAP. Use the latest versions. Exchanging mails between the two domains should be possible. Users in the directory server (AD) also have a mailbox.

#### delta2

A publicly accessible webserver with HTTP/HTTPS, support for dynamic webapplications (ASP.NET) and a demo application. Use a database. The database is running on the **november2** server. It should be possible to browse to this webserver using the "www" suffix (example: <https://www.red.be/>) from every host from all domains.

#### kilo2

An internal member server in the red.local domain that acts as a DHCP server for the workstations.

#### lima2

An internal fileserver. Provide disks for the different departments described in table 1. Add access rights as described in table 2.

The HomeDirs en ProfileDirs directories are accessible for everyone. The HomeDirs folder has all home directories from all domain users. Naturally, a user can only read & write in his own directory. All other users have no access. The same goes for the profile directories and ProfileDis folder.

Configure the following restrictions:

- SalesData, DirData and AdminData max 100 Mb per user
- DevelopmentData and ITData max 200 Mb per user
- Configure a daily shadow copy of AdminData

Create a map ShareSales that gets shared with Sales and Development and has access rights as described in table 2.

##### Table 1

| Disk | Volume | Type    | File System | Volume label    | Share |
|----- | ------ | ------- | ----------- | --------------- | ----- |
| 1    | C:     | Primary | NTFS        | System          |       |
|      | D:     | Primary | NTFS        | SalesData       | X     |
|      | E:     | Primary | NTFS        | DevelopmentData | X     |
| 2    | F:     | Primary | NTFS        | ITData          | X     |
|      | G:     | Primary | NTFS        | DirData         | X     |
|      | H:     | Primary | NTFS        | AdminData       | X     |
| 2    | Y:     | Primary | NTFS        | HomeDirs        | X     |
|      | Z:     | Primary | NTFS        | ProfileDirs     | X     |

##### Table 2

| Volume          | Read               | Write             | Full control      |
| --------------- | ------------------ | ----------------- | ----------------  |
| SalesData       | Sales              | Sales             | IT Administration |
| DevelopmentData | Development        | Development       | IT Administration |
| ITData          | IT Administration  | IT Administration | IT Administration |
| DirDATA         | Management         | Management        | IT Administration |
| AdminData       | Administration     | Administration    | IT Administration |
| HomeDirs        | All  Departments   | All Departments   | IT Administration |
| ProfileDirs     | All Departments    | All Departments   | IT Administration |
| ShareSales      | Sales, Development | Sales             | IT Administration |

#### mike2

A member server in the red.local domain. This server acts as Intranet and CMS server (Sharepoint), and is only accessible from hosts within the red.local domain.

The Sharepoint database resides on **november2**.

Provide all red.local documentation as content for the CMS server.

#### november2

A member server in the red.local domain. This server is a Microsoft Sql Server for **mike2** (Sharepoint) and **delta2** (public webserver).

#### oscar2

A member server in the red.local domain. This server is a Realime Monitoring server monitoring all Windows servers. This server uses the PRTG monitoring application.

Make sure the following data gets monitored:

- CPU usage
- Memory usage
- State of hard disk(s)
- State of services like SQL, IIS, ...

#### papa2

A member server in the red.local domain. Microsoft SystemCenter Configuration Manager (SCCM) is running on this server. Use the most recent version.

This server is responsible for Windows 10 Enterprise client deployment into VLAN 200 using images.
This server also provides updates for Windows and Office programs to all clients and servers in the red.local domain.

It should also be possible to deploy several basic applications to the clients. Make sure at least the following get deployed:

- Office 2013 or Office 2016
- Adobe Acrobat Reader: latest version
- Java Packages: latest version
- Adobe Flash components for IE and Firefox

### Workstations

Configure at least 5 clients on which a user can log in, check emails and test the public and private services of the domains.

Every one of these clients is a member of one of the previously specified departments.

Make sure every department is supplied with at least 1 PC.

### Firewall

- **zulu2** operates between VLANs 600 en 700
- OS: most recent version of PFSense
- No NAT on this firewall: NAT is active on Router1
- Configure this firewall so only ports which are needed for your network are opened
- Allow every private host to communicate to the LAN & internet

## Task table

| Task      | Members                                            | Testers                                          |
| --------- | -------------------------------------------------- | ------------------------------------------------ |
| alfa2     | [Kimberly De Clercq](https://github.com/KimberlyDC) </br> [Laurens Blancquart-Cassaer](https://github.com/Laurensbc)   | [Alister Adutwum](https://github.com/AdutwumAlister) </br> [Sean Vancompernolle](https://github.com/SeanVancompernolle)      |
| bravo2    | [Levi Goessens](https://github.com/LeviGoessens)   </br> [Arno Van Nieuwenhove](https://github.com/ArnoVanNieuwenhove) | [Cédric Detemmerman](https://github.com/CedricDT) </br> [Robby Daelman](https://github.com/RobbyDaelman)          |
| charlie2  | [Joachim Van de Keere](https://github.com/Joachimvdk) </br> [Jannes Van Wonterghem](https://github.com/JannesVanWonterghem)      | [Kimberly De Clercq](https://github.com/KimberlyDC)                           |
| delta2    | [Matthias Van de Velde](https://github.com/fpkmatthi) </br> [Nathan Cammerman](https://github.com/NathanCammerman)          | [Joachim Van de Keere](https://github.com/Joachimvdk) </br> [Jannes Van Wonterghem](https://github.com/JannesVanWonterghem) |
| kilo2     | [Yngvar Samyn](https://github.com/yngvar1) </br> [Tibo Vanhercke](https://github.com/TiboVanhercke)                   | [Matthias Van de Velde](https://github.com/fpkmatthi) </br>  [Nathan Cammerman](https://github.com/NathanCammerman)    |
| lima2     | [Cédric Detemmerman](https://github.com/CedricDT) </br> [Robby Daelman](https://github.com/RobbyDaelman)              | [Aron Marckx](https://github.com/AronMarckx) </br> [Cédric Van den Eede](https://github.com/cevde)           |
| mike2     | [Tim Grijp](https://github.com/pikabooiseu) </br> [Elias Waterschoot](https://github.com/Elias-Waterschoot)| [Yngvar Samyn](https://github.com/yngvar1) </br> [Tibo Vanhercke](https://github.com/TiboVanhercke)        |
| november2 | [Aron Marckx](https://github.com/AronMarckx) </br> [Cédric Van den Eede](https://github.com/cevde) | [Levi Goessens](https://github.com/LeviGoessens)  </br> [Arno Van Nieuwenhove](https://github.com/ArnoVanNieuwenhove) |
| oscar2    | [Rik Claeyssens](https://github.com/RikCl) </br> [Jonas Vandegehuchte](https://github.com/JonasVandegehuchte)             |  [Tim Grijp](https://github.com/pikabooiseu) </br> [Elias Waterschoot](https://github.com/Elias-Waterschoot)                   |
| papa2     | [Ferre Verstichelen](https://github.com/FerreVerstichelen) </br>  [Laurens Blancquart-Cassaer](https://github.com/Laurensbc)  | [Jens Van Liefferinge](https://github.com/JensVL) </br> [Robin Van de Walle](https://github.com/RobinVandeWalle)   |
| zulu2     | [Alister Adutwum](https://github.com/AdutwumAlister) </br> [Sean Vancompernolle](https://github.com/SeanVancompernolle)   | [Ferre Verstichelen](https://github.com/FerreVerstichelen) |
| network  | [Jens Van Liefferinge](https://github.com/JensVL) </br> [Robin Van de Walle](https://github.com/RobinVandeWalle)         | [Rik Claeyssens](https://github.com/RikCl) </br> [Jonas Vandegehuchte](https://github.com/JonasVandegehuchte)                               |
| release   | [Matthias Van de Velde](https://github.com/fpkmatthi)                                 |                                                 |
| gantt     | [Nathan Cammerman](https://github.com/NathanCammerman) </br> [Kimberly De Clercq](https://github.com/KimberlyDC)             |                                                 |

## Server IP table

| Device    | DNS record     | IP address  |
| --------- | -------------- | ----------- |
| alfa2     | NS             | 172.18.1.66 |
| bravo2    | NS             | 172.18.1.67 |
| charlie2  | A + MX + Cname | 172.18.1.68 |
| delta2    | A              | 172.18.1.69 |
| kilo2     | A              | 172.18.1.1  |
| lima2     | A              | 172.18.1.2  |
| mike2     | A              | 172.18.1.3  |
| november2 | A              | 172.18.1.4  |
| oscar2    | A              | 172.18.1.5  |
| papa2     | A              | 172.18.1.6  |

For a more detailed IP table, head over to [this table](https://github.com/JensVL/projecten3/blob/network/Netwerkbeheer/IP%20Table.md).

## Contributors

- [Kimberly De Clercq](https://github.com/KimberlyDC)
- [Laurens Blancquart-Cassaer](https://github.com/Laurensbc)
- [Levi Goessens](https://github.com/LeviGoessens)
- [Arno Van Nieuwenhove](https://github.com/ArnoVanNieuwenhove)
- [Joachim Van de Keere](https://github.com/Joachimvdk)
- [Jannes Van Wonterghem](https://github.com/JannesVanWonterghem)
- [Matthias Van de Velde](https://github.com/fpkmatthi)
- [Nathan Cammerman](https://github.com/NathanCammerman)
- [Yngvar Samyn](https://github.com/yngvar1)
- [Tibo Vanhercke](https://github.com/TiboVanhercke)
- [Cédric Detemmerman](https://github.com/CedricDT)
- [Robby Daelman](https://github.com/RobbyDaelman)
- [Tim Grijp](https://github.com/pikabooiseu)
- [Elias Waterschoot](https://github.com/Elias-Waterschoot)
- [Aron Marckx](https://github.com/AronMarckx)
- [Cédric Van den Eede](https://github.com/cevde)
- [Rik Claeyssens](https://github.com/RikCl)
- [Jonas Vandegehuchte](https://github.com/JonasVandegehuchte)
- [Ferre Verstichelen](https://github.com/FerreVerstichelen)
- [Alister Adutwum](https://github.com/AdutwumAlister)
- [Sean Vancompernolle](https://github.com/SeanVancompernolle)
- [Jens Van Liefferinge](https://github.com/JensVL)
- [Robin Van de Walle](https://github.com/RobinVandeWalle)
