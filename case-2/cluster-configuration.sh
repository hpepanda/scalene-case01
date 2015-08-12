#
# Cluster settings
#

#
# Flavor Id constants
# Id can be found by executing command: nova flavor-list
#
# Flavor standard.small id
export FSMALL=101
# Flavor standard.medium id
export FMEDIUM=102

#
# Instance image Id
# Current image is: Ubuntu Server 14.04.1 LTS (amd64 20140927) - Partner Image
# 
export IMAGE_ID=9d25fe2d-cf31-4b05-8c58-f238ec78e633

#
# External network name
# Can be found here: https://horizon.hpcloud.com/project/network_topology/
#
export EXTNETNAME=Ext-Net

#
# Internal network Id
# Can be found here: https://horizon.hpcloud.com/project/networks/
#
export NETID=bbf314de-c466-4d78-ad47-10a9de081508

#
# Cluster prefix
#
export CLUSTER_PREFIX="Case2-Cluster"

#
# My SQL instances count
#
export MYSQL_COUNT=3

#
# Packages local repository ip
#
export PACKAGES_REPOSITORY_IP="10.0.0.206"