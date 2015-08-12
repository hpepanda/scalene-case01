#! /bin/bash

#install required packages
apt-get -y --force-yes install ${MYSQL_DB_PACKAGES[*]}
apt-get -y --force-yes install tomcat7

#Get src from remote repository
git clone $CASE_0_REPO $GIT_LOCAL_REPO

#compile src
source ./compile-src.sh $GIT_LOCAL_REPO/case-0/source /home/out/case-0

#update packages index file
source ./create-index-file.sh
