# `PiNeSites` image
# maintainer: luca-lc

# base layer OS: latest Debian
FROM debian:latest

# update & install utilities
RUN apt-get update && \
		apt-get install -y wget 
RUN apt-get update && \
		apt-get install -y locales && \
	 	localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8

# install and set apache2
RUN apt-get update && \
 		apt-get install -y apache2

# install repository for php
RUN apt -y install lsb-release apt-transport-https ca-certificates && \
		wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg && \
		echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/php7.3.list 

# system update
RUN apt-get update && \
		apt-get full-upgrade -y

#install php version 7.3
RUN apt-get install -y php7.3-*
RUN apt-get install -y libapache2-mod-php7.3

#set hostname
RUN echo "ServerName PiNet" >> /etc/apache2/apache2.conf

#start apache2 service in foreground
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
# CMD tail -f /dev/null