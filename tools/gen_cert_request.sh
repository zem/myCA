#!/bin/bash
export CN=$1

if [[ -z ${CN} ]]
then
	echo no common name
	exit 2
fi

# yea I know we hijacked a letsencrypt directory
# reason is we are layzy and dont want to distinguish 
# in puppet templates
CA_PATH=/etc/letsencrypt/live/${CN}

if [[ -d ${CA_PATH} ]]
then
	rm ${CA_PATH}/* || exit 1
	rmdir ${CA_PATH} || exit 2
fi 

mkdir -m "0700" -p ${CA_PATH} || exit 3
cd ${CA_PATH} || exit 4

cat > openssl.conf << EOF
RANDFILE               = \$ENV::HOME/.rnd

[ req ]
default_bits           = 2048
default_keyfile        = keyfile.pem
distinguished_name     = req_distinguished_name
attributes             = req_attributes
prompt                 = no
output_password        = justashowsecret

[ req_distinguished_name ]
C                      = DE
ST                     = Example World
L                      = midi sized service
O                      = Example Company GmbH
OU                     = Mediservice Host
CN                     = ${CN}
emailAddress           = test@email.address

[ req_attributes ]
challengePassword              = A challenge password
EOF

openssl req -config openssl.conf -newkey rsa:2048 -keyout encrypted.privkey.pem -out request.pem
openssl rsa -in encrypted.privkey.pem -passin pass:justashowsecret -out privkey.pem

