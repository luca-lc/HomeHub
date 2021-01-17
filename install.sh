#!/bin/bash

RED='\033[0;31m'
NC='\033[0m'

if [[ "$EUID" = 0 ]]; then

	##
	## SET HOST
	##
	apt install ufw -y # installation of ufw for easier management of iptables

	ufw enable
	ufw allow 443/tcp # open port for web server
	ufw allow 20/tcp # open port for ftp data
	ufw allow 21/tcp # open port for ftp commands

	##
	## SET FTP USERS 
	##
	ftpusers=0
	while [[ $ftpusers -eq 0 || -z $ftpusers ]] # check that there is at least one user
	do
		read -p "Insert the number of the FTP users: " ftpusers # ask the number of the users
	done 

	echo ""
	loop=1
	echo -e "# ftp users and their password\n" > ./FTPHub/conf/configFile.conf # reset of config file
	while [ $loop -le $ftpusers ]
	do
		read -p "Insert $loop username: " uname
		read -p "Insert $loop password: " upwd
		echo -e "uname$loop=$uname\nupass$loop=$upwd\n\n" >> ./FTPHub/conf/configFile.conf # append data in config file
		((loop=loop+1))
		echo ""
	done
	echo -e "nusers=$ftpusers" >> ./FTPHub/conf/configFile.conf
	echo ""

	##
	## CHECK IF THE DOCKER COMPOSE IS CORRECT
	##
	checkdc="no"
	while [[ ${checkdc^h} != "yes" ]]
	do
		read -p "Have you checked if 'docker-compose' is OK? [yes/NO]" checkdc
	done

	##
	## START THE BUILDING
	##
	echo -e "${RED}Creation of the container started!\nIt could take a long time. Wait please...\n\n${NC}"

	docker-compose build # start the building

	##
	## START THE START-UP
	##
	while [[ ${start^h} != "yes" && ${start^h} != "no" ]]
	do
		read -p "Do you want to start the containers? [yes/NO]" start # ask to start the containers
	done

	if [[ ${start^h} == "yes" ]]; then
		echo -e "\n${RED}The containers are starting up${NC}"
		docker-compose start 
		docker stats --no-stream
		echo -e "\n${RED}done!${NC}"
	fi

else
	echo -e "${RED}It must be run as sudo${NC}"
fi