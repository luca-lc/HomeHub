#!/bin/bash

# read config file
. /home/configFile.conf
# . ./configFile.conf

if [[ -z "$gpassword" || -z "$gname" ]]; then
	echo -e "Impossible to proceed: invalid name or password"
else
	useradd -ms /bin/bash -p "$(openssl passwd -1 $gpassword)" -U $gname
fi

# guest user creations
#useradd -ms /bin/bash -p "$(openssl passwd -1 $gpassword)" -U $gname

# user1 creations
# useradd -ms /bin/bash -p "$(openssl passwd -1 $upassword)" -U $uname