# fw.sh - Network Defense BASH scripts for IPTABLES


This script set grabs malicious and spam listed internet protocol 4 addresses, and sets rules to ensure that the large malicious networks and compromised hosts are not able to directly access your machine to scan, identify vulnerabilities and exploit your linux servers.


A few key points to note when dealing with this script bundle.

**This Script Bundle Alone Is Not A Full Defense Against Attacks** you will need to incorporate this with other tools in order to accomplish a fully secure system or network.

**Fair Warning**, it is not safe to operate networked infrastructure on the standard ports if any kind of control could be obtained in the current age we live in. In other words, change your SSH port. Change API ports from the default. 

**2022 Best Practice, Disable PAM Authentication unless protected with key handshakes or Two Factor Authentication. Breaches occur from AI exploit development frameworks everyday. THOSE HOSTS ARE IN THE LISTS USED WITHIN THIS FIREWALLING SCRIPT BUNDLE.**
Without Fail2Ban you would be at the mercy of password dictionary attacks and worse, social engineering could lead to becoming compromised and passwords could be used to gain access.


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

##### For Tips Using IPTables Check The Following File

iptables-README.md