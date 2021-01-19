#!/bin/bash

##
## READ CONFIG FILE
##
. /home/configFile.conf

##
## SETTING-UP THE USERS
loop=1
while [ $loop -le $nusers ]
do
	name=uname$loop
	pswd=upass$loop
	if [[ -z "${!name}" || -z "${!pswd}" ]]; then
		echo -e "Impossible to proceed: invalid name or password for ${!name}"
	else
		useradd -ms /bin/bash -p "$(openssl passwd -1 ${!pswd})" -U ${!name} # creation of the user and his home
		echo "${!name}" >> /etc/vsftpd.userlist
	fi

	((loop=loop+1))
done

rm /home/configFile.conf