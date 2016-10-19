FROM php:7-fpm-alpine

ENV PHPREDIS_VERSION 3.0.0

RUN mkdir -p /usr/src/php/ext/redis \
    && curl -L https://github.com/phpredis/phpredis/archive/$PHPREDIS_VERSION.tar.gz | tar xvz -C /usr/src/php/ext/redis --strip 1 \
    && echo 'redis' >> /usr/src/php-available-exts \
    && docker-php-ext-install redis \
	&& docker-php-ext-install opcache

RUN apk upgrade --update && apk add \
  coreutils \
  freetype-dev \
  libjpeg-turbo-dev \
  libltdl \
  libpng-dev \
&& docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
&& docker-php-ext-install gd

RUN curl https://getcomposer.org/installer > composer-setup.php && php composer-setup.php && mv composer.phar /usr/local/bin/composer && rm composer-setup.php

RUN composer global require "hirak/prestissimo:^0.3"

RUN rm -rf /root/.composer/cache

WORKDIR /var/www

EXPOSE 9000

CMD ["php-fpm"]