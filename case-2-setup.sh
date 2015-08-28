#! /bin/bash

#install required packages

add-apt-repository --yes 'deb http://mirror.jmu.edu/pub/mariadb/repo/5.5/ubuntu precise main'
apt-get update

apt-get -y --force-yes install ${GALERA_PACKAGES[*]}
apt-get -y --force-yes install ${TOMCAT_PACKAGES[*]}

rm -rf $CASE_2_LOCAL
mkdir -p $CASE_2_LOCAL

#Get src from remote repository
git clone $CASE_2_REPO $CASE_2_LOCAL

#compile src
source ./compile-src.sh $CASE_2_LOCAL/source/demo-case2 $HPSA_BINARY/case-2

#update packages index file
source ./create-index-file.sh