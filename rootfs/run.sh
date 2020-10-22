#!/bin/sh

sed -i -e "s/<UPLOAD_MAX_SIZE>/$UPLOAD_MAX_SIZE/g" /etc/nginx/nginx.conf /etc/php7/php-fpm.d/www.conf \
       -e "s/<MEMORY_LIMIT>/$MEMORY_LIMIT/g" /etc/php7/php-fpm.d/www.conf

chown -R nobody:nobody /webser/www/ 

/bin/s6-svscan /etc/s6