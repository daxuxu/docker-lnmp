# Docker PHP-FPM 7.3 & Nginx 1.18 on Alpine Linux
在 [Alpine Linux](https://www.alpinelinux.org/)基础上进行编译,php7.3+nginx1.18,支持yaconf，redis，mysql等，体积仅仅50MB +/-,采用S6/s6-svscan 进行进程管理


![nginx 1.18.0](https://img.shields.io/badge/nginx-1.18-brightgreen.svg)
![php 7.3.23](https://img.shields.io/badge/php-7.3-brightgreen.svg)


### yaconf 配置目录
yaconf.directory	/webser/www/code_conf


### 使用方法
拉取容器：
    ```
        docker pull daxuxu/nginx-php73
    ```

启动容器(简单启动):
    ```
    docker run -d -p 80:8080 daxuxu/nginx-php73
    ```

启动容器:映射代码目录:
    ```
    docker run -p 80:8080 -v /webser/www/:/webser/www/ daxuxu/nginx-php73
    ```


使用docker-compose启动容器:
```
version: '3'

networks:
  lnmp_network:
    external: false

services:
  nginx-php73:
    image: nginx-php73
    environment:
      - UPLOAD_MAX_SIZE=10G

    volumes:
      - /path/to/mycodedir/:/webser/www/
      - /path/to/myssl/server.crt:/etc/nginx/ssl/server.crt
      - /path/to/myssl/key:/etc/nginx/ssl/server.key
      - /path/to/myngxcfg/sitename.conf:/etc/nginx/conf.d/sitename.conf
    networks:
      - lnmp_network
    ports:
      - "10443:443"
	  - "10080:80"
```



