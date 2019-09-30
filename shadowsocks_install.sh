#!/bin/bash

if [ `grep -c "soft nofile 65536" /etc/security/limits.conf` -eq "0" ]; then  echo "* soft nofile 65536" >>/etc/security/limits.conf; fi
if [ `grep -c "hard nofile 65536" /etc/security/limits.conf` -eq "0" ]; then  echo "* hard nofile 65536" >>/etc/security/limits.conf; fi

cpus=`cat /proc/cpuinfo | grep processor | wc -l`
let makeprocess=$cpus*2

yum -y install gettext gcc autoconf libtool automake make asciidoc xmlto c-ares-devel libev-devel git wget pcre pcre-devel file net-tools telnet

wget https://download.libsodium.org/libsodium/releases/LATEST.tar.gz && tar zxf LATEST.tar.gz

cd libsodium-stable && ./configure --prefix=/usr/local/libsodium && make -j${makeprocess} && make install

echo "/usr/local/libsodium/lib" >> /etc/ld.so.conf && ldconfig

wget https://tls.mbed.org/download/mbedtls-2.16.3-apache.tgz && tar zxf mbedtls-2.16.3-apache.tgz

cd mbedtls-2.16.3 && make SHARED=1 CFLAGS=-fPIC && make -j${makeprocess} DESTDIR=/usr/local/mbedtls install

echo "/usr/local/mbedtls/lib" >> /etc/ld.so.conf && ldconfig

git clone https://github.com/shadowsocks/shadowsocks-libev.git && cd shadowsocks-libev/ && git submodule update --init --recursive && ./autogen.sh && ./configure --prefix=/usr/local/shadowsocks --with-mbedtls=/usr/local/mbedtls/ --with-sodium=/usr/local/libsodium/ && make -j${makeprocess} && make install

mkdir /usr/local/shadowsocks/etc /usr/local/shadowsocks/cert

wget https://52-164596259-gh.circle-artifacts.com/0/bin/v2ray-plugin-linux-amd64-v1.1.0-20-gca36119.tar.gz && tar zxf v2ray-plugin-linux-amd64-v1.1.0-20-gca36119.tar.gz
mv v2ray-plugin_linux_amd64 /usr/local/bin/v2ray-plugin
