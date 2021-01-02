#!/bin/bash


###
##
# SET THE ENVIRONMENT TO BUILD THE CERTIFICATE AND KEYS
##
###

# download the OpenVPN/easy-rsa packet and unpack in `home` directory
cd /home && \
wget https://github.com/OpenVPN/easy-rsa/releases/download/v3.0.8/EasyRSA-3.0.8.tgz && \
tar -xzvf EasyRSA-3.0.8.tgz

cd /home && \
wget https://github.com/ARMmbed/mbedtls/archive/v2.25.0.tar.gz && \
tar xvf v2.25.0.tar.gz

# move esay-rsa packet into OVPN directory
cd /home && \
mv EasyRSA-3.0.8/ easy-rsa/

# remove archives
rm /home/EasyRSA-3.0.8.tgz
rm v2.25.0.tar.gz

# install packages
cd /home/mbedtls-2.25.0 && make && make install





# # copy file variables to create the certificate into the easy-rsa working directory
# # and add the correct permission at this file
cp /home/vars /home/easy-rsa/vars && \
chmod +x /home/easy-rsa/vars



# ###
# ##
# #	BUILDING THE CERTIFICATE
# ##
# ###
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
/home/easy-rsa/easyrsa sign-req server vpnhomehub y

cacheck=$(openssl verify -CAfile /home/easy-rsa/pki/ca.crt $CRT/vpnhomehub.crt);
if [ "$cacheck" != "$CRT/vpnhomehub.crt: OK" ]; then
	echo "Problem to create the certificate"
	exit 1
fi



# ###
# ##
# #	BUILDING CLIENT KEY AND CHECK THE RESULT
# ##
# ###
CRT=/home/easy-rsa/pki/issued
/home/easy-rsa/easyrsa gen-req client_1 nopass
/home/easy-rsa/easyrsa sign-req client client_1 y

cacheck=$(openssl verify -CAfile /home/easy-rsa/pki/ca.crt $CRT/client_1.crt);
if [ "$cacheck" != "$CRT/client_1.crt: OK" ]; then
	echo "Problem to create the certificate"
	exit 1
fi



# ###
# ##
# #	BUILDING DH KEY
# ##
# ###
# /home/easy-rsa/easyrsa gen-dh

# # HMAC
openvpn --genkey --secret auth.key



# ###
# ##
# #	REVOKING THE CLIENT CERT
# ##
# ###

# #/home/easy-rsa/easyrsa revoke someone
# #/home/easy-rsa/easyrsa gen-crl



# ###
# ##
# #	COPY FILES TO OPENVPN CONFIG DIRECTORY
# ##
# ###
# mkdir -p /etc/openvpn/server
# mkdir -p /etc/openvpn/keys
# cp /home/easy-rsa/pki/issued/vpnhomehub.crt /etc/openvpn/server
# cp /home/easy-rsa/pki/private/vpnhomehub.key /etc/openvpn/keys
# cp /home/easy-rsa/pki/ca.crt /etc/openvpn/server
# mkdir -p /etc/openvpn/keys

# mkdir -p /etc/openvpn/clients
# cp /home/easy-rsa/pki/ca.crt /etc/openvpn/clients/
# cp /home/easy-rsa/pki/issued/client_test.crt /etc/openvpn/clients/
# cp /home/easy-rsa/pki/private/client_test.key /etc/openvpn/keys/

# # cp -f /home/easy-rsa/pki/dh.pem /etc/openvpn/server/dh.pem
# # cp /home/easy-rsa/pki/crl.pem /etc/openvpn/server/



###
##
#	ENABLE PORT-FORWARDING
##
###

echo 'net.ipv4.ip_forward = 1' >> /etc/sysctl.conf

sed -i 's/DEFAULT_FORWARD_POLICY="DROP"/DEFAULT_FORWARD_POLICY="ACCEPT"/' /etc/default/ufw

dev=$(ip route | grep default | awk 'NR==1{print $5}')

{ echo -ne '# START OPENVPN RULES\n# NAT table rules\n*nat\n:POSTROUTING ACCEPT [0:0]\n# Allow traffic from OpenVPN client to wlp11s0 (change to the interface you discovered!)\n-A POSTROUTING -s 10.8.0.0/8 -o wlp11s0 -j MASQUERADE\nCOMMIT\n# END OPENVPN RULES\n'; cat /etc/ufw/before.rules; } >/etc/ufw/before.rules.new

mv /etc/ufw/before.rules.new /etc/ufw/before.rules