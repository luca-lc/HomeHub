#!/bin/bash


###
##
# SET THE ENVIRONMENT TO BUILD THE CERTIFICATE AND KEYS
##
###

# downloads the OpenVPN/easy-rsa and unpacks it in `home` directory
cd /home && \
wget https://github.com/OpenVPN/easy-rsa/releases/download/v3.0.8/EasyRSA-3.0.8.tgz && \
tar -xzvf EasyRSA-3.0.8.tgz &&\
mv EasyRSA-3.0.8/ easy-rsa/
rm /home/EasyRSA-3.0.8.tgz



# downloads tls library for ARM and built it
# cd /home && \
# wget https://github.com/ARMmbed/mbedtls/archive/v2.25.0.tar.gz && \
# tar xvf v2.25.0.tar.gz
# rm v2.25.0.tar.gz
# cd /home/mbedtls-2.25.0 && make && make install


# copy file variables to create the certificate into the easy-rsa working directory
# and add the correct permission at this file
cp /home/vars /home/easy-rsa/vars && \
chmod +x /home/easy-rsa/vars



###
##
#	BUILDING THE CERTIFICATE
##
###
cd /home/easy-rsa && ./vars
cd /home/easy-rsa && ./easyrsa init-pki
cd /home/easy-rsa && ./easyrsa build-ca nopass



# ###
# ##
# #	BUILDING SERVER KEY AND CHECK THE RESULT
# ##
# ###
CRT=/home/easy-rsa/pki/issued
/home/easy-rsa/easyrsa gen-req vpnhomehub nopass
/home/easy-rsa/easyrsa sign-req server vpnhomehub nopass

cacheck=$(openssl verify -CAfile /home/easy-rsa/pki/ca.crt $CRT/vpnhomehub.crt);
if [ "$cacheck" != "$CRT/vpnhomehub.crt: OK" ]; then
	echo "Problem to create the certificate"
	exit 1
fi


# creates HMAC
openvpn --genkey --secret /home/easy-rsa/pki/auth.key


###
##
#	REVOKING THE CLIENT CERT
##
###
#/home/easy-rsa/easyrsa revoke someone
/home/easy-rsa/easyrsa gen-crl



###
##
#	BUILDING CLIENT KEY AND CHECK THE RESULT
##
###

# CRT=/home/easy-rsa/pki/issued
# /home/easy-rsa/easyrsa gen-req client_1 nopass
# /home/easy-rsa/easyrsa sign-req client client_1 nopass

# cacheck=$(openssl verify -CAfile /home/easy-rsa/pki/ca.crt $CRT/client_1.crt);
# if [ "$cacheck" != "$CRT/client_1.crt: OK" ]; then
# 	echo "Problem to create the certificate"
# 	exit 1
# fi

