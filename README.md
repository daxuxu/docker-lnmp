# Docker PHP-FPM 7.3 & Nginx 1.18 on Alpine Linux
在 [Alpine Linux](https://www.alpinelinux.org/)基础上进行编译,php7.3+nginx1.18,支持yaconf，redis，mysql等，体积仅仅50MB +/-,采用S6/s6-svscan 进行进程管理

### yaconf 配置目录
yaconf.directory	/webser/www/code_conf


### 使用方法
启动容器(简单启动):
    docker run -d -p 80:8080 daxuxu/nginx-php73

启动容器:映射代码目录
    docker run -p 80:8080 -v /webser/www/:/webser/www/ daxuxu/nginx-php73


使用docker-compose启动容器:




