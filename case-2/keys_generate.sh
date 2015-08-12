 #!/bin/bash

mkdir -p keys
mkdir -p local_ip
mkdir -p pub_ip

# create rsa keypair for the Instance
nova keypair-add $CLUSTER_PREFIX > keys/$CLUSTER_PREFIX.pem
chmod 400 keys/$CLUSTER_PREFIX.pem