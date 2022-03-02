# Kerbal Space Program Multiplayer Server
iptables -A INPUT -p udp --dport 6702 -m state --state NEW -j ACCEPT >> /dev/null 2>&1
iptables -A OUTPUT -p udp --sport 6702 -m state --state NEW -j ACCEPT >> /dev/null 2>&1
iptables -A INPUT -p udp --dport 8080 -m state --state NEW -j ACCEPT >> /dev/null 2>&1
iptables -A OUTPUT -p udp --sport 8080 -m state --state NEW -j ACCEPT >> /dev/null 2>&1
iptables -A INPUT -p udp --dport 9001 -m state --state NEW -j ACCEPT >> /dev/null 2>&1
iptables -A OUTPUT -p udp --sport 9001 -m state --state NEW -j ACCEPT >> /dev/null 2>&1
iptables -A INPUT -p tcp --dport 6702 -m state --state NEW -j ACCEPT >> /dev/null 2>&1
iptables -A OUTPUT -p tcp --sport 6702 -m state --state NEW -j ACCEPT >> /dev/null 2>&1
iptables -A INPUT -p tcp --dport 8080 -m state --state NEW -j ACCEPT >> /dev/null 2>&1
iptables -A OUTPUT -p tcp --sport 8080 -m state --state NEW -j ACCEPT >> /dev/null 2>&1
iptables -A INPUT -p tcp --dport 9001 -m state --state NEW -j ACCEPT >> /dev/null 2>&1
iptables -A OUTPUT -p tcp --sport 9001 -m state --state NEW -j ACCEPT >> /dev/null 2>&1
