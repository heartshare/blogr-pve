# Linux LXC container setup
I have used standard Debian 8 base images for the LXC containers.

#### First, To create a new LXC container
In proxmox perform the following steps to create a new container.
* Create a Debian 8 LXC container.
* I have used the following naming convention
for the node roles, the puppet scripts use this to map the role to the container.
    * app-[n] for the Node.js Express backend servers.
    * db-1 for the primary database.
    * db-2 for the standby database.
    * front-[n] for nginx reverse proxy servers that serve content in the dmz infront of the app-servers.
    * router-1 for the primary firewall.
    * router-2 for the standby firewall.
    * ci-[n] for Jenkins continuous integration server.
    * log-[n] for the Elasticsearch and Kibana backend for centralized logging.
    * login-[n] for the jump/login server that provide access to ssh on the other boxes.

* Assign correct virtual network device depending on which subnet you want.
* Assign vlan tag to network device. [See Network configuration](doc/setup_network.md)
* Assign 1gb of ram and swap
* Assign 1gb of storage space. This is the bare minimum that works for most container, increase to 2gb or 4gb where needed.

#### Then
##### Perform manual steps that must be performed on each virtual container.
Log into the login-1 server, 
Copy the eyaml private and public keys to /etc/puppetlabs/keys to be able to decrypt values with *scp* command to the new LXC Container.

Log into the new LXC container and run the following commands in the console.
```bash
$ apt-get udpate
$ apt-get upgrade
$ apt-get install git ca-certificates
$ git clone https://github.com/dniel/blogr-pve /opt/pve
$ cd /opt/pve
$ ./apply.sh
```
depending on the hostname a role in the puppet script will be selected
for the container and executed.
