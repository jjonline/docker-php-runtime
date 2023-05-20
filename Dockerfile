# source file  at: https://github.com/jjonline/docker-php-runtime
# docker image at: https://hub.docker.com/r/jjonline/docker-php-runtime

# define php version args
# Be used to base Image need before FROM
# if args used after FROM, should repeat define
ARG phpVersion='7.2'

FROM php:$phpVersion-fpm-alpine

# define install extension info
ARG extension=''
# define install MySQL when php5
ARG extMysql=''
# define need enable extension
ARG extEnable=''

LABEL Maintainer="JeaYang<jjonline@jjonline.cn>" \
      Description="Nginx & PHP & FPM & Supervisor & Composer based on Alpine Linux support multi PHP version."

# Basic workdir
WORKDIR /srv

# add installer
ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

    # ① install lib and software
RUN apk update && \
    apk add libpng libpng-dev \
    gmp gmp-dev \
    zlib zlib-dev  \
    oniguruma oniguruma-dev  \
    libjpeg-turbo-dev libpng-dev  \
    freetype-dev libzip libzip-dev  \
    libxslt libxslt-dev \
    libxpm libxpm-dev \
    libvpx libvpx-dev \
    libwebp libwebp-dev \
    linux-headers \
    supervisor nginx bash && \
    chmod +x /usr/local/bin/install-php-extensions && \
    # ② install built-in extension
    docker-php-ext-install -j5 pcntl bcmath gmp mbstring $extMysql mysqli pdo pdo_mysql opcache sockets xsl zip exif && \
    # ③ install built-in extension
    install-php-extensions $extension && \
    docker-php-ext-enable $extEnable && \
    # ④ install composer2
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
    # ⑤ clean
    rm -rf /var/cache/apk/* && rm -rf /etc/nginx/sites-enabled/*
