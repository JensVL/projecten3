# Integration strategy -- release 3

## Description

The integration strategy of the third iteration plans to join Delta2, Lima2 and Mike2 into release 2 where Alfa2, Bravo2, Kilo2, November2 and the Network were integrated.
Every host has internet access and is connected to each other.
By design, further network implementation will take place during another iteration.
This is to exclude any pitfalls in the connectivity between the hosts that might occur during the integration.


## Roadmap

![draw.io map](/Critical_path.png)


## Integration process

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
| Lima2          | 172.18.1.2  | /26    | TODO            | TODO            |
| November2      | 172.18.1.4  | /26    | TODO            | TODO            |
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
| Lima2          | 172.18.1.2  | /26    | TODO            | TODO            |
| November2      | 172.18.1.4  | /26    | TODO            | TODO            |
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

