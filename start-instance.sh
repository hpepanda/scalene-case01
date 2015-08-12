
#!/bin/bash
NETID=bbf314de-c466-4d78-ad47-10a9de081508

echo "Enter Instance Name"
read INSTNAME
# create rsa keypair for the Instance
nova keypair-add $INSTNAME > $INSTNAME.pem
# create and lauch new Instance from th image "Ubuntu Server 14.04.1 LTS (amd64 20140927) - Partner Image" and store info about instance in the file
nova boot --flavor "101" --image "9d25fe2d-cf31-4b05-8c58-f238ec78e633" --key_name "$INSTNAME" --security_groups "DemoHAProxyAppSec,tomcat-sg,default" $INSTNAME --nic net-id=$NETID > $INSTNAME.data
# ceate paublip IP for the instance
TMPIPFILE=ip-$INSTNAME.tmp
touch $TMPIPFILE
nova floating-ip-create |grep Ext-Net | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' > $TMPIPFILE
read -r INSTEXTIP < $TMPIPFILE
rm $TMPIPFILE

sleep 15 # delay for nw_info cache renew. see https://bugs.launchpad.net/nova/+bug/1249065 
# associate public IP with the instance
nova floating-ip-associate $INSTNAME $INSTEXTIP
# sec fix to use keyfile and disallow access to the file with all data about new instance
chmod 400 $INSTNAME.pem
chmod 400 $INSTNAME.data

echo "Now You can login into new instance via SSH"
echo "Using keyfile: ssh -i $INSTNAME.pem ubuntu@$INSTEXTIP"
echo "Instance config located in $INSTNAME.data"
