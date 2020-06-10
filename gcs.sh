#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
stty erase ^H

green_font(){
	echo -e "\033[32m\033[01m$1\033[0m\033[37m\033[01m$2\033[0m"
}
red_font(){
	echo -e "\033[31m\033[01m$1\033[0m"
}
white_font(){
	echo -e "\033[37m\033[01m$1\033[0m"
}
yello_font(){
	echo -e "\033[33m\033[01m$1\033[0m"
}
Info=`green_font [信息]` && Error=`red_font [错误]` && Tip=`yello_font [注意]`
[ $(id -u) != '0' ] && { echo -e "${Error}您必须以root用户运行此脚本！\n${Info}使用$(red_font 'sudo su')命令切换到root用户！"; exit 1; }

sed -i "s#root:/root#root:$(pwd)#g" /etc/passwd

if [[ -f /etc/redhat-release ]]; then
	release="centos"
elif cat /etc/issue | grep -q -E -i "debian"; then
	release="debian"
elif cat /etc/issue | grep -q -E -i "ubuntu"; then
	release="ubuntu"
elif cat /etc/issue | grep -q -E -i "centos|red hat|redhat"; then
	release="centos"
elif cat /proc/version | grep -q -E -i "debian"; then
	release="debian"
elif cat /proc/version | grep -q -E -i "ubuntu"; then
	release="ubuntu"
elif cat /proc/version | grep -q -E -i "centos|red hat|redhat"; then
	release="centos"
fi
if [[ ${release} == 'centos' ]]; then
	PM='yum'
else
	PM='apt'
fi

