#! /bin/bash

COMMON_PACKAGES[0]=git-core
COMMON_PACKAGES[1]=dpkg-dev
COMMON_PACKAGES[2]=unzip
COMMON_PACKAGES[3]=ansible
COMMON_PACKAGES[4]=default-jdk
COMMON_PACKAGES[5]=haproxy
COMMON_PACKAGES[6]=python-novaclient
COMMON_PACKAGES[7]=mc

MYSQL_DB_PACKAGES[0]=python-mysqldb
MYSQL_DB_PACKAGES[1]=mysql-client
MYSQL_DB_PACKAGES[2]=mysql-server

GALERA_PACKAGES[0]=python-mysqldb
GALERA_PACKAGES[1]=mariadb-galera-server
GALERA_PACKAGES[2]=galera-3
GALERA_PACKAGES[3]=rsync

TOMCAT_PACKAGES[0]=tomcat7
TOMCAT_PACKAGES[1]=tomcat7-docs
TOMCAT_PACKAGES[2]=tomcat7-admin
TOMCAT_PACKAGES[3]=tomcat7-examples

JAVA_PACKAGES[0]=oracle-java7-installer
JAVA_PACKAGES[1]=oracle-java7-set-default

export COMMON_PACKAGES
export MYSQL_DB_PACKAGES
export GALERA_PACKAGES
export TOMCAT_PACKAGES
export SRC_COMPILE_PACKAGES