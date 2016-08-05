##Case-1

###Public cloud

/case-1  

1. `sudo -s`  
   `source ~/Hewlett-Packard0517-openrc.sh`  
   `create-environment.sh`     
   
2. Add instance public ip to /etc/ansible/hosts  
    `[case-1-app]`  
    `{app instance ip}`  

    `[case-1-db]`  
    `{db instance ip}`      
    
3. `ansible-playbook deploy-case-1-db-\[1\].yml --private-key=db1.pem -u ubuntu`  
   `ansible-playbook deploy-case-1-app-\[2\].yml --private-key=app1.pem -u ubuntu`  
   

###Private cloud

/case-1-private-cloud  

1. `sudo -s`  
   `source ~/Hewlett-Packard0517-openrc.sh`  
   `create-environment.sh`     