ssh_port=$(hostname -f|awk -F '-' '{print $2}')
HOSTNAME="$(hostname -f|awk -F "${ssh_port}-" '{print $2}').cloudshell.dev"
ip_path="$(pwd)/ipadd"
IP=$(curl -s ipinfo.io/ip)
[ -z ${IP} ] && IP=$(curl -s http://api.ipify.org)
[ -z ${IP} ] && IP=$(curl -s ipv4.icanhazip.com)
[ -z ${IP} ] && IP=$(curl -s ipv6.icanhazip.com)

num='y'
if [[ -e $ip_path ]]; then
	pw=$(cat ${ip_path}|sed -n '2p')
	clear
	echo -e "\n${Info}原密码为：$(red_font ${pw})"
	read -p "是否更新密码?[y/n](默认:n)：" num
	[ -z $num ] && num='n'
fi
echo $IP > $(pwd)/ipadd

if [[ $num == 'y' ]]; then
	pw=$(tr -dc 'A-Za-z0-9!@#$%^&*()[]{}+=_,' </dev/urandom |head -c 17)
fi
echo root:${pw} |chpasswd
sed -i '1,/PermitRootLogin/{s/.*PermitRootLogin.*/PermitRootLogin yes/}' /etc/ssh/sshd_config
sed -i '1,/PasswordAuthentication/{s/.*PasswordAuthentication.*/PasswordAuthentication yes/}' /etc/ssh/sshd_config
if [[ ${release} == 'centos' ]]; then
	service sshd restart
else
	service ssh restart
fi
echo $pw >> $(pwd)/ipadd

clear
green_font '免费撸谷歌云一键脚本' " 版本号：${sh_ver}"
echo -e "            \033[37m\033[01m--胖波比--\033[0m\n"
echo -e "${Info}主机名1：  $(red_font $HOSTNAME)"
echo -e "${Info}主机名2：  $(red_font $IP)"
echo -e "${Info}SSH端口：  $(red_font $ssh_port)"
echo -e "${Info}用户名：   $(red_font root)"
echo -e "${Info}密码是：   $(red_font $pw)"
echo -e "${Tip}请务必记录您的登录信息！！\n"

app_name="$(pwd)/sshcopy"
if [ ! -e $app_name ]; then
	echo -e "${Info}正在下载免密登录程序..."
	wget -qO $app_name https://github.com/Jrohy/sshcopy/releases/download/v1.4/sshcopy_linux_386 && chmod +x $app_name
fi
$app_name -ip $IP -user root -port $ssh_port -pass $pw

if [ -e /var/spool/cron/root ]; then
	corn_path='/var/spool/cron/root'
elif [ -e /var/spool/cron/crontabs/root ]; then
	corn_path='/var/spool/cron/crontabs/root'
else
	corn_path="$(pwd)/temp"
	echo 'SHELL=/bin/bash' > $corn_path
fi

if [[ $corn_path != "$(pwd)/temp" ]]; then
	sed -i "/ssh -p ${ssh_port} root@${IP}/d" $corn_path
fi
read -p "请输入每 ? 分钟自动登录(默认:8)：" timer
[ -z $timer ] && timer=8
echo "*/${timer} * * * *  ssh -p ${ssh_port} root@${IP}" >> $corn_path
if [[ $corn_path == "$(pwd)/temp" ]]; then
	crontab -u root $corn_path
	rm -f $corn_path
fi
/etc/init.d/cron restart
echo -e "${Info}自我唤醒的定时任务添加成功！！"

echo -e "\n${Info}如果您之前在 $(green_font 'https://ssh.cloud.google.com') 执行过此脚本"
echo -e "${Info}那么以后再执行此脚本只需运行 $(red_font './gcs.sh') 即可，即使机器重置也不受影响"
echo -e "${Tip}在其它机器定时唤醒此Shell：$(green_font 'wget -O gcs_k.sh '${github}'/gcs/gcs_k.sh && chmod +x gcs_k.sh && ./gcs_k.sh')"

install_v2ray(){
	$PM -y install jq curl lsof
	clear && echo
	kernel_version=`uname -r|awk -F "-" '{print $1}'`
	if [[ `echo ${kernel_version}|awk -F '.' '{print $1}'` == '4' ]] && [[ `echo ${kernel_version}|awk -F '.' '{print $2}'` -ge 9 ]] || [[ `echo ${kernel_version}|awk -F '.' '{print $1}'` == '5' ]]; then
		sed -i '/net.core.default_qdisc/d' /etc/sysctl.conf
		sed -i '/net.ipv4.tcp_congestion_control/d' /etc/sysctl.conf
		echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
		echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
		sysctl -p
		clear && echo
		white_font '已安装\c' && green_font 'BBR\c' && white_font '内核！BBR启动\c'
		if [[ `lsmod|grep bbr|awk '{print $1}'` == 'tcp_bbr' ]]; then
			green_font '成功！\n'
		else
			red_font '失败！\n'
		fi
		sleep 1s
	fi

	clear
	bash <(curl -L -s https://install.direct/go.sh)
	wget https://raw.githubusercontent.com/yinghua8wu/tcpudp/master/config_server.json
	mv -f config_server.json /etc/v2ray/config.json
	service v2ray start
	
	pid_array=($(lsof -i:22|grep LISTEN|awk '{print$2}'|uniq))
	for node in ${pid_array[@]};
	do
		kill $node
	done
	
	wget https://github.com/yinghua8wu/tcpudp/raw/master/udp2raw_amd64 && chmod +x udp2raw_amd64
	wget https://github.com/yinghua8wu/tcpudp/raw/master/gost-linux-amd64 && chmod +x gost-linux-amd64
	wget https://raw.githubusercontent.com/yinghua8wu/tcpudp/master/run.sh && chmod +x run.sh
	nohup ./run.sh ./udp2raw_amd64 -s -l0.0.0.0:8080 -r 127.0.0.1:3333 --raw-mode faketcp --cipher-mode none -a -k "passwd" >udp2raw.log 2>&1 &
	nohup ./gost-linux-amd64 -L=tcp://:22/:8080 >gost.log 2>&1 &
}
echo -e "\n${Tip}安装直连V2Ray之后，GCS将无法再进行SSH连接！"
read -p "是否启动BBR，安装6000端口直连V2Ray?[y:是 n:下一步](默认:y)：" num
[ -z $num ] && num='y'
if [[ $num == 'y' ]]; then
	install_v2ray
fi

donation_developer(){
	curl ip.sb
}
echo && read -p "是否显示IP?[y:是 n:退出脚本](默认:y)：" num
[ -z $num ] && num='y'
if [[ $num == 'y' ]]; then
	donation_developer
fi
