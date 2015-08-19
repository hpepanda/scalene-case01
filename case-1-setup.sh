#! /bin/bash

#install required packages
apt-get -y --force-yes install ${MYSQL_DB_PACKAGES[*]}
apt-get -y --force-yes install tomcat7

mkdir -p $CASE_1_LOCAL

#Get src from remote repository
git clone $CASE_1_REPO $CASE_1_LOCAL

#update packages index file
source ./create-index-file.sh