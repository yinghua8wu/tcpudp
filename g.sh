#!/bin/bash
#sed -i "s#root:/root#root:$(pwd)#g" /etc/passwd
IP=$(curl -s ipinfo.io/ip)
[ -z ${IP} ] && IP=$(curl -s http://api.ipify.org)
[ -z ${IP} ] && IP=$(curl -s ipv4.icanhazip.com)
[ -z ${IP} ] && IP=$(curl -s ipv6.icanhazip.com)
#pw="OiILAnvyWW"
#echo root:${pw} |chpasswd
#sed -i '1,/PermitRootLogin/{s/.*PermitRootLogin.*/PermitRootLogin yes/}' /etc/ssh/sshd_config
#sed -i '1,/PasswordAuthentication/{s/.*PasswordAuthentication.*/PasswordAuthentication yes/}' /etc/ssh/sshd_config
#useradd -m -p $pw $username

cat >> /etc/ssh/sshd_config << EOF
AuthorizedKeysFile     %h/.ssh/authorized_keys
EOF

rm -rf fcn* gost* ssh* id*
#wget https://raw.githubusercontent.com/yinghua8wu/tcpudp/master/sshd_config
wget https://github.com/yinghua8wu/tcpudp/raw/master/fcn_x64
wget https://github.com/yinghua8wu/tcpudp/raw/master/gost-linux-amd64
wget https://raw.githubusercontent.com/yinghua8wu/tcpudp/master/fcn-s.conf
wget https://raw.githubusercontent.com/yinghua8wu/tcpudp/master/id_rsa.pub
mkdir /root/.ssh
cat id_rsa.pub >> /root/.ssh/authorized_keys
chmod 600 /root/.ssh/authorized_keys
chmod 700 /root/.ssh
#mv sshd_config /etc/ssh/sshd_config
mv fcn_x64 fcn
mv gost-linux-amd64 gost
chmod +x fcn gost
sudo ./fcn --cfg fcn-s.conf
nohup ./gost -L ss+kcp://chacha20:gcspw@:11080?dns=8.8.4.4:853/tls,1.0.0.1:853/tls >gost.log 2>&1 &
#echo $pw
service ssh restart
clear
ps -x
echo "ssh -o StrictHostKeyChecking=no -i ~/.ssh/id_rsa -p 6000 root@$IP"
