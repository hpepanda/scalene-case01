#!/bin/bash
#Script for adding app ip into haproxy cluster
#$1 = hostname/ip 
#$2 = ipaddr
#$3 = node_name
#echo -n 'Please enter HAProxy DB hostname: '
#read HAPROXY_ADDR
#echo "\n"

#echo -n "Please enter name of TOMCAT instance: "
#read INSTANCE

HAPROXY_ADDR=$1
INSTANCE=$2


ansible-playbook ansible/del_haapp.yml -u ubuntu -l $(cat pub_ip/$HAPROXY_ADDR) -i pub_ip/$HAPROXY_ADDR --private-key=keys/$CLUSTER_PREFIX.pem -e "ipaddr=$(cat local_ip/$INSTANCE)"
exit 0
