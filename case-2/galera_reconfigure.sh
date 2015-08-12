 #!/bin/bash
export ANSIBLE_HOST_KEY_CHECKING=False

INSTPREFIX=$CLUSTER_PREFIX
INSTPREFIX+="-MySql"
BOOTERPREFIX=$CLUSTER_PREFIX
BOOTERPREFIX+="-Bootstrapper-MySql"

nova list --name $BOOTERPREFIX |grep -Po '(?<=, )[0-9.]*' > galera_mysql_nodes.tmp
read -r BOOTERIP < galera_mysql_nodes.tmp

# Looking for previously created instances
nova list --name $INSTPREFIX |grep -Po '(?<=, )[0-9.]*' > galera_mysql_nodes.tmp
IFS=$'\r\n' GLOBIGNORE='*' :; INSTANCES_LIST=($(cat galera_mysql_nodes.tmp))
CLUSTER_IP_MEMBERS=$( IFS=, ; echo "${INSTANCES_LIST[*]}" )
CLUSTER_IP_MEMBERS+=",$BOOTERIP"

for instance in "${INSTANCES_LIST[@]}" ; do
	echo $instance > ./ansible_mysql.host
	ansible-playbook ansible/galera_stop.yml -i ./ansible_mysql.host --private-key=keys/$CLUSTER_PREFIX.pem -u ubuntu -v
done

# Reconfigure existing cluster
for instance in "${INSTANCES_LIST[@]}" ; do
	echo $instance > ./ansible_mysql.host
	ansible-playbook ansible/galera_update_configuration.yml -i ./ansible_mysql.host --private-key=keys/$CLUSTER_PREFIX.pem -u ubuntu -v -e "galera_cluster_members=$CLUSTER_IP_MEMBERS" -e "galera_node_ip=$instance"
done