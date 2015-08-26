# !/bin/bash

echo "Enter Key Name:"
read KEY_NAME

export CASE_2_BIN=/home/out/case-2

echo "Provide path to expenses.war (default $CASE_2_BIN):"
read CASE_2_BIN_NEW

if [[ $CASE_2_BIN_NEW ]]; then
    CASE_2_BIN=$CASE_2_BIN_NEW
fi

echo "$CASE_2_BIN"

export PACKAGES_REPOSITORY_IP=$(hostname -I  | xargs)

ansible-playbook ansible/deploy_to_pre_created.yml --private-key=keys/$KEY_NAME.pem -u ubuntu