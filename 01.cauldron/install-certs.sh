#!/bin/bash
ca-legacy install
mkdir -p /etc/pki/ca-trust/extracted/openssl \
        /etc/pki/ca-trust/extracted/pem \
        /etc/pki/ca-trust/extracted/java \
        /etc/pki/ca-trust/extracted/edk2
update-ca-trust
