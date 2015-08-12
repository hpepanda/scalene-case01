 #!/bin/bash
export ANSIBLE_HOST_KEY_CHECKING=False

INSTPREFIX=$CLUSTER_PREFIX
INSTPREFIX+="-MySql_"
INSTNAME=$INSTPREFIX

read -e -p "Type node name: " NODENAME
INSTNAME+=$NODENAME

echo Creating $INSTNAME instance
nova boot --flavor "$FSMALL" --image "$IMAGE_ID" --key_name "$CLUSTER_PREFIX" --security_groups "$MYSQL_SECURITY_GROUP" $INSTNAME --poll --user-data hosts.sh --nic net-id=$NETID

sleep 15 # delay for nw_info cache renew. see https://bugs.launchpad.net/nova/+bug/1249065
	
nova floating-ip-create |grep $EXTNETNAME | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' > pub_ip/$INSTNAME
nova list|grep $INSTNAME|grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+'|grep '10.0.0' > local_ip/$INSTNAME
read -r INSTIP < pub_ip/$INSTNAME
# associate public IP with the instance
nova floating-ip-associate $INSTNAME $INSTIP
	
sleep 60

# Looking for previously created instances
nova list --name $INSTPREFIX |grep -Po '(?<=, )[0-9.]*' > galera_mysql_nodes.tmp
IFS=$'\r\n' GLOBIGNORE='*' :; INSTANCES_LIST=($(cat galera_mysql_nodes.tmp))

# Installing galera on the new instance
echo $INSTIP > ./ansible_mysql.host
ansible-playbook ansible/galera.yml -i ./ansible_mysql.host --private-key=keys/$CLUSTER_PREFIX.pem -u ubuntu -v -e "galera_node_ip=$INSTIP" -e "galera_add_node=True"

# Reconfigure cluster
source ./galera_reconfigure.sh

# Adding new node to the HA Proxy
HA_PROXY_NAME=$CLUSTER_PREFIX
HA_PROXY_NAME+="-Proxy_Db"
source ./haproxy_clients_add.sh $HA_PROXY_NAME $INSTNAME