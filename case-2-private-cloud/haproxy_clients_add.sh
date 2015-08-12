#!/bin/bash
#Script for adding app ip into haproxy cluster

HAPROXY_ADDR=$1
INSTANCE=$2

ansible-playbook ansible/add_hadb.yml -u ubuntu -l $(cat local_ip/$HAPROXY_ADDR) -i local_ip/$HAPROXY_ADDR --private-key=keys/$CLUSTER_PREFIX.pem -e "ipaddr=$(cat local_ip/$INSTANCE)" -e "node_name=$INSTANCE"
