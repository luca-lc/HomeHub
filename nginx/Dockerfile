# `proxy` image
# maintainer: luca-lc

# base layer OS: latest nginx
FROM nginx:latest

# create directory for encryption keys and certs 
RUN mkdir -p /etc/ssl/keys
RUN mkdir -p /etc/ssl/certs

# install openssl
RUN apt update && apt install openssl


# create ssl protocol
RUN mkdir -p /etc/nginx/ssl/
RUN openssl ecparam -genkey -name prime256v1 -out /etc/nginx/ssl/privkey.key
RUN openssl req -new -key /etc/nginx/ssl/privkey.key -out /etc/nginx/ssl/csr.pem -subj "/C=IT/ST=Tuscany/L=Pisa/O=HomeHub/OU=HA/CN=."
RUN openssl req -x509 -nodes -days 3650 -key /etc/nginx/ssl/privkey.key -in /etc/nginx/ssl/csr.pem -out /etc/nginx/ssl/certificate.pem
# insert dh key
RUN chmod 600 /etc/nginx/ssl/*

# copy configuration files into the image
COPY index.html /home/www/index.html
COPY conf/nginx.conf /etc/nginx/conf.d/default.conf
COPY 404.html /home/www/404.html