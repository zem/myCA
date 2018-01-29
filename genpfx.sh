#!/bin/sh

if [ -z "$1" ] 
then 
	echo Usage:
	echo $0 NAME
	exit 1
fi

openssl req -newkey rsa:4096 -keyout private/$1.pem -out requests/$1.pem || exit 1
echo "ALLES SCHEISSE!!!!!!"
make || exit 1

openssl pkcs12 -export -in certs/$1.pem -inkey private/$1.pem -out pfx/$1.pfx

