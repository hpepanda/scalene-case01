 #!/bin/bash
export ANSIBLE_HOST_KEY_CHECKING=False

INSTPREFIX=$CLUSTER_PREFIX
INSTPREFIX+="-MySql"

# Select galera nodes
nova list --fields name | grep -o "$INSTPREFIX.*\s" > galera_mysql_nodes.tmp
IFS=$'\r\n' GLOBIGNORE='*' :; INSTANCES_LIST=($(cat galera_mysql_nodes.tmp))

COUNTER=0
echo $CLUSTER_IP_MEMBERS
echo "Choose node to remove."
for instance in "${INSTANCES_LIST[@]}" ; do
    echo $COUNTER. $instance
    let COUNTER=COUNTER+1
done

read -e -p "Type node number:" NODENAME

INSTNAME=${INSTANCES_LIST[$NODENAME]}
echo Removing $INSTNAME...

# Remove from HA PROXY
HA_PROXY_NAME=$CLUSTER_PREFIX
HA_PROXY_NAME+="-Proxy_Db"
source ./haproxy_clients_remove.sh $HA_PROXY_NAME $INSTNAME

# Remove instance
nova delete $INSTNAME

sleep 60

# Reconfigure cluster
source ./galera_reconfigure.sh

