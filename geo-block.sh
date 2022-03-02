#!/bin/bash
# You may find zones provided in the ~/fw.sh/zones folder within this project
# Current ISO's are ROW (Rest of World) which is basically every non english speaking country on earth.
ISO="aq ai ao ad dz al ax af bn io br bv bw ba bo bt bj bz be by bb bd bh az at am ar gr gi gh de ge gm ga tf pr gf fr fi fj fo fk et ee er gq sv eg ex dm dj dk cz cy hr ci cr ck cd cg km co cc cx cn cl td cf ky cv cm kh bi bf bg ls lb lv la kg kw kr kp ki ke kz jo je it il im ie iq ir id in is hu hk hn va hm ht gy gw gn gg gt gu gp gd md fm yt mu mr mq mt ml mv my mw mg mk mo lu lt li ly lr mn mc me ms ma mz mm na nr np nl nc an ni ne ng nu nf mp no om pk pw ps pg py pe pn pl pt qa re ro ru rw sh kn lc pm vc ws sm st sa sn rs sc sl sg sk si sb so za gs es lk sd sr sj sz se ch sy tw tj tz th tl tg tk to tt tn tr tm tc tv ug ua uy uz vu ve vn wf eh ye zm zw"
### Set PATH ###
IPT=/sbin/iptables
WGET=/usr/bin/wget
EGREP=/bin/egrep
### No editing below ###
SPAMLIST="countrydrop"
ZONEROOT="/root/fw.sh/zones"
DLROOT="http://www.ipdeny.com/ipblocks/data/countries"
# cleanOldRules(){
# $IPT -F
# $IPT -X
# $IPT -t nat -F
# $IPT -t nat -X
# $IPT -t mangle -F
# $IPT -t mangle -X
# $IPT -P INPUT ACCEPT
# $IPT -P OUTPUT ACCEPT
# $IPT -P FORWARD ACCEPT
# }
# create a dir
[ ! -d $ZONEROOT ] && /bin/mkdir -p $ZONEROOT
# create a new iptables list
$IPT -N $SPAMLIST
for c  in $ISO
do
	# local zone file
	tDB=$ZONEROOT/$c.zone
	# get fresh zone file
	$WGET -O $tDB $DLROOT/$c.zone >> /dev/null 2>&1
	# country specific log message
	SPAMDROPMSG="$c Country Drop"
	# get
	BADIPS=$(egrep -v "^#|^$" $tDB)
	for ipblock in $BADIPS
	do
	   $IPT -A $SPAMLIST -s $ipblock -j LOG --log-prefix "$SPAMDROPMSG" >> /dev/null 2>&1
	   $IPT -A $SPAMLIST -s $ipblock -j DROP >> /dev/null 2>&1
	done
done
# Drop everything
# $IPT -I INPUT -j $SPAMLIST
# $IPT -I OUTPUT -j $SPAMLIST
# $IPT -I FORWARD -j $SPAMLIST
exit 0
