# Create subnet:

docker network create --subnet=172.18.0.0/16 mydockernet


# The following command runs a container using image id 5b125ebe8e6b
# -d background execution
# --privileged
# -v for binding several options for running the systemd for pcs : socket, binaries, and so on
# --name (of container)
# subnet and ip are defined

israel@W9980173 ~/docker/pacemaker_cluster $ docker run -d --privileged -v /sys/fs/cgroup:/sys/fs/cgroup -v /etc/localtime:/etc/localtime:ro -v /run/docker.sock:/run/docker.sock -v /usr/bin/docker:/usr/bin/docker:ro --ip 172.18.0.10 --net mydockernet --name pcs_cluster_node2 5b125ebe8e6b
3139fd0eb11e3b42f93285584cab6d2d9fd997071c4c401f9661f95cf0e6fe39


israel@W9980173 ~/docker/pacemaker_cluster $ docker ps -a
CONTAINER ID        IMAGE                     COMMAND                  CREATED             STATUS                         PORTS                     NAMES
3139fd0eb11e        5b125ebe8e6b              "/usr/lib/systemd/..."   4 minutes ago       Up 4 minutes                   2224/tcp                  pcs_cluster_node2
204902d18067        5b125ebe8e6b              "/usr/lib/systemd/..."   About an hour ago   Up About an hour                                         pcs_cluster_manager


israel@W9980173 ~/docker/pacemaker_cluster $ docker network inspect mydockernet 
[
    {
        "Name": "mydockernet",
        "Id": "f0b864d1601f992872ed0fdffcfa20d5510f66039bda4d346fb7c812c6d3f26d",
        "Created": "2019-01-16T17:15:36.565283979+01:00",
        "Scope": "local",
        "Driver": "bridge",
        "EnableIPv6": false,
        "IPAM": {
            "Driver": "default",
            "Options": {},
            "Config": [
                {
                    "Subnet": "172.18.0.0/16"
                }
            ]
        },
        "Internal": false,
        "Attachable": false,
        "Containers": {
            "3139fd0eb11e3b42f93285584cab6d2d9fd997071c4c401f9661f95cf0e6fe39": {
                "Name": "pcs_cluster_node2",
                "EndpointID": "9c38c07b65309f3d2e9af48bc9fd69fb13304d4e60382ef65919ea1df3a90193",
                "MacAddress": "02:42:ac:12:00:0a",
                "IPv4Address": "172.18.0.10/16",
                "IPv6Address": ""
            }
        },
        "Options": {},
        "Labels": {}
    }
]

