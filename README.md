# tcpudp

just test

https://raw.githubusercontent.com/yinghua8wu/tcpudp/master/run.sh
https://github.com/yinghua8wu/tcpudp/raw/master/udp2raw_amd64
https://github.com/yinghua8wu/tcpudp/raw/master/speederv2_amd64
https://raw.githubusercontent.com/yinghua8wu/tcpudp/master/us

wget https://github.com/yinghua8wu/tcpudp/raw/master/udp2raw_amd64 && wget https://raw.githubusercontent.com/yinghua8wu/tcpudp/master/run.sh && wget https://github.com/yinghua8wu/tcpudp/raw/master/speederv2_amd64 && wget https://raw.githubusercontent.com/yinghua8wu/tcpudp/master/us chmod +x udp2raw_amd64 speederv2_amd64 run.sh us

vps的udp监听端口22399

nohup ./run.sh ./speederv2_amd64 -s -l0.0.0.0:9090 -r 127.0.0.1:22399 -f20:10 --mode 0 >speeder.log 2>&1 &

nohup ./run.sh ./udp2raw_amd64 -s -l0.0.0.0:8080 -r 127.0.0.1:9090 --raw-mode faketcp --cipher-mode none -a -k "passwd" >udp2raw.log 2>&1 &

[ipv6]

nohup ./run.sh ./speederv2_amd64 -s -l[::]:9090 -r[::1]:22399 -f20:10 --mode 0 >speeder.log 2>&1 &

nohup ./run.sh ./udp2raw_amd64 -s -l[::]:8080 -r[::1]:9090 --raw-mode faketcp --cipher-mode none -a -k "passwd" >udp2raw.log 2>&1 &

vim us

./us

