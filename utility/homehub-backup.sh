#!/bin/bash

RED='\e[1;31m'
GREEN='\e[1;32m'
YELLOW='\e[1;33m'
NC='\e[0m'

d=$(date +"%d%m%y")
sqlbk=SQLbox-backup
databk=DATAbox-backup
ftpbk=FTPbox-backup
disklabel=PenDrive
dbname=nc

function diskHandler()
	{	
		if [[ $1 == "mount" ]]; then
			mkdir -m u=wrx,g=rx,o=rx -p /mnt/backups/ # make ifnotexists dir where disk will be mounted
			mount -L $disklabel /mnt/backups -o umask=0022 # mount disk with permission u=rwx,g=rx,o=rx
			# chek if the disk is correctly mounted
			if [[ $? -ne 0 ]]; then
				errorHandler "out" "Problem to mount the backup volume"
			fi

			mkdir -m 755 -p /mnt/backups/tmp # make ifnotexists the temp dir into the drive
			echo -e "${GREEN}---------- DISK MOUNTED ----------${NC}"

		elif [[ $1 == "unmount" ]]; then
			umount /mnt/backups # unmount disk
			# check if the disk is correctly unmounted
			if [[ $? -ne 0 ]]; then 
				errorHandler "war" "Problem unmounting the disk"
			else
				echo -e "${GREEN}---------- DISK UNMOUNTED ----------${NC}"
			fi
		else
			errorHandler "out" "Command unknown"
		fi
	}

function maintenance()
	{
		# set cloud in maintenance mode 
		if [[ $1 == true ]]; then
			sed -i "s/'maintenance' => false/'maintenance' => true/g" /mnt/data/containers/box/config/config.php
			if [[ $? -ne 0 ]]; then 
				errorHandler "out" "BoxHub is not in maintenance mode"
			fi
			echo -e "${GREEN}---------- MAINTENANCE ON ----------${NC}"
		# remove cloud from maintenance mode
		elif [[ $1 == false ]]; then
			sed -i "s/'maintenance' => true/'maintenance' => false/g" /mnt/data/containers/box/config/config.php
			echo -e "${GREEN}---------- MAINTENANCE OFF ----------${NC}"
		else
			errorHandler "in" "Value unknown"
		fi
	}

function sql_backup()
	{
		echo -e "${GREEN}---------- SQL DUMP STARTED ----------${NC}"
		docker exec homehub_sql_1 sh -c "mysqldump -u root --password='$1' $dbname > ${sqlbk}_$d.sql" # create sql backup
		if [[ $? -ne 0 ]]; then
			errorHandler "in" "Problem creating a database backup"
		fi
		docker cp homehub_sql_1:/${sqlbk}_$d.sql /mnt/backups/tmp/ # copy sql file into host
		if [[ $? -ne 0 ]]; then
			docker exec homehub_sql_1 sh -c "rm /${sqlbk}_$d.sql" # remove sql file from container
			errorHandler "in" "Problem moving the database backup to the host environment"
		fi
		docker exec homehub_sql_1 sh -c "rm /${sqlbk}_$d.sql" # remove sql file from container
		echo -e "${GREEN}---------- SQL DUMP COMPLETED ----------${NC}"
	}

function box_backup()
	{
		echo -e "${GREEN}---------- BOX DATA COPY STARTED ----------${NC}"
		echo
		rsync -Aax --info=progress2 /mnt/data/containers/box/ /mnt/backups/tmp/${databk}_$d/ # copy all nextcloud data
		if [[ $? -ne 0 ]]; then
			errorHandler "in" "Problem creating a backup of boxbox data"
		fi
		echo -e "${GREEN}---------- BOX DATA COPY COMPLETED ---------${NC}"
	}

function ftp_backup()
	{
		echo -e "${GREEN}---------- FTP DATA COPY STARTED ----------${NC}"
		echo
		docker pause homehub_ftp_1 # put docker in pause to make a safe backup
		rsync -Aax --info=progress2 /mnt/data/containers/ftp/ /mnt/backups/tmp/${ftpbk}_$d/ #copy all ftp data
		if [[ $? -ne 0 ]]; then
			docker unpause homehub_ftp_1
			errorHandler "in" "Problem creating a backup of ftpbox data"
		fi
		docker unpause homehub_ftp_1 # exit from pause state
		echo -e "${GREEN}---------- FTP DATA COPY COMPLETED ----------${NC}"
	}

function compress()
	{
		echo -e "${GREEN}---------- DATA COMPRESSION STARTED ----------${NC}"
		echo
		tar -C /mnt/backups/tmp/ -cvf /mnt/backups/homehub-backup_$d.tar ${databk}_$d ${sqlbk}_$d.sql ${ftpbk}_$d # compress data and sql in an archive
		if [[ $? -ne 0 ]]; then
			errorHandler "out" "Problem creating the archive"
		fi
		gzip -4 /mnt/backups/homehub-backup_$d.tar
		if [[ $? -ne 0 ]]; then
			errorHandler "war" "Archive compression problem. Will not be removed but is using more space"
		fi
		echo -e "${GREEN}---------- DATA COMPRESSION COMPLETED ----------${NC}"
	}

function clean()
	{
		echo -e "${GREEN}---------- TEMP DATA CLEANING STARTED ----------${NC}"
		rm -rvf /mnt/backups/tmp/* # delete data and sql in tmp dir
		echo -e "${GREEN}---------- TEMP DATA CLEANING COMPLETED ----------${NC}"
	}

function errorHandler()
	{
		if [[ $1 == "in" ]]; then
			maintenance false
			echo
			clean
			echo
		elif [[ $1 == "war" ]]; then
			echo -e "${YELLOW}Warning: $2${NC}"
			echo
			return
		fi
		diskHandler unmount
		echo -e "${RED}Error: $2${NC}"
		echo -e "${RED}---------- BACKUP NOT COMPLETED ----------${NC}"
		echo
		exit -1
	}

if [[ "$EUID" = 0 ]]; then
	diskHandler mount
	echo # to create a new line
	read -sp "insert db root's password " rootpwd
	echo # to create a new line
	maintenance true
	echo # to create a new line
	sql_backup ${rootpwd}
	echo # to create a new line
	box_backup
	echo # to create a new line
	maintenance false
	echo # to create a new line
	ftp_backup
	echo # to create a new line
	compress
	echo # to create a new line
	clean
	echo # to create a new line
	diskHandler unmount
	echo # to create a new line
else
	echo -e "It must be run as sudo"
fi
