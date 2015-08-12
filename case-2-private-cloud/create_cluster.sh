#!/bin/bash

# Disable SSH connect confirmation
export ANSIBLE_HOST_KEY_CHECKING=False

source ./security_group_create.sh

# Update cluster configuration variables
source ./cluster-configuration.sh

# Generate SSH key
source ./keys_generate.sh

# Create galera cluster
source ./galera_create.sh

source ./create_inst.sh 2 "$CLUSTER_PREFIX-Tomcat_1"
source ./create_inst.sh 2 "$CLUSTER_PREFIX-Tomcat_2"
source ./create_inst.sh 2 "$CLUSTER_PREFIX-Tomcat_3"

source ./create_inst.sh 1 "$CLUSTER_PREFIX-HA_Proxy_App"

source ./add_app.sh "$CLUSTER_PREFIX-HA_Proxy_App" "$CLUSTER_PREFIX-Tomcat_1"
source ./add_app.sh "$CLUSTER_PREFIX-HA_Proxy_App" "$CLUSTER_PREFIX-Tomcat_2"
source ./add_app.sh "$CLUSTER_PREFIX-HA_Proxy_App" "$CLUSTER_PREFIX-Tomcat_3"
