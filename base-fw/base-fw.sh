#!/bin/bash
# This is my version of the firewall script dofw.sh
# this is probably not the one you are looking for
###############
##### variables
###############
_start=1
_end=100
_lastsize=0
_currentm=""
_cursize=0
_lastm=""
_lastsize=0
_fillspaces=0
##############
#### Variables
##############
function ProgressBar {
    let _progress=(${1}*100/${_end}*100/100)
    let _done=(${_progress}*4/10)
    let _left=40-$_done
    _fill=$(printf "%${_done}s")
    _empty=$(printf "%${_left}s")
    _lastm=${_currentm}
    _currentm=$2
    _lastsize=${#_lastm}
    _cursize=${#_currentm}
    let _sizediff=${_cursize}-${_lastsize}
    _fillspaces=$(printf "%${_sizediff}s")
    printf "\rProgress : [${_fill// /#}${_empty// /-}] ${_progress}%% : ${_currentm}${_fillspaces// / }"
}
###############
### main script
###############
###############
sleep 1
echo "Getting lists..."
echo ""
# display progress bar since we are about to start
progress=${_start}
status="Starting"
ProgressBar ${progress} "${status}"
sleep 0.1
((progress=progress+20))

## Check for being ran as root, if not, die
if [ $USER != 'root' ]
then
   echo
   echo "Error: You are running as $USER - please run as root"
   exit
fi

status="GOT ROOT?"
ProgressBar ${progress} "${status}"
sleep 0.1
((progress=progress+20))
# Grab Lists And Sort For Addition Of Unique Entries Only
status="Obtaining list from : rules.emergingthreats.net"
ProgressBar ${progress} "${status}"
sleep 1
curl -sS https://rules.emergingthreats.net/blockrules/compromised-ips.txt >> fw-list.blocked
# get rid of duplicates
cat fw-list.blocked | sort | uniq > /tmp/tmpfwlist
mv /tmp/tmpfwlist fw-list.blocked
((progress=progress+30))
status="Obtaining list from : lists.blocklist.de"
ProgressBar ${progress} "${status}"
sleep 1
curl -sS https://lists.blocklist.de/lists/all.txt >> fw-list2.blocked
# get rid of duplicates
cat fw-list2.blocked | sort | uniq > /tmp/tmpfwlist
mv /tmp/tmpfwlist fw-list2.blocked
cat /home/diveyez/fw.sh/fw-custom-bans.blocked | sort |uniq > /tmp/tmpfwlist
((progress=progress+29))
status=" done"
ProgressBar ${progress} "${status}"
# End Of List Grabbing
echo "Lists Obtained: Moving To Rules."
sleep 1
# reset progress bar
progress=0
sleep 2
echo "Starting rules..."
# Display progress bar
ProgressBar ${progress} "${status}"
# FLUSHING IPTABLES
iptables -F
# Uncomment above to clear rules, if for any reason you need to
# Allow all loopback (lo0) traffic and reject traffic
# to localhost that does not originate from lo0.
iptables -A INPUT -i lo -j ACCEPT >> /dev/null 2>&1
iptables -A INPUT ! -i lo -s 127.0.0.0/8 -j REJECT >> /dev/null 2>&1
# Allow inbound traffic from established connections.
# This includes ICMP error returns.
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT >>/dev/null 2>&1
# Reject/Accept ping DOS ATTACK PREVENTION
iptables -A INPUT -p icmp -m state --state NEW --icmp-type 8 -j REJECT --reject-with icmp-net-unreachable >> /dev/null 2>&1
iptables -A INPUT -p tcp --dport 80 -m limit --limit 50/minute --limit-burst 250 -j ACCEPT >> /dev/null 2>&1
iptables -A INPUT -p tcp --dport 443 -m limit --limit 50/minute --limit-burst 250 -j ACCEPT >> /dev/null 2>&1
ProgressBar ${progress} "DOS ICMP/HTTP/HTTPS PREVENTION"
sleep 1.5
# DdoS Watch
#screen -dmS dump-dos ./dump-dos.sh
# Will Fail If You Don't Have Screen Installed
# Log what was incoming but denied (optional but useful).
iptables -A INPUT -m limit --limit 5/min -j LOG --log-prefix "iptables_INPUT_denied: " --log-level 7 >> /dev/null 2>&1
# Log any traffic that was sent to you
# for forwarding (optional but useful).
iptables -A FORWARD -m limit --limit 5/min -j LOG --log-prefix "iptables_FORWARD_denied: " --log-level 7 >> /dev/null 2>&1
# Reject all traffic forwarding.
# iptables -A FORWARD -j REJECT >> /dev/null 2>&1
ProgressBar ${progress} "LO Allowance + ICMP/Dyns/DNSAMP/DdoS Rejections - Forwarding Rejection + Logging"
sleep 1.5
#sleep 0.5
((progress=progress+20))
# For SSH Port ( Default 22, Customize At Your Leisure):
ProgressBar ${progress} "SSH Allowance"
sleep 1.5
# Allow SSH connections. Default is 22 Customize at your own risk
# Allow SSH tunnel
iptables -A INPUT -p tcp --dport 420 -m state --state NEW,ESTABLISHED -j ACCEPT >> /dev/null 2>&1
iptables -A OUTPUT -p tcp --sport 420 -m state --state NEW,ESTABLISHED -j ACCEPT >> /dev/null 2>&1
#iptables -A INPUT -i lo -j ACCEPT >> /dev/null 2>&1
#iptables -A OUTPUT -o lo -j ACCEPT >> /dev/null 2>&1
#iptables -A INPUT -i $internal_interface -j ACCEPT >> /dev/null 2>&1
#iptables -A OUTPUT -o $internal_interface -j ACCEPT >> /dev/null 2>&1
((progress=progress+20))
((progress=progress+20))
# For Web Traffic
ProgressBar ${progress} "HTTP/HTTPS 'NGINX NEEDS THIS'"
sleep 1.5
# Allow HTTP and HTTPS connections from anywhere
# (the normal ports for web servers).
iptables -A INPUT -p tcp --dport 80 -m state --state NEW -j ACCEPT >> /dev/null 2>&1
iptables -A INPUT -p tcp --dport 443 -m state --state NEW -j ACCEPT >> /dev/null 2>&1
iptables -A OUTPUT -p tcp --sport 80 -m state --state NEW -j ACCEPT >> /dev/null 2>&1
iptables -A OUTPUT -p tcp --sport 443 -m state --state NEW -j ACCEPT >> /dev/null 2>&1
######## TEAMSPEAK 3 SERVER RULES
iptables -A INPUT -p udp --dport 9987 -m state --state NEW,ESTABLISHED -j ACCEPT >> /dev/null 2>&1
iptables -A INPUT -p tcp --sport 9987 -m state --state NEW,ESTABLISHED -j ACCEPT >> /dev/null 2>&1
iptables -A INPUT -p udp --dport 30033 -m state --state NEW,ESTABLISHED -j ACCEPT >> /dev/null 2>&1
iptables -A INPUT -p tcp --sport 30033 -m state --state NEW,ESTABLISHED -j ACCEPT >> /dev/null 2>&1
iptables -A INPUT -p udp --dport 10011 -m state --state NEW,ESTABLISHED -j ACCEPT >> /dev/null 2>&1
iptables -A INPUT -p tcp --sport 10011 -m state --state NEW,ESTABLISHED -j ACCEPT >> /dev/null 2>&1
# Kerbal Space Program Multiplayer Server
iptables -A INPUT -p udp --dport 6702 -m state --state NEW,ESTABLISHED -j ACCEPT >> /dev/null 2>&1
iptables -A OUTPUT -p udp --sport 6702 -m state --state NEW,ESTABLISHED -j ACCEPT >> /dev/null 2>&1
iptables -A INPUT -p udp --dport 8080 -m state --state NEW,ESTABLISHED -j ACCEPT >> /dev/null 2>&1
iptables -A OUTPUT -p udp --sport 8080 -m state --state NEW,ESTABLISHED -j ACCEPT >> /dev/null 2>&1
iptables -A INPUT -p udp --dport 9001 -m state --state NEW,ESTABLISHED -j ACCEPT >> /dev/null 2>&1
iptables -A OUTPUT -p udp --sport 9001 -m state --state NEW,ESTABLISHED -j ACCEPT >> /dev/null 2>&1
iptables -A INPUT -p tcp --dport 6702 -m state --state NEW,ESTABLISHED -j ACCEPT >> /dev/null 2>&1
iptables -A OUTPUT -p tcp --sport 6702 -m state --state NEW,ESTABLISHED -j ACCEPT >> /dev/null 2>&1
iptables -A INPUT -p tcp --dport 8080 -m state --state NEW,ESTABLISHED -j ACCEPT >> /dev/null 2>&1
iptables -A OUTPUT -p tcp --sport 8080 -m state --state NEW,ESTABLISHED -j ACCEPT >> /dev/null 2>&1
iptables -A INPUT -p tcp --dport 9001 -m state --state NEW,ESTABLISHED -j ACCEPT >> /dev/null 2>&1
iptables -A OUTPUT -p tcp --sport 9001 -m state --state NEW,ESTABLISHED -j ACCEPT >> /dev/null 2>&1
######################################################################################
# Reject all other inbound.
iptables -A INPUT -j REJECT >> /dev/null 2>&1
iptables -A OUTPUT -j ACCEPT >> /dev/null 2>&1
ProgressBar ${progress} "ADDING A REJECT ALL OTHER RULE"
sleep 1.5
((progress=progress+20))
# finish progress bar
progress=100
status=" done"
ProgressBar ${progress} "${status}"
ProgressBar ${progress} "Done Adding Main Rules, Moving On..."
sleep 1

# End Custom
# Rules
echo "Rules Set: Adding Blocked Addresses."
cat /home/diveyez/fw.sh/zones/br.zone /home/diveyez/fw.sh/fw-list.blocked /home/diveyez/fw.sh/fw-list2.blocked /home/diveyez/fw.sh/fw-custom-bans.blocked | sort | uniq > /tmp/fw-list-merged-nodups.blocked
# set the _end for our progress bar to the amount of lines in our mergedlist
_end=`cat /tmp/fw-list-merged-nodups.blocked | wc -l`
counter=1
while read line; do iptables -A INPUT -s $line -j REJECT --reject-with icmp-net-unreachable >> /dev/null 2>&1 ; ProgressBar ${counter} "${line}" ; ((counter++)); done < /tmp/fw-list-merged-nodups.blocked
ProgressBar ${counter} "done"
rm /tmp/fw-list-merged-nodups.blocked >> /dev/null 2>&1
rm fw-list.blocked >> /dev/null 2>&1
rm fw-list2.blocked >> /dev/null 2>&1
sleep 2.5
printf '\nFinished!\n'
printf '\nFirewall Is Finished Updating. Please Run This Script Every 7 Days.\n'
