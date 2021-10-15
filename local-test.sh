

./etcd --help

./etcd --advertise-client-urls=https://127.0.0.1:2379 --cert-file=`pwd`/cert/server.crt --client-cert-auth=true --data-dir=/tmp/local-test/2379 --initial-advertise-peer-urls=https://127.0.0.1:2380 --initial-cluster=mater-127.0.0.1-2379=https://127.0.0.1:2380,slave-127.0.0.1-2371=https://127.0.0.1:12380,slave-127.0.0.1-2373=https://127.0.0.1:32380 --key-file=`pwd`/cert/server.key --listen-client-urls=https://127.0.0.1:2379 --listen-metrics-urls=http://127.0.0.1:2381 --listen-peer-urls=https://127.0.0.1:2380 --name=mater-127.0.0.1-2379 --peer-cert-file=`pwd`/cert/peer.crt --peer-client-cert-auth=true --peer-key-file=`pwd`/cert/peer.key --peer-trusted-ca-file=`pwd`/cert/ca.crt --snapshot-count=10000 --trusted-ca-file=`pwd`/cert/ca.crt

./etcd --advertise-client-urls=https://127.0.0.1:12379 --cert-file=`pwd`/cert/server.crt --client-cert-auth=true --data-dir=/tmp/local-test/12379 --initial-advertise-peer-urls=https://127.0.0.1:12380 --initial-cluster=mater-127.0.0.1-2379=https://127.0.0.1:2380,slave-127.0.0.1-2371=https://127.0.0.1:12380,slave-127.0.0.1-2373=https://127.0.0.1:32380 --key-file=`pwd`/cert/server.key --listen-client-urls=https://127.0.0.1:12379 --listen-metrics-urls=http://127.0.0.1:12381 --listen-peer-urls=https://127.0.0.1:12380 --name=slave-127.0.0.1-2371 --peer-cert-file=`pwd`/cert/peer.crt --peer-client-cert-auth=true --peer-key-file=`pwd`/cert/peer.key --peer-trusted-ca-file=`pwd`/cert/ca.crt --snapshot-count=10000 --trusted-ca-file=`pwd`/cert/ca.crt

./etcd --advertise-client-urls=https://127.0.0.1:32379 --cert-file=`pwd`/cert/server.crt --client-cert-auth=true --data-dir=/tmp/local-test/32379 --initial-advertise-peer-urls=https://127.0.0.1:32380 --initial-cluster=mater-127.0.0.1-2379=https://127.0.0.1:2380,slave-127.0.0.1-2371=https://127.0.0.1:12380,slave-127.0.0.1-2373=https://127.0.0.1:32380 --key-file=`pwd`/cert/server.key --listen-client-urls=https://127.0.0.1:32379 --listen-metrics-urls=http://127.0.0.1:32381 --listen-peer-urls=https://127.0.0.1:32380 --name=slave-127.0.0.1-2373 --peer-cert-file=`pwd`/cert/peer.crt --peer-client-cert-auth=true --peer-key-file=`pwd`/cert/peer.key --peer-trusted-ca-file=`pwd`/cert/ca.crt --snapshot-count=10000 --trusted-ca-file=`pwd`/cert/ca.crt


./etcdctl --help

./etcdctl --endpoints="127.0.0.1:2379,127.0.0.1:12379,127.0.0.1:32379" --cacert=`pwd`/cert/ca.crt --cert=`pwd`/cert/server.crt --key=`pwd`/cert/server.key endpoint status --write-out=table
