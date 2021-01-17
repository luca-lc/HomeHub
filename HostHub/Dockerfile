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

# install tools
RUN apt install -y pkg-config build-essential autoconf bison re2c libxml2-dev libsqlite3-dev 

# download tar software
RUN wget https://www.php.net/distributions/php-8.0.0.tar.gz -O /home/php8.tar.gz
RUN tar -zxvf /home/php8.tar.gz -C /home && rm /home/php8.tar.gz
RUN cd /home/php-8.0.0/ && ./buildconf && ./configure && make -j4 && make test && make install


# system update
RUN apt-get update && \
		apt-get full-upgrade -y

#install php version 7.3
# RUN apt-get install -y php7.3-*
# RUN apt-get install -y libapache2-mod-php7.3

#set hostname
RUN echo "ServerName hosthub" >> /etc/apache2/apache2.conf

RUN a2enmod rewrite

# create environment
RUN mkdir -p /var/www/html
COPY vhost/000-default.conf /etc/apache2/sites-enabled/000-default.conf
COPY 404.html /var/www/html/404.html
COPY index.html /var/www/html/index.html

#start apache2 service in foreground
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
# CMD tail -f /dev/null