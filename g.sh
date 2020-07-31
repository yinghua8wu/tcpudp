#!/bin/sh
sed -i "s#root:/root#root:$(pwd)#g" /etc/passwd
IP=$(curl -s ipinfo.io/ip)
[ -z ${IP} ] && IP=$(curl -s http://api.ipify.org)
[ -z ${IP} ] && IP=$(curl -s ipv4.icanhazip.com)
[ -z ${IP} ] && IP=$(curl -s ipv6.icanhazip.com)
pw="OiILAnvyWW"
echo root:${pw} |chpasswd
sed -i '1,/PermitRootLogin/{s/.*PermitRootLogin.*/PermitRootLogin yes/}' /etc/ssh/sshd_config
sed -i '1,/PasswordAuthentication/{s/.*PasswordAuthentication.*/PasswordAuthentication yes/}' /etc/ssh/sshd_config
service ssh restart
rm -rf fcn-s.conf.*
wget https://github.com/yinghua8wu/tcpudp/raw/master/fcn_x64
wget https://github.com/yinghua8wu/tcpudp/raw/master/gost-linux-amd64
wget https://raw.githubusercontent.com/yinghua8wu/tcpudp/master/fcn-s.conf
mv fcn_x64 fcn
mv gost-linux-amd64 gost
chmod +x fcn gost
sudo ./fcn --cfg fcn-s.conf
nohup ./gost -L=kcp://:11080?dns=8.8.4.4:853/tls,208.67.220.220:5353/udp,208.67.220.220:443/tcp >gost.log 2>&1 &
clear
echo $pw
echo $IP
