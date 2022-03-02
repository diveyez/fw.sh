#!/bin/bash
interface=eth0
dumpdir=/var/log/dos-logs
mkdir /var/log/dos-logs
while /bin/true; do
  pkt_old=`grep $interface: /proc/net/dev | cut -d :  -f2 | awk '{ print $2 }'`
  sleep 1
  pkt_new=`grep $interface: /proc/net/dev | cut -d :  -f2 | awk '{ print $2 }'`
  pkt=$(( $pkt_new - $pkt_old ))
  echo -ne "\r$pkt packets/s\033[0K"
  if [ $pkt -gt 10000 ]; then
    echo "\nPossible DDoS - dumping.."
    tcpdump -n -s0 -c 10000 -w $dumpdir/dump.`date +"%Y%m%d-%H%M%S"`.cap
    echo "Dump complete, going to sleep for 5 minutes."
    sleep 300
  fi
done
