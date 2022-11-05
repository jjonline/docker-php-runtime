ARG PHP_VERSION=7.2
FROM php:$PHP_VERSION-fpm-alpine

LABEL Maintainer="JeaYaNG<jjonline@jjonline.cn>" Description="Nginx & PHP-FPM 8.0 based on Alpine Linux."

# Basic workdir
WORKDIR /srv

# Install php extension supervisor and nginx
RUN apk update && \
	apk add libpng libpng-dev gmp gmp-dev zlib zlib-dev oniguruma oniguruma-dev libjpeg-turbo-dev libpng-dev freetype-dev libzip libzip-dev libxslt libxslt-dev supervisor nginx bash && \
	docker-php-ext-configure gd && \
	yes "" | pecl install redis && \
	yes "" | pecl install xlswriter && \
	docker-php-ext-install -j5 bcmath gd gmp mbstring mysqli pdo pdo_mysql opcache sockets xsl zip exif && \
    docker-php-ext-enable redis xlswriter && \
	rm -rf /var/cache/apk/* && \
	rm -rf /etc/nginx/sites-enabled/* && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer