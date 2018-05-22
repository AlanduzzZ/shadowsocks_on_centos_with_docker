FROM centos:7.4.1708
MAINTAINER Alan du
RUN mkdir /install_ss
RUN mkdir /var/run/shadowsocks-server
WORKDIR /install_ss
COPY shadowsocks_install.sh ./
RUN chmod +x ./shadowsocks_install.sh && bash ./shadowsocks_install.sh
WORKDIR /
RUN rm -rf /install_ss
COPY etc/* /usr/local/shadowsocks/etc/
COPY start.sh /usr/local/shadowsocks/bin/
RUN chmod +x /usr/local/shadowsocks/bin/start.sh
CMD ["bash", "/usr/local/shadowsocks/bin/start.sh"]
