# Release documentation

_Author: [Matthias Van De Velde](https://github.com/fpkmatthi)_

## Vagrant

### Required plugins

```Bash
vagrant install vagrant-reload vagrant-vmware-esxi vagrant-disksize
vagrant plugin list
```

**Note:** vagrant-vsphere might work too

### vagrant-reload

Used to reload boxes in between scripts
Check the [github page](https://github.com/aidanns/vagrant-reload).

### vagrant-vmware-esxi

Will be used to communicate with the ESXi server
Check the [github page](https://github.com/josenk/vagrant-vmware-esxi) 
for requirements, sample config and common errors.

Launch a box with the name <hostname>, which is set in vagrant-hosts.yml
```Bash
vagrant up --provider=vmware_esxi <hostname>
```

### vagrant-disksize

Used to resize the initial disksize of the box
Check the [github page](https://github.com/sprotheroe/vagrant-disksize) 


## Base box

According to the info provided by the ESXi Vagrant plugin, any of the vmware Box formats should be compatible
(vmware_desktop, vmware_fusion, vmware_workstation, ...)

In the test environment, we use ...
However, these are exclusivly compatible with the Virtualbox and Hyper-V providers

The following base boxes are the ones selected for the production environment.
These are compatible with vmware_desktop, which on its turn should be usable for the ESXi plugin.
* StefanScherer/windows_10
* StefanScherer/windows_2019


## Encountered errors

### Problem with "Unsupported hardware family 'vmx-14'"

Caused by incompatible virtual machine hardware versions (https://kb.vmware.com/s/article/2007240)

### Problem with "Waiting for state running"

This is caused by a mismatching vmware-tools version between the ESXi server and the guest VM.


## Resources

* https://github.com/josenk/vagrant-vmware-esxi
* https://app.vagrantup.com/StefanScherer/boxes/windows_2019
* https://app.vagrantup.com/StefanScherer/boxes/windows_10

* https://hunter2.gitbook.io/darthsidious/building-a-lab/building-a-lab-with-esxi-and-vagrant

* https://www.vagrantup.com/docs/networking/public_network.html

* vmware box compatibility
    * https://kb.vmware.com/s/article/1003746
    * https://kb.vmware.com/s/article/2007240
