Create a new cluster

1. Create security group in the console and allow ports:
TCP: 22, 80, 3306, 4444, 4567, 4568
UDP: 4567

2. Download and execute api configuration script
"source Hewlett-Packard0517-openrc.sh"

3. Configure cluster in the cluster-configuration.sh 

4. Run command: "source create-cluster.sh"

Add MySql node
Run "source galera_node_add.sh"

Remove MySql node
Run "source galera_node_delete.sh"


Troubleshooting cases:

Fix MySql cluster issues.
Run "source galera_reconfigure.sh"

How to remove cluster:
1. Go to the Instances tab and remove instances with the cluster prefix
2. Go to the "Access & Security -> Key Pairs" tab and remvoe keypair.
3. Go to the "Access & Security -> Floating IPs" and remove unassigned IPs
4. Open local folder (hpsource/case-2) and remove "keys" folder
