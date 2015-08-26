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
# Current image is: Ubuntu Server 14.04.1 LTS (amd64 20150706) - Partner Image
# 
export IMAGE_ID=564be9dd-5a06-4a26-ba50-9453f972e483

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
export PACKAGES_REPOSITORY_IP=$(hostname -I | xargs)

#
# Path to folder with compiled expenses.war file
#
export CASE_2_BIN=/home/out/case-2