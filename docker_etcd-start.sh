

#hostIp=$(ip addr|\
#  grep global|grep brd|grep -v docker|head -1|awk '{print }'|\
#cut -d '/' -f 1)
etcd --advertise-client-urls=https://${hostIp}:2379 \
  --cert-file=/etc/kubernetes/pki/etcd/server.crt --client-cert-auth=true \
  --data-dir=/var/lib/etcd \
  --initial-advertise-peer-urls=https://${hostIp}:2380 --initial-cluster=mater-10.0.1.101-2379=https://10.0.1.101:2380,slave-10.0.1.102-2379=https://10.0.1.102:2380,slave-10.0.1.103-2379=https://10.0.1.103:2380 \
  --key-file=/etc/kubernetes/pki/etcd/server.key \
  --listen-client-urls=https://127.0.0.1:2379,https://${hostIp}:2379 --listen-metrics-urls=http://127.0.0.1:2381 --listen-peer-urls=https://${hostIp}:2380 \
  --name=`hostname` \
  --peer-cert-file=/etc/kubernetes/pki/etcd/peer.crt --peer-client-cert-auth=true --peer-key-file=/etc/kubernetes/pki/etcd/peer.key --peer-trusted-ca-file=/etc/kubernetes/pki/etcd/ca.crt \
  --snapshot-count=10000 \
  --trusted-ca-file=/etc/kubernetes/pki/etcd/ca.crt \
#|tee \
#/var/log/etcd.log

