CUR_PATH=$(pwd)

CASE1_ROOT=$CASE_1_LOCAL/case-1-private-cloud
cp hosts-config/hosts-config.ini $CASE1_ROOT

export SRC_IP=$(hostname -I | xargs)
export SRC_ALIAS=$(hostname)
export CASE_1_BIN=/home/out/case-1

cd $CASE1_ROOT
ansible-playbook ansible/add-static-ip.yml -i hosts-config.ini --private-key=$CASE1_KEY_PATH -u ubuntu -v
ansible-playbook ansible/deploy-case-1.yml -i hosts-config.ini --private-key=$CASE1_KEY_PATH -u ubuntu -v

cd $CUR_PATH
