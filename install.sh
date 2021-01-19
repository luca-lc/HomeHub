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
	ufw allow 46058 # open port for ftp passive mode

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
	
	echo -e "${RED}Check if the usernames and the passwords are correct"
	cat=$(cat ./FTPHub/conf/configFile.conf | head -n -1 | tail -n +2) # remove first and last line from ftp config file
	echo -e "$cat\n\n"

	while [[ ${con^h} != "yes" && ${con^h} != "no" ]]
	do
		read -p "contiue? [yes/NO]" con
	done
	echo -e "${NC}"

	if [[ $con == "no" ]]; then
		exit 1
	fi
	

	##
	## CHECK IF THE DOCKER COMPOSE IS CORRECT
	##
	checkdc="no"
	while [[ ${checkdc^h} != "yes" ]]
	do
		read -p "Have you checked if docker-compose is OK? [yes/NO]" checkdc
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
		docker-compose up -d # start containers created
		docker stats --no-stream # show docker situation
	fi

	rm ./FTPHub/conf/configFile.conf # remove ftp config file
	
	echo -e "\n${RED}done!${NC}"

else
	echo -e "${RED}It must be run as sudo${NC}"
fi