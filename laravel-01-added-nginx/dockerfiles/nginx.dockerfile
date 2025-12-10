FROM nginx:stable-alpine

WORKDIR /etc/nginx/conf.d

COPY nginx/nginx.conf .

# Rename the file name
RUN mv nginx.conf default.conf 

# Here, We switch our working directory 
WORKDIR /var/www/html

COPY src .