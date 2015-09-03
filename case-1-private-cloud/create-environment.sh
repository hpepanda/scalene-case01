#!bin/bash

echo "Enter app prefix name"
read APP_PREFIX

export APP_PREFIX
export SRC_IP=$(hostname -I | xargs)
export CASE_1_BIN=/home/out/case-1

# create rsa keypair for the Instance
nova keypair-add $APP_PREFIX > $APP_PREFIX.pem
chmod 400 $APP_PREFIX.pem

echo "Starting App Instance"
source start-instance.sh "$APP_PREFIX-app"

echo "Starting DB Instance"
source start-instance.sh "$APP_PREFIX-db"

source make-hosts-config.sh "$(<"$APP_PREFIX-app".ip)" "$(<"$APP_PREFIX-db".ip)"

export CASE1_DB_IP=$(<"$APP_PREFIX-db".ip)

echo "Wait for ssh port to be opened"
sleep 300

ansible-playbook ansible/deploy-case-1.yml -i hosts-config.ini --private-key=$APP_PREFIX.pem -u ubuntu -v
