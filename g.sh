#!/bin/sh
sed -i "s#root:/root#root:$(pwd)#g" /etc/passwd
IP=$(curl -s ipinfo.io/ip)
[ -z ${IP} ] && IP=$(curl -s http://api.ipify.org)
[ -z ${IP} ] && IP=$(curl -s ipv4.icanhazip.com)
[ -z ${IP} ] && IP=$(curl -s ipv6.icanhazip.com)
pw="5^1}'u%pZ)hX{N^"
echo root:${pw} |chpasswd
sed -i '1,/PermitRootLogin/{s/.*PermitRootLogin.*/PermitRootLogin yes/}' /etc/ssh/sshd_config
sed -i '1,/PasswordAuthentication/{s/.*PasswordAuthentication.*/PasswordAuthentication yes/}' /etc/ssh/sshd_config
service ssh restart
sudo ./fcn --cfg fcn-s.conf
nohup ./gost -L=kcp://:11080?dns=8.8.4.4:853/tls,208.67.220.220:5353/udp,208.67.220.220:443/tcp >gost2.log 2>&1 &
clear
echo -e "${Info}密码是：   $(red_font $pw)"
echo -e "${Info}主机名2：  $(red_font $IP)"
