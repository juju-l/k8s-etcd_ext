

cd cert/; \
ls |grep key|sed s/-key.pem//g|awk '{print "mv "$1"-key.pem "$1".key"}'|bash; \
ls |grep pem|sed s/pem//g|awk '{print "mv "$1"pem "$1"crt"}'|bash; \
cd ..
# sed -e s/-key.pem/.key/g -e s/.pem/.crt/g -i local-test.sh
tree cert
