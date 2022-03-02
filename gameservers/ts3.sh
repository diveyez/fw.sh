##### TEAMSPEAK 3 SERVER RULES
sudo iptables -A INPUT -p udp --dport 9987 -j ACCEPT
sudo iptables -A INPUT -p tcp --sport 9987 -j ACCEPT
sudo iptables -A INPUT -p udp --dport 30033 -j ACCEPT
sudo iptables -A INPUT -p tcp --sport 30033 -j ACCEPT
sudo iptables -A INPUT -p udp --dport 10011 -j ACCEPT
sudo iptables -A INPUT -p tcp --sport 10011 -j ACCEPT
