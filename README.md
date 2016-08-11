#Scalene Case 0-1

###Use case: Move Applications to Cloud
Tomcat+MySQL version of "Scalene Expense Manager" application available for deploying in Helion Openstack environment.
####Available in configurations:
 * 1 host VM for both server and database
 * 2 host VMs - one for server and one for database

Could be deployed in public cloud (connected to Internet) or private cloud (no Internet connection, requires pre-installed [MasterVM](http://git) to install all dependencies)

##Sub-projects

###Scalene Case-0
Branch name: ***case0***

Uses 1 host VM for both server and database.

####Installation instructions

##### Case for public cloud

1.  Run from Ubuntu instance following commands:
    ```
    sudo -s  
    source ~/[path to HOS configuration file].sh  
    source start-instance.sh
    ```

2.  Add target instance's public ip to /etc/ansible/hosts  
    ```
    [case-0]  
    {assigned_ip}
    ```

3.  Run ansible script to deploy application
    ```
    ansible-playbook deploy-case-0.yml --private-key={{instance_name}}.pem -u ubuntu
    ```


##### Case for private cloud

1.  Deploy Scalene Case-0 to MasterVM  
    ```
    sudo -s  
    source ~/[path to HOS configuration file].sh  
    source start-instance-private.sh
    ```

###Scalene Case-1
Branch name: ***case1***

Creates 2 VMs with `nova` command and deploys database and application on the separate instances

####Installation instructions

#####Case for public cloud

1. Run from Ubuntu instance following commands:
   ```
   sudo -s  
   cd case-1
   source ~/[path to HOS configuration file].sh  
   create-environment.sh
   ```
   
2. Add target instances' public ip to /etc/ansible/hosts  
    ```
    [case-1-app]
    {app instance ip}  

    [case-1-db]
    {db instance ip}      
    ```
    
3. Run ansible scripts to deploy application and populate db
   ```
   ansible-playbook deploy-case-1-db-\[1\].yml --private-key=db1.pem -u ubuntu 
   ansible-playbook deploy-case-1-app-\[2\].yml --private-key=app1.pem -u ubuntu
   ```

###Private cloud

1. Run on MasterVM to deploy Scalene Case-1
   ```
   sudo -s
   cd case-1-private-cloud  
   source ~/[path to HOS configuration file].sh  
   create-environment.sh    
   ```

###Scalene MasterVM
Branch name: ***scalene-masterVM***

Master VM downloads all dependencies for cases 0-2, compiles application and sets up all the necessary environment variables. 

1. `sudo -s`
2. Upload key. Save it's path, like:
    ```
    export CASE1_KEY_PATH=home/ubuntu/[ssh_key_name].pem
    chmod 400 $CASE1_KEY_PATH 
    ```
    
3. Run setup script `source ./setup-repository.sh`

***NOTE:***
Target instances should base on the same image as local repository for the packages compatibility.