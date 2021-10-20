#!/bin/bash


docker network create --driver=bridge --subnet=10.0.1.0/24 etcd

mkdir \
  ~/.k8s-etcds/{cert,etcd-logs,mater-10.0.1.101-2379,slave-10.0.1.102-2379,slave-10.0.1.103-2379} -p; \
  touch ~/.k8s-etcds/.start.sh; touch ~/.k8s-etcds/etcd-logs/etcd.log; \
chmod -R 700 ~/.k8s-etcds

cat <<EOF > ~/.k8s-etcds/.start.sh


#hostIp=\$(ip addr|\\
#  grep global|grep brd|grep -v docker|head -1|awk '{print $2}'|\\
#cut -d '/' -f 1)
etcd --advertise-client-urls=https://\${hostIp}:2379 \\
  --cert-file=/etc/kubernetes/pki/etcd/server.crt --client-cert-auth=true \\
  --data-dir=/var/lib/etcd \\
  --initial-advertise-peer-urls=https://\${hostIp}:2380 --initial-cluster=mater-10.0.1.101-2379=https://10.0.1.101:2380,slave-10.0.1.102-2379=https://10.0.1.102:2380,slave-10.0.1.103-2379=https://10.0.1.103:2380 \\
  --key-file=/etc/kubernetes/pki/etcd/server.key \\
  --listen-client-urls=https://127.0.0.1:2379,https://\${hostIp}:2379 --listen-metrics-urls=http://127.0.0.1:2381 --listen-peer-urls=https://\${hostIp}:2380 \\
  --name=\`hostname\` \\
  --peer-cert-file=/etc/kubernetes/pki/etcd/peer.crt --peer-client-cert-auth=true --peer-key-file=/etc/kubernetes/pki/etcd/peer.key --peer-trusted-ca-file=/etc/kubernetes/pki/etcd/ca.crt \\
  --snapshot-count=10000 \\
  --trusted-ca-file=/etc/kubernetes/pki/etcd/ca.crt \\
#|tee \\
#/var/log/etcd.log

EOF

nlist=(mater-10.0.1.101-2379 slave-10.0.1.102-2379 slave-10.0.1.103-2379)
for node in ${nlist[@]}; do ip=`echo $node|cut -d '-' -f2`
id=`echo $ip|cut -d '.' -f4`;i=${id: -1}
cmd=$(cd .k8s-etcds/;cat .start.sh|grep -v \#|sed s/\${hostIp}/${ip}/g|sed s/\`hostname\`/$node/g|sed 's/\\//g';cd ..)
  docker run \
--privileged -itd --name etcd-`if [ "$i" == "1" ]; then echo m; else echo s$i; fi` -h $node --net etcd --ip $ip \
    -v ~/.k8s-etcds/cert:/etc/kubernetes/pki/etcd -v ~/.k8s-etcds/$node:/var/lib/etcd -v /etc/hosts:/etc/hosts -v ~/.k8s-etcds/etcd-logs/etcd.log:/var/log/etcd.log -v ~/.k8s-etcds/.start.sh:/root/.start.sh \
    -e $ip -e TZ=Asia/Shanghai -e PS1='\w \$ ' -w /root \
  swr.cn-east-3.myhuaweicloud.com/vipexcc/k8s/k8s.gcr.io/etcd:3.4.13-0 \
$cmd
done

docker run --rm -it --name cli --net etcd --ip 10.0.1.106 \
  -v ~/.k8s-etcds/cert:/etc/kubernetes/pki/etcd \
  swr.cn-east-3.myhuaweicloud.com/vipexcc/k8s/k8s.gcr.io/etcd:3.4.13-0 \
  etcdctl --cacert=/etc/kubernetes/pki/etcd/ca.crt \
  --cert=/etc/kubernetes/pki/etcd/server.crt --key=/etc/kubernetes/pki/etcd/server.key \
  --endpoints="10.0.1.101:2379,10.0.1.102:2379,10.0.1.103:2379" endpoint status \
--write-out=table

#...
