# !/bin/bash

echo "Enter Key Name:"
read KEY_NAME

export PACKAGES_REPOSITORY_IP=$(hostname -I)

ansible-playbook ansible/deploy_to_pre_created.yml --private-key=keys/$KEY_NAME.pem -u ubuntu