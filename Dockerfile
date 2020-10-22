FROM alpine:3.12
LABEL description="nginx + php image based on Alpine 3.12" \
      maintainer="daxuxu" 

ENV UPLOAD_MAX_SIZE=10G \
    APC_SHM_SIZE=128M \
    OPCACHE_MEM_SIZE=128 \
    MEMORY_LIMIT=512M \
    CRON_PERIOD=15m \
    CRON_MEMORY_LIMIT=1g \
    TZ=Asia/Shanghai \
    DOMAIN=localhost


ARG BUILD_DEPS="build-dependencies \
    gnupg \
    tar \
    build-base \
    autoconf \
    automake \
    pcre-dev \
    libtool \
    samba-dev \
    imagemagick-dev \
    libressl \
    ca-certificates \
    libsmbclient \
    tzdata \
    imagemagick "
RUN  sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
  && apk update \
  && apk add -t ${BUILD_DEPS} tzdata curl libevent \
  && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
  && apk add --no-cache php7 \
        php7-ctype php7-curl php7-json php7-fileinfo php7-iconv \
        php7-mbstring php7-openssl php7-pcntl php7-pdo php7-pdo_mysql \
        php7-posix php7-session php7-pecl-event php7-pecl-redis  php7-curl \
        php7-pecl-mcrypt php7-sqlite3 php7-gd php7-opcache php7-iconv php7-xmlrpc php7-json \
        php7-dom php7-exif php7-mysqli php7-session php7-xml php7-fpm nginx s6 curl php7-dev \
  && rm /etc/nginx/conf.d/default.conf \
  && wget http://pear.php.net/go-pear.phar -O go-pear.php \
  && php go-pear.php \
  && pecl install yaconf \
  && echo 'extension=yaconf.so' >> /etc/php7/conf.d/yaconf.ini \
  && echo 'yaconf.directory="/webser/www/code_conf"'>> /etc/php7/conf.d/yaconf.ini \
  && echo 'yaconf.check_delay=10' >> /etc/php7/conf.d/yaconf.ini \
  && apk del tzdata ${BUILD_DEPS}  php7-dev

# Configure nginx

# Configure PHP-FPM
COPY config/fpm-pool.conf /etc/php7/php-fpm.d/www.conf
COPY config/php.ini /etc/php7/conf.d/custom.ini


# Setup document root
RUN mkdir -p /webser/www/code_conf/  /etc/s6 /run/nginx/ /etc/nginx/ssl \
  && mkdir -p /var/www/html/ \
  && mkdir -p /var/log/php7/session \
  && chown -R nobody.nobody /webser/www/ /var/www/html/ \
  && chown -R nobody.nobody /run \
  && chown -R nobody.nobody /var/lib/nginx \
  && chown -R nobody.nobody /var/log/nginx

# Add application
WORKDIR /webser/www/
COPY --chown=nobody src/ /var/www/html/
COPY --chown=nobody rootfs/etc/s6.d /etc/s6
COPY rootfs/etc/nginx/conf/nginx.conf /etc/nginx/nginx.conf
COPY rootfs/etc/nginx/conf.d/test.conf /etc/nginx/conf.d/test.conf
COPY rootfs/run.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/run.sh \
  && chmod +x /etc/s6/nginx/run \
  && chmod +x  /etc/s6/php/run

# Expose the port nginx is reachable on
# EXPOSE 8080



# Configure a healthcheck to validate that everything is up&running
#HEALTHCHECK --timeout=10s CMD curl --silent --fail http://127.0.0.1:8080/fpm-ping

CMD ["run.sh"]


