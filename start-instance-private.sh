
#!/bin/bash
NETID=bbf314de-c466-4d78-ad47-10a9de081508

echo "Enter Instance Name"
read INSTNAME

# create rsa keypair for the Instance
nova keypair-add $INSTNAME > $INSTNAME.pem

# create and lauch new Instance from th image "Ubuntu Server 14.04.1 LTS (amd64 20150706) - Partner Image" and store info about instance in the file
nova boot --flavor "101" --image "564be9dd-5a06-4a26-ba50-9453f972e483" --key_name "$INSTNAME" --security_groups "DemoHAProxyAppSec,tomcat-sg,default" $INSTNAME --nic net-id=$NETID > $INSTNAME.data

# sec fix to use keyfile and disallow access to the file with all data about new instance
chmod 400 $INSTNAME.pem
chmod 400 $INSTNAME.data

echo "Wait for ssh port to be opened"
sleep 300

SRC_IP=$(hostname -I)
nova list|grep $INSTNAME|grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+'|grep '10.0.0' > $INSTNAME.ip

ansible-playbook deploy-case-0-private.yml -i $INSTNAME.ip --private-key=$INSTNAME.pem -u ubuntu -v -e "repo_ip=$SRC_IP"

echo "Now You can login into new instance via SSH"
echo "Using keyfile: ssh -i $INSTNAME.pem ubuntu@$(< $INSTNAME.ip)"
echo "Instance config located in $INSTNAME.data"
