# fw.sh - BASH scripts for IPTABLES

This script set grabs malicious and spam listed internet protocol 4 addresses, and sets rules to ensure that the large malicious networks and compromised hosts are not able to directly access your machine to scan, identify vulnerabilities and exploit your linux servers.

- Fair Warning, it is not safe to operate networked infrastructure on the standard ports if any kind of control could be obtained. In other words, change your SSH port. Change API ports from the default. 

**The recent changes in the IT world taught me one thing, the hacking is now automated and it is scanning specific ports and identifiable pathways for further exploitation.**


For best results, use this with Fail2Ban, Snort, and PortSentry as well. 
You can configure those to output the IP addresses into a file, and then use that information with the blacklist scripting to ensure your own personal pests are dealth with swiftly.
You will then have a nice set of tools to stop attacks at the network level if used on a nodebalancer, or a gateway machine.

- iptables is required for this script
- screen & tcpdump are required for this script


## DISCLAIMER: _Do not try to operate this unless you know what you are doing. I am not responsible for you locking yourself out of your own systems._

### blacklisting of threats usage: `git clone https://github.com/diveyez/fw.sh && cd fw.sh && screen -dmS blacklist-firewall sudo bash bl.sh && screen -x blacklist-firewall`

#### DO NOT RUN THE DDOS SCRIPTS ON REMOTE MACHINES DUE TO RISK OF INABILITY TO RECONNECT! Emergency Usage Only!

- USE 'screen -x dump-dos' to view attacks in real time, then add them to fw-custom-bans.blocked and run dofw.sh again.

  ### HostAP

- IF you are using this for HostAP, change `iptables -A INPUT -j DROP >> /dev/null 2>&1`
- in dofw.sh to `iptables -A INPUT -j ACCEPT >> /dev/null 2>&1`

![](https://i2.wp.com/gozenhost.com/news/wp-content/uploads/2017/12/iptables.jpg?fit=800%2C393&ssl=1) ![](https://2.bp.blogspot.com/-C8uqt2a5ee8/V3Y0R_MeB5I/AAAAAAAAKNY/KrzwVxUu6UsrOlU4w776R891fAkc-6QEwCLcB/s1600/Bash-Final.jpg)

#### ISO CODES (FOR GEO BLOCKING)

/iso/iso.list

<http://www.ipdeny.com/ipblocks/data/countries>

## How to block ports with IPTABLES

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
