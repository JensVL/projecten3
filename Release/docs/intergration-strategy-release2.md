# Integration strategy -- release 2

## Description

The integration strategy of the second iteration plans to join Kilo2 and November2 into release 1 where Alfa2, Bravo2 and the Network were integrated.
Every host has internet access and is connected to each other.
By design, further network implementation will take place during another iteration.
This is to exclude any pitfalls in the connectivity between the hosts that might occur during the integration.


## Roadmap

![draw.io map](/Critical_path.png)


## Integration process

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
| Alfa2          | 172.18.1.66 | /27    | RED\Administrator | Admin2019         |
| Bravo2         | 172.18.1.67 | /27    | RED\Administrator | Admin2019         |
| Kilo2          | 172.18.1.1  | /26    | RED\Administrator | Admin2019         |
| Win10-client01 | 172.18.0.5  | /24    | RED\KimberlyDC    | Administrator2019 |
| Win10-client02 | 172.18.0.6  | /24    | RED\LaurensBC     | Administrator2019 |


1. [X] Turn the firewall on Kilo2 off 
2. [X] On Alfa2, Bravo2 and the Windows 10 VMs, ping Kilo2
3. [X] On Kilo2 ping all other hosts in the IP table above
4. [X] Test internet connectivity on Kilo2
5. [X] On Kilo2, join the domain _red.local_
6. [X] Test internet connectivity on Kilo2
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

