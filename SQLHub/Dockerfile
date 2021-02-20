# `PiNeSQL` image
# maintainer: luca-lc

# base layer OS: latest mariadb
FROM mariadb:latest


ADD ./handler.sh /handler.sh

# set temporary environment root password
ENV MYSQL_ROOT_PASSWORD tmp_root_pwd

# set temporary environment user name and password
ENV MYSQL_USER temp_user
ENV MYSQL_PASSWORD temp_pswd
ENV MYSQL_DATABASE nc

# set communication port
EXPOSE 3306/tcp
EXPOSE 3306/udp
