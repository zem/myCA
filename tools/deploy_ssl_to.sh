#!/bin/bash
CN=$1
shift
TO=$1
shift
scp $@ tools/gen_cert_request.sh root@${TO}:. || exit $?
ssh $@ -l root ${TO} /root/gen_cert_request.sh ${CN} || exit $?
scp $@ root@${TO}:/etc/letsencrypt/live/${CN}/request.pem requests/${CN}.pem || exit $?
make || exit $?
scp $@ certs/${CN}.pem root@${TO}:/etc/letsencrypt/live/${CN}/cert.pem || exit $?
scp $@ cacert.pem root@${TO}:/etc/letsencrypt/live/${CN}/fullchain.pem || exit $?
git add certs/${CN}.pem requests/${CN}.pem newcerts/*
git commit -a -m "added certificate for ${CM} to ${TO}"
