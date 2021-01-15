FROM debian:latest

RUN apt update && apt -y full-upgrade

RUN apt install -y openvpn openssl wget make gcc g++ python2 python3 ufw sed gawk

RUN mkdir -p /home/OVPN

COPY ./config/vars /home/vars
COPY ./config/server/config.sh /config.sh
COPY ./config/server/lsVPN.conf /vpnhomehub.conf

RUN /config.sh


RUN mkdir -p /etc/openvpn/server && \
		mkdir -p /home/OVPN/sever/keys && \
		mkdir -p /home/OVPN/clients/certs && \
		mkdir -p /home/OVPN/clients/keys

# RUN chmod 700 -r /home/OVPN/server/keys/ && \
# 		chmod 700 -r /home/OVPN/clients/keys/ && \
# 		chown root:root /home/OVPN/keys/

RUN	cp /home/easy-rsa/pki/ca.crt /home/OVPN && \
		cp /home/easy-rsa/pki/auth.key /home/OVPN/sever/keys && \
		mv /home/easy-rsa/pki/issued/vpnhomehub.crt /etc/openvpn/server && \ 
		mv /home/easy-rsa/pki/private/vpnhomehub.key /home/OVPN/sever/keys && \
		mv /home/easy-rsa/pki/crl.pem /etc/openvpn/server && \
		mv /vpnhomehub.conf /etc/openvpn/server/vpnhomehub.conf

COPY ./config/client/client.sh /home/easy-rsa/client.sh
COPY ./config/client/client.conf /home/OVPN/clients/client.conf


CMD openvpn --config /etc/openvpn/server/vpnhomehub.conf