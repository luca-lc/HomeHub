FROM debian:latest

RUN apt update && apt -y full-upgrade

RUN apt install -y openvpn openssl wget make gcc g++ python2 python3 ufw sed gawk

RUN mkdir /home/OVPN

COPY ./config.sh /config.sh

COPY ./config/vars /home/vars

COPY ./lsVPN.conf /homehub.conf

RUN /config.sh


RUN mkdir -p /etc/openvpn/server && \
		mkdir -p /etc/openvpn/keys && \
		mv /home/easy-rsa/pki/issued/vpnhomehub.crt /etc/openvpn/server && \ 
		mv /home/easy-rsa/pki/private/vpnhomehub.key /etc/openvpn/keys && \
		mv /home/easy-rsa/pki/ca.crt /etc/openvpn/server && \
		mv /home/easy-rsa/auth.key /etc/openvpn/keys

RUN mkdir -p /etc/openvpn/clients && \
		cp /etc/openvpn/server/ca.crt /etc/openvpn/clients/ && \
		mv /home/easy-rsa/pki/issued/client_1.crt /etc/openvpn/clients/ && \
		mv /home/easy-rsa/pki/private/client_1.key /etc/openvpn/keys/


# RUN apt-get install systemd -y

# RUN service openvpn start && openvpn --config /homehub.conf

CMD tail -f /dev/null