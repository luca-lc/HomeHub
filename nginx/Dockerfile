# `PiNe:proxy` image
# maintainer: luca-lc

# base layer OS: latest nginx
FROM nginx:latest

# create directory for encryption keys and certs 
RUN mkdir -p /etc/ssl/keys
RUN mkdir -p /etc/ssl/certs

# copy certificate and key from host to image
COPY ssl/nginx-selfsigned.crt /etc/ssl/certs/nginx-selfsigned.crt
COPY ssl/nginx-selfsigned.key /etc/ssl/keys/nginx-selfsigned.key

# copy nginx configuration from host to image
COPY conf/nginx.conf /etc/nginx/conf.d/default.conf