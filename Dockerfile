FROM php:7.1-fpm

ENV PHPREDIS_VERSION 3.1.4

RUN apt-get update && apt-get install -y git zip unzip && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN mkdir -p /usr/src/php/ext/redis \
    && curl -L https://github.com/phpredis/phpredis/archive/$PHPREDIS_VERSION.tar.gz | tar xvz -C /usr/src/php/ext/redis --strip 1 \
    && echo 'redis' >> /usr/src/php-available-exts \
    && apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng-dev \
    && docker-php-ext-install redis \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install opcache \
    && docker-php-ext-install pcntl

RUN curl https://getcomposer.org/installer > composer-setup.php && php composer-setup.php && mv composer.phar /usr/local/bin/composer && rm composer-setup.php

RUN composer global require --prefer-source "hirak/prestissimo:^0.3"

RUN rm -rf /root/.composer/cache

RUN curl https://getcaddy.com | bash -s personal http.cors,http.expires,http.git,http.grpc,http.realip

WORKDIR /var/www

EXPOSE 9000

CMD ["php-fpm"]
