 #!/bin/bash

MYSQL_SECURITY_GROUP=$CLUSTER_PREFIX;
export MYSQL_SECURITY_GROUP+="-MySQL"
nova secgroup-create $MYSQL_SECURITY_GROUP "Db HA-Proxy and Galera security rules"
nova secgroup-add-rule $MYSQL_SECURITY_GROUP udp 4567 4567 "0.0.0.0/0"
nova secgroup-add-rule $MYSQL_SECURITY_GROUP tcp 4444 4444 "0.0.0.0/0"
nova secgroup-add-rule $MYSQL_SECURITY_GROUP tcp 4567 4567 "0.0.0.0/0"
nova secgroup-add-rule $MYSQL_SECURITY_GROUP tcp 4568 4568 "0.0.0.0/0"
nova secgroup-add-rule $MYSQL_SECURITY_GROUP tcp 3306 3306 "0.0.0.0/0"
nova secgroup-add-rule $MYSQL_SECURITY_GROUP tcp 1 65535 "10.0.0.0/24"
nova secgroup-add-rule $MYSQL_SECURITY_GROUP tcp 22 22 "0.0.0.0/0"


TOMCAT_SECURITY_GROUP=$CLUSTER_PREFIX;
export TOMCAT_SECURITY_GROUP+="-Tomcat" 
nova secgroup-create $TOMCAT_SECURITY_GROUP "Tomcat and HA-Proxy security rules"
nova secgroup-add-rule $TOMCAT_SECURITY_GROUP tcp 80 80 "0.0.0.0/0"
nova secgroup-add-rule $TOMCAT_SECURITY_GROUP tcp 1 65535 "10.0.0.0/24"
nova secgroup-add-rule $TOMCAT_SECURITY_GROUP tcp 22 22 "0.0.0.0/0"