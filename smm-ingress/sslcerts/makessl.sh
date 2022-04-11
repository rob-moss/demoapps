#!/bin/bash

if [ x$1 = "x" ]; then
    echo "Please enter the hostname for the cert:"
    read hostname
    #hostname=foo.bar.com
else
    echo "Generating cert for $hostname"
fi

export hostname
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout $hostname.key -out $hostname.crt -subj "/CN=$hostname"
kubectl create secret tls tls-$hostname --key="$hostname.key" --cert="$hostname.crt" -n smm-system
