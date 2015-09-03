#! /bin/bash

#install required packages
apt-get -y --force-yes install ${MYSQL_DB_PACKAGES[*]}
apt-get -y --force-yes install ${TOMCAT_PACKAGES[*]}

rm -rf $CASE_1_LOCAL
mkdir -p $CASE_1_LOCAL

#Get src from remote repository
git clone $CASE_1_REPO $CASE_1_LOCAL

#compile src
source ./compile-src.sh $CASE_1_LOCAL/source/demo-case2 $HPSA_BINARY/case-1

#update packages index file
source ./create-index-file.sh

chmod +x ./case-1-deploy.sh