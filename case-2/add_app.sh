#!/bin/bash
#Script for adding app ip into haproxy cluster
#echo -n 'Please enter HAProxy DB hostname: '
#read HAPROXY_ADDR
#echo "\n"

#echo -n "Please enter name of TOMCAT instance: "
#read INSTANCE

HAPROXY_ADDR=$1
INSTANCE=$2


ansible-playbook ansible/add_haapp.yml -u ubuntu -l $(cat pub_ip/$HAPROXY_ADDR) -i pub_ip/$HAPROXY_ADDR --private-key=keys/$CLUSTER_PREFIX.pem -e "ipaddr=$(cat local_ip/$INSTANCE)" -e "node_name=$INSTANCE"
