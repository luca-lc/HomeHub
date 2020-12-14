#!/bin/bash

# read config file
. /home/configFile.conf

# guest user creations
useradd -ms /bin/bash -p "$(openssl passwd -1 $gpassword)" -U $gname

# user1 creations
useradd -ms /bin/bash -p "$(openssl passwd -1 $upassword)" -U $uname