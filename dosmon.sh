#!/bin/bash
if [ $USER != 'root' ]
then
   echo
   echo "Error: You are running as $USER - please run as root"
   exit
fi
apt-get update && apt-get install tcpdump screen net-tools curl wget -y
status="GOT ROOT?"
cd /root/
mkdir fw.sh
cd fw.sh
clear
echo "Getting IPTables on lockdown."
wget https://raw.githubusercontent.com/diveyez/fw.sh/master/bl.sh
wget https://raw.githubusercontent.com/diveyez/fw.sh/master/fw-custom-bans.blocked
wget https://raw.githubusercontent.com/diveyez/fw.sh/master/ddos.sh
wget https://raw.githubusercontent.com/diveyez/fw.sh/master/release.version
clear
./ddos.sh
screen -dmS blacklisting ./bl.sh
