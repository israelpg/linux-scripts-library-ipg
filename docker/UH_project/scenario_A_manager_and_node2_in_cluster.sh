# Scenario A
# Note:
# pcs_cluster_manager is running an active pcsd.service, it has binded port 2224 to Host OS address: localhost:2224 (IP: .2)
# The other node pcs_cluster_node2 which is part of cluster-A-test is container with IP .10
82b2d4e1b67e        5b105ebe8e6b              "/usr/lib/systemd/..."   3 hours ago         Up 3 hours                  0.0.0.0:2224->2224/tcp    pcs_cluster_manager
3139fd0eb2e        5b105ebe8e6b              "/usr/lib/systemd/..."   21 hours ago        Up 21 hours                 2224/tcp                  pcs_cluster_node2

# This time instead of managing cluster via browser : 

https://localhost:2224/manage

# CLI following tutorial:
https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/high_availability_add-on_administration/ch-startup-haaa#s1-clusterinstall-HAAA

# From the pcs_cluster_manager cli : From manager !!!

# 1) Authenticate the nodes which are going to be part of the cluster: node1 and node2, referred by IP address (perhaps an extended solution is to use hostnames, containerID ...)

[root@82b2d4e1b67e /]# pcs cluster auth 172.18.0.2 172.18.0.10
Username: hacluster
Password: 
172.18.0.2: Authorized
172.18.0.10: Authorized

# 2) Create cluster :

[root@82b2d4e1b67e /]# pcs cluster setup --start --name cluster2-test2 172.18.0.2 172.18.0.10
Destroying cluster on nodes: 172.18.0.2, 172.18.0.10...
172.18.0.2: Stopping Cluster (pacemaker)...
172.18.0.10: Stopping Cluster (pacemaker)...
172.18.0.2: Successfully destroyed cluster
172.18.0.10: Successfully destroyed cluster

Sending 'pacemaker_remote authkey' to '172.18.0.2', '172.18.0.10'
172.18.0.10: successful distribution of the file 'pacemaker_remote authkey'
172.18.0.2: successful distribution of the file 'pacemaker_remote authkey'
Sending cluster config files to the nodes...
172.18.0.2: Succeeded
172.18.0.10: Succeeded

Starting cluster on nodes: 172.18.0.2, 172.18.0.10...
172.18.0.2: Starting Cluster (corosync)...
172.18.0.10: Starting Cluster (corosync)...
172.18.0.2: Starting Cluster (pacemaker)...
172.18.0.10: Starting Cluster (pacemaker)...

Synchronizing pcsd certificates on nodes 172.18.0.2, 172.18.0.10...
172.18.0.10: Success
172.18.0.2: Success
Restarting pcsd on the nodes in order to reload the certificates...
172.18.0.10: Success
172.18.0.2: Success

# Enable service when booting system:
# Check status of cluster:

[root@82b2d4e1b67e /]# pcs cluster enable --all
172.18.0.2: Cluster Enabled
172.18.0.10: Cluster Enabled
[root@82b2d4e1b67e /]# pcs cluster status
Cluster Status:
 Stack: corosync
 Current DC: 82b2d4e1b67e (version 1.1.19-8.el7_6.2-c3c624ea3d) - partition with quorum
 Last updated: Thu Jan 17 14:38:46 2019
 Last change: Thu Jan 17 14:38:33 2019 by hacluster via crmd on 82b2d4e1b67e
 2 nodes configured
 0 resources configured

PCSD Status:
  3139fd0eb11e (172.18.0.10): Online
  82b2d4e1b67e (172.18.0.2): Online

### How to manage or check this cluster-A-test in the Admin Web Interface: https://localhost:2224/manage#
# Click on +Add Existing
# Type the IP of the manager: 172.18.0.2


