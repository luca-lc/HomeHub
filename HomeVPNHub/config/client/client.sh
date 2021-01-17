#!/bin/bash

RED='\033[0;31m'
NC='\033[0m'


if [[ -z "$1" ]]; then
    echo -e "${RED}Invalid client name. Retry with a valid name${NC}"
else
    PKI=/home/easy-rsa/pki
    /home/easy-rsa/easyrsa gen-req $1 nopass
    /home/easy-rsa/easyrsa sign-req client $1 nopass

    cacheck=$(openssl verify -CAfile $PKI/ca.crt $PKI/issued/$1.crt);
    if [ "$cacheck" != "$PKI/issued/$1.crt: OK" ]; then
        echo "Problem to create the certificate"
        exit 1
    fi

    mv $PKI/issued/$1.crt /home/OVPN/clients/certs
    mv $PKI/private/$1.key /home/OVPN/clients/keys


    CDIR=/home/OVPN
    KEY_DIR=/home/OVPN/clients/keys
    CERT_DIR=/home/OVPN/clients/certs
    TA_DIR=/home/OVPN/sever/keys
    OUTPUT_DIR=/home/OVPN/clients/ovpn

    BASE_CONFIG=/home/OVPN/clients/client.conf

    cat ${BASE_CONFIG} \
        <(echo -e '<ca>') \
        ${CDIR}/ca.crt \
        <(echo -e '</ca>\n<cert>') \
        ${CERT_DIR}/${1}.crt \
        <(echo -e '</cert>\n<key>') \
        ${KEY_DIR}/${1}.key \
        <(echo -e '</key>\n<tls-auth>') \
        ${TA_DIR}/auth.key \
        <(echo -e '</tls-auth>') \
        > ${OUTPUT_DIR}/${1}.ovpn
    
    echo -e "\n\ndone!\nclient file name is ${RED}$1.ovpn${NC}"
fi