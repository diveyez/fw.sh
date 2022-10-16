##### FiveM Server Rules
sudo iptables -A INPUT -p udp --dport 30120 -j ACCEPT
sudo iptables -A INPUT -p tcp --sport 30120 -j ACCEPT
sudo iptables -A INPUT -p tcp --sport 40120 -j ACCEPT