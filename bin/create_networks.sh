#!/bin/bash

# -------------------------------------------------------------------
# NETWORKS 
# -------------------------------------------------------------------
# This script creates demo networks.
#

# As admin user, create the external network
source /root/admin-openrc.sh

neutron net-create ext-net --shared --router:external=True
neutron subnet-create ext-net --name ext-subnet --allocation-pool start=192.168.100.200,end=192.168.100.250 --disable-dhcp --gateway 192.168.100.1 192.168.100.0/24

# As first user, create the first user network
source /root/first_user-openrc.sh

neutron net-create first_user-net
neutron subnet-create first_user-net --name first_user-subnet --gateway 172.16.10.1 172.16.10.0/24

# As admin user, create a router and assing the default gateway and first user.
source /root/admin-openrc.sh

neutron router-create router1
neutron router-interface-add router1 first_user-subnet
neutron router-gateway-set router1 ext-net

