#!/bin/bash

RED='\033[0;31m'
NC='\033[0m'

###
##
#	ENABLE PORT-FORWARDING
##
###
if [[ "$EUID" = 0 ]]; then

	apt install ufw -y 

	echo -e "\n"

	sed -i 's/net.ipv4.ip_forward=0/net.ipv4.ip_forward=1/' /etc/sysctl.conf
	ipforward=$(sysctl -p)
	if [[ $ipforward == "net.ipv4.ip_forward = 1" ]]; then
		echo -e "IP Forwarding is ${RED}OK${NC}\n"
	else
		echo -e "${RED}Problem to set the FORWARING: fix it alone substituting with '1' in 'net.ipv4.ip_forward' in /etc/sysctl.conf file${NC}\n"
	fi
	
	sed -i 's/DEFAULT_FORWARD_POLICY="DROP"/DEFAULT_FORWARD_POLICY="ACCEPT"/' /etc/default/ufw
	forwardpol=$(cat /etc/default/ufw | grep 'DEFAULT_FORWARD_POLICY="ACCEPT"')
	if [[ $forwardpol == 'DEFAULT_FORWARD_POLICY="ACCEPT"' ]]; then
		echo -e "Forwarding Policy is ${RED}OK${NC}\n"
	else
		echo -e "${RED}Problem to set the FORWARING POLICY: fix it alone substituting with 'ACCEPT' in 'DEFAULT_FORWARD_POLICY' in /etc/default/ufw${NC}\n"
	fi


	dev=$(ip route | grep default | awk 'NR==1{print $5}')

	rule=$(cat /etc/ufw/before.rules | egrep "POSTROUTING")

	if [[ $rule == "" ]]; then
		{ echo -ne '# START OPENVPN RULES\n# NAT table rules\n*nat\n:POSTROUTING ACCEPT [0:0]\n-A POSTROUTING -s 10.8.0.0/8 -o '${dev}' -j MASQUERADE\nCOMMIT\n# END OPENVPN RULES\n'; cat /etc/ufw/before.rules; } >/etc/ufw/before.rules.new
		mv /etc/ufw/before.rules.new /etc/ufw/before.rules
		echo -e "POSTROUTING is ${RED}OK${NC}\n"
	else
		echo -e "${RED}Already exists a POSTROUTING: you have to fix alone with this command: 'sudo nano /etc/ufw/before.rules'${NC}\n"
	fi 

	ufw enable
	ufw allow 46580/udp
	ufw disable
	ufw enable

	echo -e "\n"

	docker-compose up --build

else
	echo -e "${RED}It must be run as sudo${NC}"
fi