#!/bin/bash
#Script for deleting app from haproxy cluster

HAPROXY_ADDR=$1
INSTANCE=$2

ansible-playbook ansible/del_hadb.yml -u ubuntu -l $(cat pub_ip/$HAPROXY_ADDR) -i pub_ip/$HAPROXY_ADDR --private-key=keys/$CLUSTER_PREFIX.pem -e "ipaddr=$(cat local_ip/$INSTANCE)"