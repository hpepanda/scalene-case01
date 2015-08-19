## To start instance in the public cloud

1.  `sudo -s`  
    `source ~/Hewlett-Packard0517-openrc.sh`  
    `source start-instance.sh`


2.  Add instance public ip to /etc/ansible/hosts  
    `[case-0]`  
    `{{assigned_ip}}`  


3.  `ansible-playbook deploy-case-0.yml --private-key={{instance_name}}.pem -u ubuntu`


## To start instance in the private cloud

1.  `sudo -s`  
    `source ~/Hewlett-Packard0517-openrc.sh`  
    `source start-instance-private.sh`  
