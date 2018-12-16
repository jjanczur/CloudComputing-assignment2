#
# Nginx Dockerfile
# Based on:
# https://github.com/dockerfile/nginx
#

# Pull base image.
FROM debian:stable

# Install Nginx.
RUN \
  apt-get update && \
  apt-get install -y nginx && \
  rm -rf /var/lib/apt/lists/* && \
  echo "\ndaemon off;" >> /etc/nginx/nginx.conf && \
  chown -R www-data:www-data /var/lib/nginx

# MODIFY THIS - FIND PROPER LOCATION FOR NGINX AND USE BIGGER FILE
COPY answers.txt answers.txt

# Define working directory.
WORKDIR /etc/nginx

# Define default command.
CMD ["nginx"]

# Expose ports.
EXPOSE 80
EXPOSE 443