CUR_PATH=$(pwd)

CASE1_ROOT=$CASE_1_LOCAL/case-1-private-cloud
#cp ./http-daemon/hosts-config/case_1_ssh_key.pem $CASE1_ROOT
cp ./http-daemon/hosts-config/hosts-config.ini $CASE1_ROOT

cd $CASE1_ROOT
ansible-playbook ansible/deploy-case-1.yml -i hosts-config.ini --private-key=$CASE1_KEY_PATH -u ubuntu -v

cd $CUR_PATH