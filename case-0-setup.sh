#! /bin/bash

#install required packages
apt-get -y --force-yes install ${MYSQL_DB_PACKAGES[*]}
apt-get -y --force-yes install tomcat7

mkdir -p $CASE_0_LOCAL

#Get src from remote repository
git clone $CASE_0_REPO $CASE_0_LOCAL

#compile src
source ./compile-src.sh $CASE_0_LOCAL/source $HPSA_BINARY/case-0

#update packages index file
source ./create-index-file.sh
