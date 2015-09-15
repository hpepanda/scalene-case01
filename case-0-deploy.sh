CUR_PATH=$(pwd)

export CASE_0_BIN=/home/out/case-0

cd $CASE_0_LOCAL

ansible-playbook -i "localhost," -c local deploy-case-0-local.yml

cd $CUR_PATH
