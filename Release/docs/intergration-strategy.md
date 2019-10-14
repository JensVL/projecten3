# Integration strategy -- week 4

## Description

The integration strategy of the first iteration plans to join Alfa2, Bravo2, Kilo2 and November together.
Every host has internet access and is connected to each other.
By design, further network implementation will take place during another iteration.
This is to exclude any pitfalls in the connectivity between the hosts that might occur during the integration.


## Roadmap

![draw.io map](/Critical_path.png)


## Integration process

### Network

*Members:* [JensVL](https://github.com/JensVL) & [RobinVandeWalle](https://github.com/RobinVandeWalle)

*Note:* Since we have no immediate access to L3 switches, these will each be swapped out by a router and a L2 switch

#### Criteria

* All hosts reside in the same VLAN
* IP addresses are configured according to the IP table
* All devices can ping each other and have internet connectivity

#### Process

1. Configure the routers and switches through a console connection(Use the IP table provided by the network team)
2. Connect all devices
3. Connect the switches to the patch panel going to one of the tables
4. Take a picture of the cables in the server room for future reference

#### Test

| Host           | IP         | Subnet |
|----------------|------------|--------|
| LaptopGhent01  | 172.18.0.2 | /24    |
| LaptopGhent02  | 172.18.0.3 | /24    |
| LaptopAalst01  | 172.18.0.3 | /24    |
| Win10-client01 | 172.18.0.5 | /24    |
| Win10-client02 | 172.18.0.6 | /24    |

1. [X] In Ghent, connect 2 laptops to an outlet going to the patch panel
2. [X] Configure a static IP on both laptops according to the IP table
3. [X] Disable the firewall on both laptops
4. [X] Ping each other
5. [X] Enable the firewall on both laptops(Security measure for the next step)
6. [ ] Test internet connectivity on both laptops
    * problem in NAT config
7. [ ] Configure a Windows 10 VM with *ONLY* a bridge adapter and a static IP according to the IP table
8. [ ] Launch the Windows 10 VM, this client will later be used to join the domain
9. [ ] Disable the VM's firewall
10. [ ] Ping the VM from the other laptop
11. [ ] Enable the VM's firewall
12. [ ] Test internet connectivity on the VM
13. [ ] In Aalst, connect a laptop to the same VLAN as the one in Ghent
14. [ ] Repeat step 7 and 8 on the laptop in Aalst
15. [ ] Configure a static IP on the laptop according to the IP table
16. [ ] Disable the firewalls on all 4 hosts
17. [ ] In Aalst, ping the 3 hosts in Ghent
18. [ ] In Ghent, ping the host in Aalst from the 3 hosts
19. [ ] Enable the firewalls on the laptop hosts but leave the firewalls of the VMs off

#### Test remarks

*TODO:* take notes during test

* Ping outside Hogent is disabled
* Connect router to table socket with n° greater than 6 and connect the table socket 
to another table socket lower than 6 for internet connectivity


### Alfa2 & Bravo2

*Members:* 
* Alfa2: [KimberlyDC](https://github.com/KimberlyDC) & [Laurensbc](https://github.com/Laurensbc) 
* Bravo2: [ArnoVanNieuwenhove](https://github.com/ArnoVanNieuwenhove) & [LeviGoessens](https://github.com/LeviGoessens)

*Note:* None

#### Criteria

* Both can launch and provision
* IP addresses are configured according to the IP table
* All devices can ping each other and have internet connectivity

#### Process

1. Configure Alfa2 & Bravo2 with *ONLY* a bridge adapter and a static IP according to the IP table
2. Launch Alfa2 in Ghent and Bravo2 in Aalst
3. While waiting for the provisioning to finish and to save time, continue with the process of Kilo2 in the next section

#### Test

| Host           | IP          | Subnet | Domain username | Domain password |
|----------------|-------------|--------|-----------------|-----------------|
| Alfa2          | 172.18.1.66 | /27    | TODO            | TODO            |
| Bravo2         | 172.18.1.67 | /27    | TODO            | TODO            |
| Win10-client01 | 172.18.0.5  | /24    | TODO            | TODO            |
| Win10-client02 | 172.18.0.6  | /24    | TODO            | TODO            |

1. [ ] Turn the firewalls of both domain controllers off
2. [ ] In Ghent, ping Bravo2 and in Aalst, ping Alfa2
3. [ ] On Alfa2 and Bravo2, ping the Windows 10 VMs created earlier
4. [ ] Test internet connectivity on Alfa2 and Bravo2
5. [ ] Test if replication is active
6. [ ] On the Windows 10 VMs, ping Alfa2 and Bravo2
7. [ ] On the Windows 10 VMs, join the domain _red.local_
8. [ ] On the windows 10 VMs, test internet connectivity
9. [ ] On the windows 10 VMs, configure the primary and secondary DNS of the network adapter

#### Test remarks

*TODO:* take notes during test


### Kilo2

*Members:* [TiboVanhercke](https://github.com/TiboVanhercke) & [yngvar1](https://github.com/yngvar1)

*Note:* None

#### Criteria

* Can launch and provision
* IP address is configured according to the IP table
* Can ping all other devices
* Can join the domain _red.local_

#### Process

1. Configure Kilo2 with *ONLY* a bridge adapter and a static IP according to the IP table
2. Launch Kilo2
3. While waiting for the provisioning to finish and to save time, check if Alfa2 and/or Bravo2 
   are done provisioning to continue with the tests (don't continue with November2 before Kilo2 is completely tested)

#### Test

| Host           | IP          | Subnet | Domain username | Domain password |
|----------------|-------------|--------|-----------------|-----------------|
| Alfa2          | 172.18.1.66 | /27    | TODO            | TODO            |
| Bravo2         | 172.18.1.67 | /27    | TODO            | TODO            |
| Kilo2          | 172.18.1.1  | /26    | TODO            | TODO            |
| Win10-client01 | 172.18.0.5  | /24    | TODO            | TODO            |
| Win10-client02 | 172.18.0.6  | /24    | TODO            | TODO            |

1. [ ] Turn the firewall on Kilo2 off 
2. [ ] On Alfa2, Bravo2 and the Windows 10 VMs, ping Kilo2
3. [ ] On Kilo2 ping all other hosts in the IP table above
4. [ ] Test internet connectivity on Kilo2
5. [ ] On Kilo2, join the domain _red.local_
6. [ ] Test internet connectivity on Kilo2
7. [ ] Test if DHCP relay is active and working

#### Test remarks

*TODO:* take notes during test


### November2

*Members:* [AronMarckx](https://github.com/AronMarckx) & [cevde](https://github.com/cevde)

*Note:* None

#### Criteria

* Can launch and provision
* IP address is configured according to the IP table
* Can ping all other devices
* Can join the domain _red.local_

#### Process

1. Configure November2 with *ONLY* a bridge adapter and a static IP according to the IP table
2. Launch November2
3. While waiting for the provisioning to finish and to save time, continue with the process of Lima2 in the next section

#### Test

| Host           | IP          | Subnet | Domain username | Domain password |
|----------------|-------------|--------|-----------------|-----------------|
| Alfa2          | 172.18.1.66 | /27    | TODO            | TODO            |
| Bravo2         | 172.18.1.67 | /27    | TODO            | TODO            |
| Kilo2          | 172.18.1.1  | /26    | TODO            | TODO            |
| November2      | 172.18.1.4  | /26    | TODO            | TODO            |
| Win10-client01 | 172.18.0.5  | /24    | TODO            | TODO            |
| Win10-client02 | 172.18.0.6  | /24    | TODO            | TODO            |

1. [ ] Turn the firewall on November2 off
2. [ ] On Alfa2, Bravo2, Kilo2 and the Windows 10 VMs, ping November2
3. [ ] On November2 ping all other hosts in the IP table above
4. [ ] Test internet connectivity on November2
5. [ ] On November2, join the domain _red.local_
6. [ ] Test internet connectivity on November2
7. [ ] Install SSMS(SQL Server Management Studio) on Win10-client01 and Win10-client01
8. [ ] Using SSMS on both Windows 10 VMs, connect to November2

#### Test remarks

*TODO:* take notes during test


### Lima2

*Members:* [CedricDT](https://github.com/CedricDT), [Jochim De Wandel](/link/to/profile) & [RobbyDaelman](https://github.com/RobbyDaelman)

*Note:* None

#### Criteria

* Can launch and provision
* IP address is configured according to the IP table
* Can ping all other devices
* Can join the domain _red.local_

#### Process

1. Configure Lima2 with *ONLY* a bridge adapter and a static IP according to the IP table
2. Launch Lima2
3. While waiting for the provisioning to finish and to save time, check if 
   November2 is done provisioning to continue with the tests (don't continue with Delta2 before November2 is completely tested)

#### Test

| Host           | IP          | Subnet | Domain username | Domain password |
|----------------|-------------|--------|-----------------|-----------------|
| Alfa2          | 172.18.1.66 | /27    | TODO            | TODO            |
| Bravo2         | 172.18.1.67 | /27    | TODO            | TODO            |
| Kilo2          | 172.18.1.1  | /26    | TODO            | TODO            |
| November2      | 172.18.1.4  | /26    | TODO            | TODO            |
| Lima2          | 172.18.1.2  | /26    | TODO            | TODO            |
| Win10-client01 | 172.18.0.5  | /24    | TODO            | TODO            |
| Win10-client02 | 172.18.0.6  | /24    | TODO            | TODO            |

1. [ ] Turn the firewall on Lima2 off
2. [ ] On Alfa2, Bravo2, Kilo2, November2 and the Windows 10 VMs, ping Lima2
3. [ ] On Lima2 ping all other hosts in the IP table above
4. [ ] Test internet connectivity on Lima2
5. [ ] On Lima2, join the domain _red.local_
6. [ ] Test internet connectivity on Lima2

#### Test remarks

*TODO:* take notes during test


### Delta2

*Members:* [fpkmatthi](https://github.com/fpkmatthi) & [NathanCammerman](https://github.com/NathanCammerman)

*Note:* None

#### Criteria

* Can launch and provision
* IP address is configured according to the IP table
* Can ping all other devices
* Can join the domain _red.local_
* Website is accessible over HTTP and HTTPS
* Website is accessible from all hosts by surfing to _www.red.local_
* WebApp can connect to the database on November2

#### Process

1. Configure Delta2 with *ONLY* a bridge adapter and a static IP according to the IP table
2. Launch Delta2
3. Wait for the provisioning to finish

#### Test

| Host           | IP          | Subnet | Domain username | Domain password |
|----------------|-------------|--------|-----------------|-----------------|
| Alfa2          | 172.18.1.66 | /27    | TODO            | TODO            |
| Bravo2         | 172.18.1.67 | /27    | TODO            | TODO            |
| Delta2         | 172.18.1.69 | /27    | TODO            | TODO            |
| Kilo2          | 172.18.1.1  | /26    | TODO            | TODO            |
| November2      | 172.18.1.4  | /26    | TODO            | TODO            |
| Lima2          | 172.18.1.2  | /26    | TODO            | TODO            |
| Win10-client01 | 172.18.0.5  | /24    | TODO            | TODO            |
| Win10-client02 | 172.18.0.6  | /24    | TODO            | TODO            |

1. [ ] Turn the firewall on Delta2 off
2. [ ] On Alfa2, Bravo2, Kilo2, November2, Lima2 and the Windows 10 VMs, ping Delta2
3. [ ] On Delta2 ping all other hosts in the IP table above
4. [ ] Test internet connectivity on Delta2
5. [ ] On Delta2, join the domain _red.local_
6. [ ] Test internet connectivity on Delta2
7. [ ] From all hosts, surf to _http://www.red.local_
7. [ ] From all hosts, surf to _https://www.red.local_

#### Test remarks

*TODO:* take notes during test


## Notes afterwards

