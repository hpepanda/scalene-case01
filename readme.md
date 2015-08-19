##TODO:

1. `sudo -s`
2. `source ~/Hewlett-Packard0517-openrc.sh`
3. `source ./setup-repository.sh`
4. `source ./case-[n]-setup.sh`
5. Start http-daemon:  
   `source install-start-daemon.sh /var/cache/apt/archives 8008`

###NOTE:
- Target instances should base on the same image as local repository for the packages compatibility.   

- Ansible version should be the latest. If it's not:  
`$ apt-get install software-properties-common`  
`$ apt-add-repository ppa:ansible/ansible`  
`$ apt-get update`  
`$ apt-get install ansible`  