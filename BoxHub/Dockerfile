# `BoxHub` image
# maintainer: luca-lc

# base layer OS: latest nextcloud
FROM nextcloud:latest

# ADD ./config.php /config/config.php

RUN apt-get update && \
		apt-get full-upgrade -y

# RUN apt install -y pkg-config build-essential autoconf bison re2c libxml2-dev libsqlite3-dev 

# # RUN a2enmod proxy_fcgi setenvif
# # # RUN a2enconf php7.4-fpm
# # RUN a2dismod php7
# # RUN a2dismod mpm_prefork
# # RUN a2enmod mpm_event
# # RUN a2enmod http2

ENV NEXTCLOUD_UPDATE=1