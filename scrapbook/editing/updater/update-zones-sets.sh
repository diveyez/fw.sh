#!/bin/bash
# Get Zones
wget http://www.ipdeny.com/ipv6/ipaddresses/blocks/ipv6-all-zones.tar.gz && mv ipv6-all-zones.tar.gz zones/zone-tarballs/ipv6-all-zones.tar.gz && tar -C zones/ipv6-all-zones -zxvf ipv6-all-zones.tar.gz
wget http://www.ipdeny.com/ipblocks/data/countries/all-zones.tar.gz && mv all-zones.tar.gz zones/zone-tarballs/all-zones.tar.gz && tar -C zones/ipv4-all-zones -zxvf all-zones.tar.gz
# Cat to File
# IPV4
ls zones/ipv4-all-zones | grep *.zone > zones/ipv4-zone.list
cat  | sort | uniq > /tmp/fw-zones-ipv4merged-nodups.loaded | _end=`cat /tmp/fw-zones-ipv4merged-nodups.loaded | wc -l`
# IPV6
ls zones/ipv6-all-zones | grep *.zone > zones/ipv6-zone.list
cat  | sort | uniq > /tmp/fw-zones-ipv6merged-nodups.loaded | _end=`cat /tmp/fw-zones-ipv6merged-nodups.loaded | wc -l`
