#!/bin/bash


RED='\033[0;31m'
NC='\033[0m'

if [[ "$EUID" = 0 ]]; then
	if [[ -z $1 ]]; then
		echo -e "${RED}The client name cannot be empty!${NC}"
		exit 1
	else
		docker exec -w /home/easy-rsa vpnhub_ovpn_1 ./client.sh $1
	fi
else
	echo -e "${RED}It must be run as sudo${NC}"
fi