FROM php:8.2.4-fpm-alpine

WORKDIR /var/www/html

COPY src .

RUN docker-php-ext-install pdo pdo_mysql

# Chown: change owenership (of a file or folder).
# in the php the default user is www-data
RUN chown -R www-data:www-data /var/www/html
