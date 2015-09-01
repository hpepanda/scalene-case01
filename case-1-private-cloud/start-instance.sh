#!/bin/bash

NETID=bbf314de-c466-4d78-ad47-10a9de081508

INSTNAME=$1
echo $INSTNAME

# create and lauch new Instance from th image "Ubuntu Server 14.04.1 LTS (amd64 20150706) - Partner Image" and store info about instance in the file
nova boot --flavor "101" --image "564be9dd-5a06-4a26-ba50-9453f972e483" --key_name "$APP_PREFIX" --security_groups "DemoHAProxyAppSec,tomcat-sg,default" $INSTNAME --poll --user-data hosts.sh --nic net-id=$NETID > $INSTNAME.data

sleep 30 # delay for nw_info cache renew. see https://bugs.launchpad.net/nova/+bug/1249065
chmod 400 $INSTNAME.data

nova list|grep $INSTNAME|grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+'|grep '10.0.0' > $INSTNAME.ip

echo "Now You can login into new instance via SSH"
echo "Using keyfile: ssh -i $INSTNAME.pem ubuntu@$(< $INSTNAME.ip)"
echo "Instance config located in $INSTNAME.data"
