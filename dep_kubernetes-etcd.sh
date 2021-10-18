#!/bin/bash


docker network create --driver=bridge --subnet=10.0.1.0/24 etcd

mkdir \
~/.k8s-etcds/{cert,etcd-logs,mater-10.0.1.101-2379,slave-10.0.1.102-2379,slave-10.0.1.103-2379} -p; \
touch ~/.k8s-etcds/.start.sh; \
touch ~/.k8s-etcds/etcd-logs/etcd.log; \
chmod -R 700 ~/.k8s-etcds

cat <<EOF > ~/.k8s-etcds/.start.sh


hostIp=\$(ip addr|\\
  grep global|grep brd|grep -v docker|head -1|\\
  awk '{print $2}'|\\
cut -d '/' -f 1)
etcd --advertise-client-urls=https://${hostIp}:2379 \\
  --cert-file=/etc/kubernetes/pki/etcd/server.crt \\
  --client-cert-auth=true \\
  --data-dir=/var/lib/etcd \\
  --initial-advertise-peer-urls=https://${hostIp}:2380 \\
  --initial-cluster=mater-${hostIp}-2379=https://${hostIp}:2380,\\
  slave-10.0.1.102-2379=https://10.0.1.102:2380,\\
  slave-10.0.1.103-2379=https://10.0.1.103:2380 \\
  --key-file=/etc/kubernetes/pki/etcd/server.key \\
  --listen-client-urls=https://${hostIp}:2379 \\
  --listen-metrics-urls=http://${hostIp}:2381 \\
  --listen-peer-urls=https://${hostIp}:2380 \\
  --name=mater-${hostIp}-2379 \\
  --peer-cert-file=/etc/kubernetes/pki/etcd/peer.crt \\
  --peer-client-cert-auth=true \\
  --peer-key-file=/etc/kubernetes/pki/etcd/peer.key \\
  --peer-trusted-ca-file=/etc/kubernetes/pki/etcd/ca.crt \\
  --snapshot-count=10000 \\
  --trusted-ca-file=/etc/kubernetes/pki/etcd/ca.crt \\
|tee \\
/var/log/etcd.log

EOF

docker run --privileged -itd --name etcd-m -h mater-10.0.1.101-2379 --net etcd --ip 10.0.1.101 \
  -v ~/.k8s-etcds/cert:/etc/kubernetes/pki/etcd \
  -v ~/.k8s-etcds/mater-10.0.1.101-2379:/var/lib/etcd \
  -v /etc/hosts:/etc/hosts \
  -e TZ=Asia/Shanghai -e PS1='\w \$ ' -w /root \
  -v ~/.k8s-etcds/etcd-logs/etcd.log:/var/log/etcd.log \
  -v ~/.k8s-etcds/.start.sh:/root/.start.sh \
swr.cn-east-3.myhuaweicloud.com/vipexcc/k8s/k8s.gcr.io/etcd:3.4.13-0 ~/.start.sh
#...
