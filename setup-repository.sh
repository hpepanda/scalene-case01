#! /bin/bash

#Update APT package cache
apt-get update

#Define required packages
source ./packages-config.sh
source ./repository_config.sh

#Install common for all cases packages
apt-get -y --force-yes install ${COMMON_PACKAGES[*]}

#Get sources from git
export GIT_LOCAL_REPO=/home/hpsa-demo

mkdir -p /home/out

###Install packages for compiling

#Add Java repository to sources
add-apt-repository --yes ppa:webupd8team/java

#Autoaccept license for Java
echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections

#Update APT package cache
apt-get update

#Install Java 7
apt-get -y --force-yes --install-recommends install ${JAVA_PACKAGES[*]}

#Install Apache Maven
apt-get --force-yes install maven2