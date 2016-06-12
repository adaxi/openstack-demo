# -*- mode: ruby -*-
# vi: set ft=ruby :

# -------------------------------------------------------------------
# VAGRANTFILE 
# -------------------------------------------------------------------
# This file prepares the infrastructure to deploy a demo environement
# of OpenStack Icehouse.
#
# http://docs.openstack.org/icehouse/install-guide/install/apt/content/ch_overview.html
#
# Installation is performed using ansible. The guide listed above was
# used to write the ansible playbooks.
#
# Three networks need to be created in VirtualBox before briging the
# virtual machines up:
#
# File > Preferences > Network > Host-only Networks:
# - vboxnet0:
# 	- IPv4 Address: 10.10.10.1
# 	- IPv4 Network Mask: 255.255.255.0
# - vboxnet1:
# 	- IPv4 Address: 10.20.20.1
# 	- IPv4 Network Mask: 255.255.255.0
# - vboxnet2:
# 	- IPv4 Address: 192.168.100.1
# 	- IPv4 Network Mask: 255.255.255.0
#
# The following items should be added to your host files for an easier
# access to the nodes:
#
# 10.10.10.51     controller
# 10.10.10.52     network
# 10.10.10.53     compute1
#
# All machines need to be rebooted once the provisioning is finished.
# Once all machines rebooted, the Horizon dashboard can be accessed:
#
# http://controller/horizon
#

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|


	# -------------------------------------------------------------------
	# CONTROLLER 
	# -------------------------------------------------------------------
	# The basic controller node runs the Identity service, Image Service,
	# management portion of Compute, and the dashboard necessary to 
	# launch a simple instance. It also includes supporting services such
	# as a database, message broker, and NTP.
	#

	config.vm.define "controller" do |controller|
		controller.vm.box = "ubuntu/trusty64"
		controller.vm.hostname = "controller"

		# Link the management network to eth1
		controller.vm.network "private_network", 
			:ip => '10.10.10.51', 
			:name => 'vboxnet0', 
			:adapter => 2

		# Link the floating ip network to eth2
		controller.vm.network "private_network", 
			:ip => '192.168.100.51', 
			:name => 'vboxnet2', 
			:adapter => 3

		controller.vm.provider "virtualbox" do |vb|
	   		vb.customize ["modifyvm", :id, "--memory", "2048"]
			vb.customize ["modifyvm", :id, "--nicpromisc2", "allow-all"]
			vb.customize ["modifyvm", :id, "--nicpromisc3", "allow-all"]
			vb.name = "Controller Node (Vagrant)"
		end

		controller.vm.provision "ansible" do |ansible|
			ansible.playbook = "openstack.yml"
			ansible.inventory_path = "./inventory"
			ansible.raw_arguments = [ "--private-key=./private.key" ]
		end
	end
	

	# -------------------------------------------------------------------
	# NETWORK NODE
	# -------------------------------------------------------------------
	# The network node runs the Networking plug-in, layer 2 agent, and 
	# several layer 3 agents that provision and operate tenant networks.
	# Layer 2 services include provisioning of virtual networks and 
	# tunnels. Layer 3 services include routing, NAT , and DHCP. This 
	# node also handles external (internet) connectivity for tenant 
	# virtual machines or instances.

	config.vm.define "network" do |network|
		network.vm.box = "ubuntu/trusty64"
		network.vm.hostname = "network"
	
		# Link the management network to eth1
		network.vm.network "private_network", 
			:ip => "10.10.10.52",
			:name => 'vboxnet0',
			:adapter => 2
	
		# Link the instance tunnels network to eth2
		network.vm.network "private_network", 
			:ip => "10.20.20.52",
			:name => 'vboxnet1',
			:adapter => 3

		# Make sure that all the NICs are in promiscuous mode
		network.vm.provider "virtualbox" do |vb|
	   		vb.customize ["modifyvm", :id, "--memory", "1024"]
			vb.customize ["modifyvm", :id, "--nic4", "hostonly"]
			vb.customize ["modifyvm", :id, "--hostonlyadapter4", "vboxnet2"]
			vb.customize ["modifyvm", :id, "--nicpromisc2", "allow-all"]
			vb.customize ["modifyvm", :id, "--nicpromisc3", "allow-all"]
			vb.customize ["modifyvm", :id, "--nicpromisc4", "allow-all"]
			vb.name = "Network Node (Vagrant)"
		end

		network.vm.provision "ansible" do |ansible|
			ansible.playbook = "openstack.yml"
			ansible.inventory_path = "./inventory"
			ansible.raw_arguments = [ "--private-key=./private.key" ]
		end
	end
	
	
	# -------------------------------------------------------------------
	# COMPUTE NODE
	# -------------------------------------------------------------------
	# The compute node runs the hypervisor portion of Compute, which 
	# operates tenant virtual machines or instances. By default Compute 
	# uses KVM as the hypervisor. VirtualBox does not support KVM thus in
	# this example we will be using QEMU. The compute node also runs the 
	# Networking plug-in and layer 2 agent which operate tenant networks 
	# and implement security groups. You can run more than one compute
	# node.
	#

	config.vm.define "compute1" do |compute1|
		compute1.vm.box = "ubuntu/trusty64"
		compute1.vm.hostname = "compute1"

		# Link the management network to eth1
		compute1.vm.network "private_network", 
			:ip => "10.10.10.53",
			:name => 'vboxnet0',
			:adapter => 2

		# Link the instance tunnels network to eth2
		compute1.vm.network "private_network", 
			:ip => "10.20.20.53",
			:name => 'vboxnet1',
			:adapter => 3

		# Make sure that all the NICs are in promiscuous mode
		compute1.vm.provider "virtualbox" do |vb|
	   		vb.customize ["modifyvm", :id, "--memory", "3072"]
			vb.customize ["modifyvm", :id, "--nicpromisc2", "allow-all"]
			vb.customize ["modifyvm", :id, "--nicpromisc3", "allow-all"]
			vb.name = "Compute1 Node (Vagrant)"
		end

		compute1.vm.provision "ansible" do |ansible|
			ansible.playbook = "openstack.yml"
			ansible.inventory_path = "./inventory"
			ansible.raw_arguments = [ "--private-key=./private.key" ]
		end
	end

end
