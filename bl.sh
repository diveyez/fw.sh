#!/bin/bash
#############################################
          _start=1
          _end=100
          _lastsize=0
          _currentm=""
          _cursize=0
          _lastm=""
          _lastsize=0
          _fillspaces=0
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
### main script
#############################################
            clear
            bash ./release.version
            sleep 1
            echo "Getting lists..."
            echo "We do all the hardwork for you!"
            progress=${_start}
            status="Starting"
            ProgressBar ${progress} "${status}"
            sleep 0.1
            ((progress=progress+20))
#############################################
############### MEET DEPENDENCIES AND UPDATES
            if [ $USER != 'root' ]
            then
               echo
               echo "Error: You are running as $USER - please run as root"
               exit
            fi
            apt-get update && apt-get install tcpdump screen -y
            status="GOT ROOT?"
            ProgressBar ${progress} "${status}"
            sleep 0.1
            ((progress=progress+20))
# Grab Lists And Sort For Addition Of Unique Entries Only
            status="Obtaining list from : rules.emergingthreats.net"
            ProgressBar ${progress} "${status}"
            sleep 1
            curl -sS https://rules.emergingthreats.net/blockrules/compromised-ips.txt >> fw-list.blocked
            cat fw-list.blocked | sort | uniq > /tmp/tmpfwlist
            mv /tmp/tmpfwlist fw-list.blocked
            ((progress=progress+30))
            status="Obtaining list from : lists.blocklist.de"
            ProgressBar ${progress} "${status}"
            sleep 1
            curl -sS https://lists.blocklist.de/lists/all.txt >> fw-list2.blocked
            cat fw-list2.blocked | sort | uniq > /tmp/tmpfwlist
            mv /tmp/tmpfwlist fw-list2.blocked
            cat fw-custom-bans.blocked | sort |uniq > /tmp/tmpfwlist
            ((progress=progress+29))
            status=" done"
            ProgressBar ${progress} "${status}"
# End Of List Grabbing ##############################
            echo "Lists Obtained: Moving To Rules."
            sleep 1
            progress=0
            sleep 1
            echo "Rules Set: Adding Blocked Addresses."
            clear
            echo "Take a break, let this run for a while."
            echo "Creating Rules for: ALL KNOWN MALICIOUS HOSTS"
            cat fw-list.blocked fw-list2.blocked fw-custom-bans.blocked | sort | uniq > /tmp/fw-list-merged-nodups.blocked
            _end=`cat /tmp/fw-list-merged-nodups.blocked | wc -l`
            counter=1
            while read line; do iptables -A INPUT -s $line -j REJECT --reject-with icmp-net-unreachable >> /dev/null 2>&1 ; ProgressBar ${counter} "${line}" ; ((counter++)); done < /tmp/fw-list-merged-nodups.blocked
            ProgressBar ${counter} "done"
            rm /tmp/fw-list-merged-nodups.blocked >> /dev/null 2>&1
            rm fw-list.blocked >> /dev/null 2>&1
            rm fw-list2.blocked >> /dev/null 2>&1
            sleep 2.5
            clear
########################################################
printf '\nFirewall Is Finished Updating. Please Run This Script Every Day for Best Results.\n'
printf '\nThe DdoS Attack Capture/Dumps will be located at /tmp/dump/* \n'
printf '\nIt would be wise to ln -s the dir to the repository directories and create your own blacklist as I have with fw-custom-blacklist so that your own attackers are in the next rule set.'
printf '\n(fw.sh) Is A Project Of GitHub.com/diveyez If You Got It Somewhere Else, Question Everything =)\n'
