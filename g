
nohup ./run.sh ./udp2raw_amd64 -s -l0.0.0.0:22 -r 127.0.0.1:3333 --raw-mode faketcp --cipher-mode none -a -k "passwd" >udp2raw.log 2>&1 &
