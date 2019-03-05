#!/bin/bash

function ss_process()
{
	len_process=`ps axu | grep $1 | grep -v grep | wc -l`
	if [ "$len_process" = "0" ];then
		/usr/local/shadowsocks/bin/ss-server -v -u -d 8.8.8.8 -d 8.8.4.4 -c /usr/local/shadowsocks/etc/config_${1}.json -f /var/run/shadowsocks-server/pid${1}
	fi
}

while true
do
	ss_process 42739
	ss_process 33872
	ss_process 61224
	ss_process 35857
	ss_process 44293
	sleep 86400
done
