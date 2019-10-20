# Release documentation

_Author: [Matthias Van De Velde](https://github.com/fpkmatthi)_

## Vagrant - [vagrant-vmware-esxi](https://github.com/josenk/vagrant-vmware-esxi)

**Note:** vagrant-vsphere might work too

### For requirements check the [github page](https://github.com/josenk/vagrant-vmware-esxi)

### Install the plugin

```Bash
vagrant plugin install vagrant-vmware-esxi
vagrant plugin list
```


### Sample config

```Ruby
config.vm.provider :vmware_esxi do |esxi|
    #  REQUIRED!  ESXi hostname/IP
    esxi.esxi_hostname = 'esxi'

    #  ESXi username
    esxi.esxi_username = 'root'

    #  IMPORTANT!  Set ESXi password.
    #    1) 'prompt:'
    #    2) 'file:'  or  'file:my_secret_file'
    #    3) 'env:'  or 'env:my_secret_env_var'
    #    4) 'key:'  or  key:~/.ssh/some_ssh_private_key'
    #    5) or esxi.esxi_password = 'my_esxi_password'
    #
    esxi.esxi_password = 'prompt:'

    #  SSH port.
    #esxi.esxi_hostport = 22

    #  HIGHLY RECOMMENDED!  ESXi Virtual Network
    #    You should specify an ESXi Virtual Network!  If it's not specified, the
    #    default is to use the first found.  You can specify up to 10 virtual
    #    networks using an array format.
    #esxi.esxi_virtual_network = ['VM Network','VM Network2','VM Network3','VM Network4']

    #  OPTIONAL.  Specify a Disk Store
    #esxi.esxi_disk_store = 'DS_001'

    #  OPTIONAL.  Resource Pool
    #     Vagrant will NOT create a Resource pool it for you.
    #esxi.esxi_resource_pool = '/Vagrant'

    #  Optional. Specify a VM to clone instead of uploading a box.
    #    Vagrant can use any stopped VM as the source 'box'.   The VM must be
    #    registered, stopped and must have the vagrant insecure ssh key installed.
    #    If the VM is stored in a resource pool, it must be specified.
    #    See wiki: https://github.com/josenk/vagrant-vmware-esxi/wiki/How-to-clone_from_vm
    #esxi.clone_from_vm = 'resource_pool/source_vm'

    #  OPTIONAL.  Guest VM name to use.
    #    The Default will be automatically generated.
    #esxi.guest_name = 'Custom-Guest-VM_Name'

    #  OPTIONAL.  When automatically naming VMs, use this prefix.
    #esxi.guest_name_prefix = 'V-'

    #  OPTIONAL.  Set the guest username login.  The default is 'vagrant'.
    #esxi.guest_username = 'vagrant'

    #  OPTIONAL.  Memory size override
    #esxi.guest_memsize = '2048'

    #  OPTIONAL.  Virtual CPUs override
    #esxi.guest_numvcpus = '2'

    #  OPTIONAL & RISKY.  Specify up to 10 MAC addresses
    #    The default is ovftool to automatically generate a MAC address.
    #    You can specify an array of MAC addresses using upper or lower case,
    #    separated by colons ':'.
    #esxi.guest_mac_address = ['00:50:56:aa:bb:cc', '00:50:56:01:01:01','00:50:56:02:02:02','00:50:56:BE:AF:01' ]

    #   OPTIONAL & RISKY.  Specify a guest_nic_type
    #     The validated list of guest_nic_types are 'e1000', 'e1000e', 'vmxnet',
    #     'vmxnet2', 'vmxnet3', 'Vlance', and 'Flexible'.
    #esxi.guest_nic_type = 'e1000'

    #  OPTIONAL.  Create additional storage for guests.
    #    You can specify an array of up to 13 virtual disk sizes (in GB) that you
    #    would like the provider to create once the guest has been created.  You
    #    can optionally specify the size and datastore using a hash.
    #esxi.guest_storage = [ 10, 20, { size: 30, datastore: 'datastore1' } ]

    #  OPTIONAL. specify snapshot options.
    #esxi.guest_snapshot_includememory = 'true'
    #esxi.guest_snapshot_quiesced = 'true'

    #  RISKY. guest_guestos
    #    https://github.com/josenk/vagrant-vmware-esxi/ESXi_guest_guestos_types.md
    #esxi.guest_guestos = 'centos-64'

    #  OPTIONAL. guest_virtualhw_version
    #    ESXi 6.5 supports these versions. 4,7,8,9,10,11,12,13 & 14.
    #esxi.guest_virtualhw_version = '9'

    #  DANGEROUS!  Allow Overwrite
    #    If unspecified, the default is to produce an error if overwriting
    #    VMs and packages.
    #esxi.local_allow_overwrite = 'True'
end
```


### Vagrant commands

Launch a box with the name <hostname>, which is set in vagrant-hosts.yml
```Bash
vagrant up --provider=vmware_esxi <hostname>
```

ESXi provided plugin. Output IP address of guest
```Bash
vagrant address 
```


## Base box

According to the info provided by the ESXi Vagrant plugin, any of the vmware Box formats should be compatible
(vmware_desktop, vmware_fusion, vmware_workstation, ...)

In the test environment, we use ...
However, these are exclusivly compatible with the Virtualbox and Hyper-V providers

The following base boxes are the ones selected for the production environment.
These are compatible with vmware_desktop, which on its turn should be usable for the ESXi plugin.
* StefanScherer/windows_10
* StefanScherer/windows_2019


## Resources

* https://github.com/josenk/vagrant-vmware-esxi
* https://app.vagrantup.com/StefanScherer/boxes/windows_2019
* https://app.vagrantup.com/StefanScherer/boxes/windows_10

* https://hunter2.gitbook.io/darthsidious/building-a-lab/building-a-lab-with-esxi-and-vagrant

* https://www.vagrantup.com/docs/networking/public_network.html
