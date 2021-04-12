# `SQLHub` image
# maintainer: luca-lc

# base layer OS: latest mariadb
FROM mariadb:latest


ADD ./handler.sh /handler.sh

ADD ./my.cnf /etc/mysql/my.cnf

# set temporary environment root password
ENV MYSQL_ROOT_PASSWORD tmp_root

# set temporary environment
# ENV MYSQL_PASSWORD tmp_pswd
# ENV MYSQL_DATABASE nc

# set communication port
EXPOSE 3306/tcp


# DO NOT MODIFY 'MYSQL_USER'
# ENV MYSQL_USER sqlhubUser 
