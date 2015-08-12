#!/bin/bash

INSTYPE=$1
INSTNAME=$2

case $INSTYPE in
     1)      
		echo "Create HAProxy inst"
		nova boot --flavor "$FSMALL" --image "$IMAGE_ID" --key_name "$CLUSTER_PREFIX" --security_groups "$TOMCAT_SECURITY_GROUP" $INSTNAME --poll --user-data hosts.sh --nic net-id=$NETID

		sleep 15 # delay for nw_info cache renew. see https://bugs.launchpad.net/nova/+bug/1249065

		nova list|grep $INSTNAME |grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+'|grep '10.0.0' > local_ip/$INSTNAME

		sleep 300 #for ssh port to be opened

        ansible-playbook ansible/config_src_list.yml -i local_ip/$INSTNAME --private-key=keys/$CLUSTER_PREFIX.pem -u ubuntu -e "repo_ip=$PACKAGES_REPOSITORY_IP" -v
        ansible-playbook ansible/haproxyapp.yml -i local_ip/$INSTNAME --private-key=keys/$CLUSTER_PREFIX.pem -u ubuntu -v
        ;;
     2)      
        echo "Create APP inst"
        nova boot --flavor "$FMEDIUM" --image "$IMAGE_ID" --key_name "$CLUSTER_PREFIX" --security_groups "$TOMCAT_SECURITY_GROUP" $INSTNAME --poll --user-data hosts.sh --nic net-id=$NETID

        sleep 15 # delay for nw_info cache renew. see https://bugs.launchpad.net/nova/+bug/1249065

        nova list|grep $INSTNAME|grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+'|grep '10.0.0' > local_ip/$INSTNAME

        sleep 300 #for ssh port to be opened

        ansible-playbook ansible/config_src_list.yml -i local_ip/$INSTNAME --private-key=keys/$CLUSTER_PREFIX.pem -u ubuntu -e "repo_ip=$PACKAGES_REPOSITORY_IP" -v
	    ansible-playbook ansible/tomcat.yml -i local_ip/$INSTNAME --private-key=keys/$CLUSTER_PREFIX.pem -u ubuntu -v
        ansible-playbook ansible/appdeploy.yml -i local_ip/$INSTNAME --private-key=keys/$CLUSTER_PREFIX.pem -u ubuntu -e "dbproxy_ip=$DB_PROXY_LOCAL_IP" -v
        ;;
	4)
        echo "Create DB HA Proxy instance"
        nova boot --flavor "$FSMALL" --image "$IMAGE_ID" --key_name "$CLUSTER_PREFIX" --security_groups "$MYSQL_SECURITY_GROUP" $INSTNAME --poll --user-data hosts.sh --nic net-id=$NETID

        sleep 15 # delay for nw_info cache renew. see https://bugs.launchpad.net/nova/+bug/1249065

        nova list|grep $INSTNAME|grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+'|grep '10.0.0' > local_ip/$INSTNAME

        read -r INSTIP < local_ip/$INSTNAME
		DB_PROXY_LOCAL_IP=$INSTIP
		export DB_PROXY_LOCAL_IP

		sleep 300 #for ssh port to be opened

        ansible-playbook ansible/config_src_list.yml -i local_ip/$INSTNAME --private-key=keys/$CLUSTER_PREFIX.pem -u ubuntu -e "repo_ip=$PACKAGES_REPOSITORY_IP" -v
        ansible-playbook ansible/haproxydb.yml -i local_ip/$INSTNAME --private-key=keys/$CLUSTER_PREFIX.pem -u ubuntu -v
        ;;
esac

