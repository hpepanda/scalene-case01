#!/bin/bash

INSTYPE=$1
INSTNAME=$2

case $INSTYPE in
     1)      
		echo "Create HAProxy inst"
		nova boot --flavor "$FSMALL" --image "$IMAGE_ID" --key_name "$CLUSTER_PREFIX" --security_groups "$TOMCAT_SECURITY_GROUP" $INSTNAME --poll --user-data hosts.sh --nic net-id=$NETID

		sleep 15 # delay for nw_info cache renew. see https://bugs.launchpad.net/nova/+bug/1249065

		nova floating-ip-create |grep $EXTNETNAME | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' > pub_ip/$INSTNAME
		nova list|grep $INSTNAME |grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+'|grep '10.0.0' > local_ip/$INSTNAME

		read -r INSTIP < pub_ip/$INSTNAME

		# associate public IP with the instance
		nova floating-ip-associate $INSTNAME $INSTIP
		sleep 60

        ansible-playbook ansible/haproxyapp.yml -i pub_ip/$INSTNAME --private-key=keys/$CLUSTER_PREFIX.pem -u ubuntu -v
        ;;
     2)      
        echo "Create APP inst"
        nova boot --flavor "$FMEDIUM" --image "$IMAGE_ID" --key_name "$CLUSTER_PREFIX" --security_groups "$TOMCAT_SECURITY_GROUP" $INSTNAME --poll --user-data hosts.sh --nic net-id=$NETID

        sleep 15 # delay for nw_info cache renew. see https://bugs.launchpad.net/nova/+bug/1249065

        nova floating-ip-create |grep $EXTNETNAME | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' > pub_ip/$INSTNAME
        nova list|grep $INSTNAME|grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+'|grep '10.0.0' > local_ip/$INSTNAME

        read -r INSTIP < pub_ip/$INSTNAME

        # associate public IP with the instance
        nova floating-ip-associate $INSTNAME $INSTIP

		sleep 60

	    ansible-playbook ansible/tomcat.yml -i pub_ip/$INSTNAME --private-key=keys/$CLUSTER_PREFIX.pem -u ubuntu -v
        ansible-playbook ansible/appdeploy.yml -i pub_ip/$INSTNAME --private-key=keys/$CLUSTER_PREFIX.pem -u ubuntu -e "dbproxy_ip=$DB_PROXY_LOCAL_IP" -v
        ;;
	4)
        echo "Create DB HA Proxy instance"
        nova boot --flavor "$FSMALL" --image "$IMAGE_ID" --key_name "$CLUSTER_PREFIX" --security_groups "$MYSQL_SECURITY_GROUP" $INSTNAME --poll --user-data hosts.sh --nic net-id=$NETID

        sleep 15 # delay for nw_info cache renew. see https://bugs.launchpad.net/nova/+bug/1249065

        nova floating-ip-create |grep $EXTNETNAME | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' > pub_ip/$INSTNAME
        nova list|grep $INSTNAME|grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+'|grep '10.0.0' > local_ip/$INSTNAME

        read -r INSTIP < pub_ip/$INSTNAME
		DB_PROXY_LOCAL_IP=$INSTIP
		export DB_PROXY_LOCAL_IP

        # associate public IP with the instance
        nova floating-ip-associate $INSTNAME $INSTIP

		sleep 60

        ansible-playbook ansible/haproxydb.yml -i pub_ip/$INSTNAME --private-key=keys/$CLUSTER_PREFIX.pem -u ubuntu -v
        ;;
esac

