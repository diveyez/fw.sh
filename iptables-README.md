# How to block ports with IPTABLES

Block Incoming Port

The syntax to block an incoming port using iptables is as follows. This applies to all the interfaces globally.

# iptables -A INPUT -p tcp --destination-port

<port number=""> -j DROP</port>

To block the port only on a specific interface use the -i option.

# iptables -A INPUT -i

<interface name=""> -p tcp --destination-port <port number=""> -j DROP</port></interface>

To block port only for given IP or Subnet use the -s option to specify the subnet or IP addess.

# iptables -A INPUT -i

<interface name=""> -p tcp --destination-port <port number=""> -s <ip address=""> -j DROP</ip></port></interface>

# iptables -A INPUT -i

<interface name=""> -p tcp --destination-port <port number=""> -s <ip subnet=""> -j DROP</ip></port></interface>

For example:

To block port 21 (to block FTP), use the command below:

# iptables -A INPUT -p tcp --destination-port 21 -j DROP

Save the iptables for rules to be persistent across reboots.

# service iptables save

To block port 21 for a specific IP address (e.g. 10.10.10.10) on interface eth1 use the command :

# iptables -A INPUT -p tcp -i eth1 -s ! 10.10.10.10 --destination-port 21 -j DROP

Save the iptables for rules to be persistent across reboots.

# service iptables save

Block Outgoing Port

The syntax to block an outgoing port using iptables is as follows. This applies to all the interfaces globally.

# iptables -A OUTPUT -p tcp --destination-port

<port number=""> -j DROP</port>

To block the port only on a specific interface use the -i option.

# iptables -A OUTPUT -i

<interface name=""> -p tcp --destination-port <port number=""> -j DROP</port></interface>

To block port only for given IP or Subnet use the -s option to specify the subnet or IP addess.

# iptables -A OUTPUT -i

<interface name=""> -p tcp --destination-port <port number=""> -s <ip address=""> -j DROP</ip></port></interface>

# iptables -A OUTPUT -i

<interface name=""> -p tcp --destination-port <port number=""> -s <ip subnet=""> -j DROP</ip></port></interface>

For example:

To block outgoing port # 25, use the below command.

# iptables -A OUTPUT -p tcp --destination-port 25 -j DROP

Save the iptables for rules to be persistent across reboots.

# service iptables save

To block port # 25 only for ip address 10.10.10.10 use the command :

# iptables -A OUTPUT -p tcp -d 10.10.10.10 --destination-port 25 -j DROP

Save the iptables for rules to be persistent across reboots.

# service iptables save
