# `FTPPiNe` image
# maintainer: luca-lc

# base layer OS: latest Debian
FROM debian:latest

# update repository and install wget tool
RUN apt-get update && apt-get install -y wget

# set lang
RUN apt-get update && apt-get install -y locales && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8

#install ftp server and openssl 
RUN apt update
RUN apt-get install -y vsftpd && apt-get install -y openssl

# copy the environment variables file and configuration script
# copy the ftp server configuration file and allowed users file
COPY ./conf/configFile.conf /home/configFile.conf
COPY ./conf/config.sh /home/config.sh
COPY ./conf/vsftpd.conf /etc/vsftpd.conf
COPY ./conf/vsftpd.userlist /etc/vsftpd.userlist


# set permissions for the script and config file
RUN chmod 755 /home/config.sh && chmod 755 /home/configFile.conf && /home/config.sh

# set exposing ports
EXPOSE 20 21

# create the ftp directory
RUN mkdir /home/ftp

CMD ["/usr/sbin/vsftpd"]
# CMD tail -f /dev/null