#!/bin/bash

port_array=("10540" "34411" "40284" "51501" "55464")

function ss_process()
{
    len_process=`ps axu | grep $1 | grep -v grep | wc -l`
    if [ "$len_process" = "0" ];then
        /usr/local/shadowsocks/bin/ss-server -v -d 8.8.8.8 -d 8.8.4.4 -c /usr/local/shadowsocks/etc/config_${1}.json -f /var/run/shadowsocks-server/pid${1}
    fi
}

while true
do
    for port in ${port_array[*]}
    do
        ss_process $port &
    done
    wait
    sleep 86400s
done
