

go env -w GO111MODULE=on
go env -w GOPROXY=https://goproxy.cn,direct
go get -u github.com/cloudflare/cfssl/cmd/...
#hostip=... sed -i -e s/0.0.0.0/$hostip/g {peer,server}-csr.json
cfssl gencert -initca ca-csr.json |cfssljson -bare cert/ca
cfssl gencert --config=ca-config.json -ca=cert/ca.pem -ca-key=cert/ca-key.pem -profile=etcd healthcheck-client-csr.json |cfssljson -bare cert/healthcheck-client
cfssl gencert --config=ca-config.json -ca=cert/ca.pem -ca-key=cert/ca-key.pem -profile=etcd peer-csr.json |cfssljson -bare cert/peer
cfssl gencert --config=ca-config.json -ca=cert/ca.pem -ca-key=cert/ca-key.pem -profile=etcd server-csr.json |cfssljson -bare cert/server
#cfssl gencert --config=ca-config.json -ca=cert/ca.crt -ca-key=cert/ca.key -profile=etcd kube-apiserver-etcd-client-csr.json |cfssljson -bare apiserver-etcd-client
cd cert/;ls |grep -v .pem|xargs rm;cd ..
sh ./rename.sh
