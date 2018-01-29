

# default is to signate all certificates 
all: $(addprefix certs/, $(notdir $(wildcard requests/*.pem)))

help: 
	@echo Doing nothing.....
	@echo Targets:
	@echo "   - newca -- Clean up and generate new certificate (Dangerous)"
	@echo "   - clean -- Clean up old CA, (also dangerous)"


newca: clean
	make cacert.pem serial index.txt

# this is to initialize the key authority
cacert.pem:
	openssl req \
		-config openssl.cnf \
		-x509 -newkey rsa:4096 \
		-days 3660 \
		-keyout private/cakey.pem \
		-out cacert.pem
serial:
	echo 01 > serial

index.txt:
	touch index.txt

clean: 
	rm -f cacert.pem
	rm -f private/cacert.pem
	rm -f newcerts/*
	rm -f requests/*
	rm -f certs/*
	rm -f serial
	rm -f index.txt


certs/%.pem: requests/%.pem
	openssl ca -config openssl.cnf -in $< -out $@

