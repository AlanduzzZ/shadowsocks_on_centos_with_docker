#!/bin/bash

if [ `grep -c "soft nofile 65536" /etc/security/limits.conf` -eq "0" ]; then  echo "* soft nofile 65536" >>/etc/security/limits.conf; fi
if [ `grep -c "hard nofile 65536" /etc/security/limits.conf` -eq "0" ]; then  echo "* hard nofile 65536" >>/etc/security/limits.conf; fi

cpus=`cat /proc/cpuinfo | grep processor | wc -l`
let makeprocess=$cpus*2

yum -y install gettext gcc autoconf libtool automake make asciidoc xmlto c-ares-devel libev-devel git wget pcre pcre-devel file net-tools telnet

wget https://download.libsodium.org/libsodium/releases/libsodium-1.0.16.tar.gz && tar zxf libsodium-1.0.16.tar.gz

cd libsodium-1.0.16 && ./configure --prefix=/usr/local/libsodium && make -j${makeprocess} && make install

echo "/usr/local/libsodium/lib" >> /etc/ld.so.conf && ldconfig

wget https://tls.mbed.org/download/mbedtls-2.6.0-apache.tgz && tar zxf mbedtls-2.6.0-apache.tgz

cd mbedtls-2.6.0 && make SHARED=1 CFLAGS=-fPIC && make -j${makeprocess} DESTDIR=/usr/local/mbedtls install

echo "/usr/local/mbedtls/lib" >> /etc/ld.so.conf && ldconfig

git clone https://github.com/shadowsocks/shadowsocks-libev.git && cd shadowsocks-libev/ && git submodule update --init --recursive && ./autogen.sh && ./configure --prefix=/usr/local/shadowsocks --with-mbedtls=/usr/local/mbedtls/ --with-sodium=/usr/local/libsodium/ && make -j${makeprocess} && make install

mkdir /usr/local/shadowsocks/etc
