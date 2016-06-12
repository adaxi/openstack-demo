
OpenStack Demo 
==============

I wrote this to learn about OpenStack.

This file prepares the infrastructure to deploy a demo environement
of [OpenStack Icehouse](http://docs.openstack.org/icehouse/install-guide/install/apt/content/ch_overview.html)

Installation is performed using ansible. The guide listed above was
used to write the ansible playbooks.

Three networks need to be created in VirtualBox before briging the
virtual machines up:

File > Preferences > Network > Host-only Networks:
```
- vboxnet0:
	- IPv4 Address: 10.10.10.1
	- IPv4 Network Mask: 255.255.255.0
- vboxnet1:
	- IPv4 Address: 10.20.20.1
	- IPv4 Network Mask: 255.255.255.0
- vboxnet2:
	- IPv4 Address: 192.168.100.1
	- IPv4 Network Mask: 255.255.255.0
```

The following items should be added to your host files for an easier
access to the nodes:

```
10.10.10.51     controller
10.10.10.52     network
10.10.10.53     compute1
```

You can the run:

```
vagrant up
```

All machines need to be rebooted once the provisioning is finished.

```
vagrant reload
```
Once all machines rebooted, the Horizon dashboard can be accessed:

http://controller/horizon

Networks are not created automatically be the playbooks.
You need to run the ```create_networks.sh``` within the controller
node.


CONTROLLER 
----------
The basic controller node runs the Identity service, Image Service,
management portion of Compute, and the dashboard necessary to 
launch a simple instance. It also includes supporting services such
as a database, message broker, and NTP.



NETWORK NODE
------------
The network node runs the Networking plug-in, layer 2 agent, and 
several layer 3 agents that provision and operate tenant networks.
Layer 2 services include provisioning of virtual networks and 
tunnels. Layer 3 services include routing, NAT , and DHCP. This 
node also handles external (internet) connectivity for tenant 
virtual machines or instances.

COMPUTE NODE
------------
The compute node runs the hypervisor portion of Compute, which 
operates tenant virtual machines or instances. By default Compute 
uses KVM as the hypervisor. VirtualBox does not support KVM thus in
this example we will be using QEMU. The compute node also runs the 
Networking plug-in and layer 2 agent which operate tenant networks 
and implement security groups. You can run more than one compute
node.

