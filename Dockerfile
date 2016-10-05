FROM php:7-fpm-alpine

ENV PHPREDIS_VERSION 3.0.0

RUN mkdir -p /usr/src/php/ext/redis \
    && curl -L https://github.com/phpredis/phpredis/archive/$PHPREDIS_VERSION.tar.gz | tar xvz -C /usr/src/php/ext/redis --strip 1 \
    && echo 'redis' >> /usr/src/php-available-exts \
    && docker-php-ext-install redis \
    && docker-php-ext-enable redis

RUN echo 'opcache' >> /usr/src/php-available-exts \
    && docker-php-ext-install opcache \
    && docker-php-ext-enable opcache

WORKDIR /var/www

EXPOSE 9000

CMD ["php-fpm"]