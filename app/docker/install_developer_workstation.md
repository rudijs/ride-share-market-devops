## Install Developer Workstation

    sudo apt-get install lxc-docker-1.5.0 bridge-utils

## VPN (WIP)

Creating a custom bridge for the Docker daemon to use (conflicting when Astrill VPN in use).

[https://docs.docker.com/articles/networking/#bridge-building](https://docs.docker.com/articles/networking/#bridge-building)

    # Stopping Docker and removing docker0
    sudo service docker stop
    sudo ip link set dev docker0 down
    sudo brctl delbr docker0
    sudo iptables -t nat -F POSTROUTING

Add to */etc/network/interfaces*

    auto bridge0
    iface bridge0 inet manual
    pre-up brctl addbr bridge0
    pre-up ip addr add 192.168.5.1/24 brd + dev bridge0
    post-down ip link set dev bridge0 down
    post-down brctl delbr bridge0
    post-down iptables -t nat -F POSTROUTING

Update */etc/default/docker*

    DOCKER_OPTS="--bridge bridge0 --insecure-registry 192.168.33.10:5000"
