#!/bin/bash

d=$(date +"%d%m%y")
sqlbk=SQLbox-backup
databk=DATAbox-backup
ftpbk=FTP-backup
disklabel=
dbname=

function diskHandler()
	{	
		if [[ $1 == "mount" ]]; then
			mkdir -m u=wrx,g=rx,o=rx -p /mnt/backups/ # make ifnotexists dir where disk will be mounted
			mount -L $disklabel /mnt/backups -o umask=0022 # mount disk with permission u=rwx,g=rx,o=rx
			if [[ $? -ne 0 ]]; then # chek if the disk is correctly mounted
				echo -e "Problem to mount the disk\n"
				exit -1
			fi
			mkdir -m 755 -p /mnt/backups/tmp # make ifnotexists the temp dir into the drive
			echo -e "---------- DISK MOUNTED ----------\n"
		
		elif [[ $1 == "unmount" ]]; then
			umount /mnt/backups # unmount disk
			if [[ $? -ne 0 ]]; then # check if the disk is correctly unmounted
				echo "Problem to unmount the disk"
				exit -1
			fi
			echo -e "---------- DISK UNMOUNTED ----------\n"
		
		else
			echo -e "---------- COMMAND UNKNOWN ----------\n" # command unknown
		fi
	}

function maintenance()
	{
		if [[ $1 == true ]]; then
			sed -i "s/'maintenance' => false/'maintenance' => true/g" /mnt/data/containers/box/config/config.php
			echo -e "---------- MAINTENANCE ON ----------\n"
		else
			sed -i "s/'maintenance' => true/'maintenance' => false/g" /mnt/data/containers/box/config/config.php
			echo -e "---------- MAINTENANCE OFF ----------\n"
		fi
	}

function sql_backup()
	{
		echo -e "---------- SQL DUMP STARTED ---------- \n"
		docker exec homehub_sql_1 sh -c "mysqldump -u root --password='$1' $dbname > ${sqlbk}_$d.sql" # create sql backup
		docker cp homehub_sql_1:/${sqlbk}_$d.sql /mnt/backups/tmp/ # copy sql file into host
		docker exec homehub_sql_1 sh -c "rm /${sqlbk}_$d.sql" # remove sql file onto container
		echo -e "---------- SQL DUMP COMPLETED ----------\n"
	}

function box_backup()
	{
		echo -e "---------- BOX DATA COPY STARTED ----------\n"
		rsync -Aavx /mnt/data/containers/box/ /mnt/backups/tmp/${databk}_$d/ # copy all nextcloud data
		echo -e "---------- BOX DATA COPY COMPLETED ---------\n"
	}

function ftp_backup()
	{
		echo -e "---------- FTP DATA COPY STARTED ----------\n"
		rsync -Aavx /mnt/data/containers/ftp/ /mnt/backups/tmp/${ftpbk}_$d/ #copy all ftp data
		echo -e "---------- FTP DATA COPY COMPLETED ----------\n"
	}

function compress()
	{
		echo -e "---------- DATA COMPRESSION STARTED ----------\n"
		tar -I "gzip --best" -C /mnt/backups/tmp/ -cf /mnt/backups/homehub-backup_$d.tar.gz ${databk}_$d ${sqlbk}_$d.sql ${ftpbk}_$d # compress data and sql in an archive
		echo -e "---------- DATA COMPRESSION COMPLETED ----------\n"
	}

function clean()
	{
		echo -e "---------- TEMP DATA CLEANING STARTED ----------\n"
		rm -rf /mnt/backups/tmp/* # delete data and sql in tmp dir
		echo -e "---------- TEMP DATA CLEANING COMPLETED ----------\n"
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
