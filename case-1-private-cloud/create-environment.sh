
#!/bin/bash
echo "Enter App Instance Name"
read APPINSTNAME
echo "Enter DB Instance Name"
read DBINSTNAME
echo "Starting App Instance"
/bin/bash ./start-instance.sh $APPINSTNAME
echo "Starting DB Instance"
/bin/bash ./start-instance.sh $DBINSTNAME

SRC_IP=$(hostname -I)

ansible-playbook deploy-case-1-db-\[1\].yml -i $DBINSTNAME.ip --private-key=$DBINSTNAME.pem -u ubuntu -v -e "repo_ip=$SRC_IP"

sed -i "s/localhost/$(< $DBINSTNAME.ip)/g" ../source/demo-case2/src/main/resources/application.properties
compile-src.sh ../source/demo-case2 /home/out/case-1

ansible-playbook deploy-case-1-app-\[2\].yml -i $APPINSTNAME.ip --private-key=$APPINSTNAME.pem -u ubuntu -v -e "repo_ip=$SRC_IP"