#! /bin/bash

apt-get install software-properties-common
apt-add-repository ppa:ansible/ansible

#Update APT package cache
apt-get update

#Define required packages
source ./packages-config.sh
source ./repository-config.sh

chmod +x ./compile-src.sh
cp ./compile-src.sh /usr/bin

#Install common for all cases packages
apt-get -y --force-yes install ${COMMON_PACKAGES[*]}

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

#Get sources from git, compile java for each case
source ./case-0-setup.sh
source ./case-1-setup.sh
source ./case-2-setup.sh

#For skipping verification
cat <<EOF >> /etc/ssh/ssh_config

Host 10.0.0.*
   StrictHostKeyChecking no
   UserKnownHostsFile /dev/null
EOF

#Launch services
source ./http-daemon/install-start-daemon.sh
mkdir http-daemon/hosts-config

source ./hosts-config-watcher