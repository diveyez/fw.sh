#!/bin/bash
# IPTables DNSBL + Rule Script
###############
##### variables
#############################################
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
#############################################
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
#############################################
                clear
                bash ./release.version
                sleep 1
                echo "Getting lists..."
                progress=${_start}
                status="Starting"
                ProgressBar ${progress} "${status}"
                sleep 0.1
                ((progress=progress+20))
                if [ $USER != 'root' ]
                then
                   echo
                   echo "Error: You are running as $USER - please run as root"
                   exit
                fi
                status="GOT ROOT?"
                ProgressBar ${progress} "${status}"
#############################################
#PACKAGES#####
                    apt-get update && apt-get install tcpdump screen net-tools curl wget -y
                    sleep 0.1
#############################################
# FOR FLUSHING IPTABLES
                    # iptables -F
# Grab Lists And Sort For Addition Of Unique Entries Only
                    status="Obtaining list from : rules.emergingthreats.net"
                    ProgressBar ${progress} "${status}"
                    ((progress=progress+20))
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
                    cat fw-custom-bans.blocked | sort |uniq > /tmp/tmpfwlist
                    ((progress=progress+29))
                    status=" done"
                    ProgressBar ${progress} "${status}"
# End Of List Grabbing
                    echo "Lists Obtained: Moving To Rules."
                    sleep 1
                    clear
                    progress=0
                    sleep 2
                    echo "Starting rules..."
                    ProgressBar ${progress} "${status}"
# Allow all loopback (lo0) traffic and reject traffic
# to localhost that does not originate from lo0.
                    iptables -A INPUT -i lo -j ACCEPT >> /dev/null 2>&1
                    iptables -A INPUT ! -i lo -s 127.0.0.0/8 -j REJECT >> /dev/null 2>&1
# Allow inbound traffic from established connections.
# This includes ICMP error returns.
                    iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT >>/dev/null 2>&1
# Reject/Accept ping DOS ATTACK PREVENTION
                    iptables -A INPUT -p icmp -m state --state NEW --icmp-type 8 -j REJECT --reject-with icmp-net-unreachable >> /dev/null 2>&1
                    iptables -A INPUT -p tcp --dport 80 -m limit --limit 500/minute --limit-burst 250 -j ACCEPT >> /dev/null 2>&1
                    iptables -A INPUT -p tcp --dport 443 -m limit --limit 500/minute --limit-burst 250 -j ACCEPT >> /dev/null 2>&1
                    ProgressBar ${progress} "DOS ICMP/HTTP/HTTPS PREVENTION"
                    sleep 1.5
# DdoS Watch ###############
                    screen -dmS dump-dos ./dump-dos.sh
# Are You Afraid Of DDOS bad?
                    # screen -dmS dos ./ddos.sh
# Log what was incoming but denied (optional but useful).
                    iptables -A INPUT -m limit --limit 5/min -j LOG --log-prefix "iptables_INPUT_denied: " --log-level 7 >> /dev/null 2>&1
# Log any traffic that was sent to you
# for forwarding (optional but useful).
                    iptables -A FORWARD -m limit --limit 5/min -j LOG --log-prefix "iptables_FORWARD_denied: " --log-level 7 >> /dev/null 2>&1
                    ProgressBar ${progress} "LO Allowane + ICMP/Dyns/DNSAMP/DdoS Rejections - Forwarding Rejection + Logging"
                    sleep 1.5
#openVPN ###############
                #sh ./openvpn-rules.sh >> /dev/null 2>&1
# UNCOMMENT THE LINE IF YOU NEED OPENVPN RULES

# For SSH Port ( Default 22, Customize At Your Leisure):
                    ProgressBar ${progress} "SSH Allowance"
                    ((progress=progress+20))
                                                            sleep 1.5
                    echo "$SSH_CLIENT"
                    echo "Above should be your ssh ip client port and server port (external), this is the number we need."
                    read -p "What Port is SSH on: (default 22)" sshport
                    iptables -A INPUT -p tcp --dport $sshport -m state --state NEW,ESTABLISHED -j ACCEPT >> /dev/null 2>&1
                    iptables -A OUTPUT -p tcp --sport $sshport -m state --state NEW,ESTABLISHED -j ACCEPT >> /dev/null 2>&1
                    sleep 1.5
                    ((progress=progress+40))
                    ProgressBar ${progress} "HTTP/HTTPS 'NGINX/APACHE/LIGHTTPD NEEDS THIS'"
                    sleep 1.5
                    clear
# Allow SSH tunnel ###############
#iptables -A INPUT -i lo -j ACCEPT >> /dev/null 2>&1
#iptables -A OUTPUT -o lo -j ACCEPT >> /dev/null 2>&1
#iptables -A INPUT -i $internal_interface -j ACCEPT >> /dev/null 2>&1
#iptables -A OUTPUT -o $internal_interface -j ACCEPT >> /dev/null 2>&1
# Allow HTTP and HTTPS connections from anywhere
                    # (the normal ports for web servers).
                    iptables -A INPUT -p tcp --dport 80 -m state --state NEW -j ACCEPT >> /dev/null 2>&1
                    iptables -A INPUT -p tcp --dport 443 -m state --state NEW -j ACCEPT >> /dev/null 2>&1
                    iptables -A OUTPUT -p tcp --sport 80 -m state --state NEW -j ACCEPT >> /dev/null 2>&1
                    iptables -A OUTPUT -p tcp --sport 443 -m state --state NEW -j ACCEPT >> /dev/null 2>&1
                    sleep 1.5
# DDOS PROTECTION DISENGAGED | UNCOMMENT AND EXECUTE TO ENGAGE
# ./dofw-ddos.sh
# Strict Blacklisting ###############
                    cat fw-list.blocked fw-list2.blocked fw-custom-bans.blocked | sort | uniq > /tmp/fw-list-merged-nodups.blocked | echo "Blocked IP's"
                    _end=`cat /tmp/fw-list-merged-nodups.blocked | wc -l`
                    counter=1
                    while read line; do iptables -A INPUT -s $line -j REJECT --reject-with icmp-net-unreachable >> /dev/null 2>&1 ; ProgressBar ${counter} "${line}" ; ((counter++)); done < /tmp/fw-list-merged-nodups.blocked
                    ProgressBar ${counter} "done"
                    rm /tmp/fw-list-merged-nodups.blocked >> /dev/null 2>&1
                    rm fw-list.blocked >> /dev/null 2>&1
                    rm fw-list2.blocked >> /dev/null 2>&1
# GEO BLOCKING ###############
                    ProgressBar ${progress} "The screen will look frozen while we geo block, this is to prevent application breaklines."
#                    screen -d -m -S geo-block bash geo-block.sh >> /dev/null 2>&1
#  REJECT ALL OTHER ###############
                    ProgressBar ${progress} "ADDING A REJECT ALL OTHER RULE"
                    iptables -A INPUT -j REJECT >> /dev/null 2>&1
                    iptables -A OUTPUT -j ACCEPT >> /dev/null 2>&1
                    sleep 1.5
                    ((progress=progress+20))
                    progress=100
                    status=" done"
                    ProgressBar ${progress} "${status}"
                    sleep 1
# Closing Echoes ###############
printf '\nFirewall Is Finished Updating. Please Run at least, bl.sh everyday, multiple times a day to have up to date known threat management. A Crontab is the most popular choice.\n'
printf '\nThe DdoS Attack Capture/Dumps will be located at /tmp/dump/* \n'
bash release.version
