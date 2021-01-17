#!/bin/bash

##
## READ CONFIG FILE
##
. /home/configFile.conf

##
## SETTING-UP THE USERS
loop=1
while[[ $loop -le $nusers ]]
do
	if [[ -z "$uname$loop" || -z "$upass$loop" ]]; then
		echo -e "Impossible to proceed: invalid name or password for $uname$loop"
	else
		useradd -ms /bin/bash -p "$(openssl passwd -1 $upass$loop)" -U $uname$loop # creation of the user and his home
	fi
done