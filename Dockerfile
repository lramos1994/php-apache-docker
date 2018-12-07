FROM php:7.1-apache

RUN docker-php-ext-install mysqli && docker-php-ext-configure mysqli && docker-php-ext-enable mysqli

RUN apt-get update && apt-get install -y libpq-dev libmemcached-dev curl libz-dev libpng-dev libfreetype6-dev libjpeg-dev libxpm-dev libxml2-dev libxslt-dev libmcrypt-dev libwebp-dev

# Install Memcached for php 7
RUN curl -L -o /tmp/memcached.tar.gz "https://github.com/php-memcached-dev/php-memcached/archive/php7.tar.gz" \
    && mkdir -p /usr/src/php/ext/memcached \
    && tar -C /usr/src/php/ext/memcached -zxvf /tmp/memcached.tar.gz --strip 1 \
    && docker-php-ext-configure memcached \
    && docker-php-ext-install memcached \
    && rm /tmp/memcached.tar.gz

ENV APACHE_DOC_ROOT=/var/www/html
RUN sed -ri -e 's!/var/www/html!${APACHE_DOC_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOC_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

RUN docker-php-ext-install soap && docker-php-ext-configure soap && docker-php-ext-enable soap
RUN docker-php-ext-install pdo_mysql && docker-php-ext-configure pdo_mysql && docker-php-ext-enable pdo_mysql
RUN docker-php-ext-configure gd \
    --with-freetype-dir=/usr/include/ \
    --with-jpeg-dir=/usr/include/ \
    --with-xpm-dir=/usr/include \
    --with-webp-dir=/usr/include/ && docker-php-ext-install gd && docker-php-ext-enable gd
RUN docker-php-ext-install zip && docker-php-ext-configure zip && docker-php-ext-enable zip
RUN docker-php-ext-install dom  && docker-php-ext-configure dom && docker-php-ext-enable dom
RUN docker-php-ext-install xml && docker-php-ext-configure xml && docker-php-ext-enable xml

RUN apt-get update && \
    apt-get install -y --no-install-recommends git zip wget cron

RUN curl --silent --show-error https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer

RUN a2enmod rewrite
RUN a2enmod expires

COPY "memory-limit-php.ini" "/usr/local/etc/php/conf.d/memory-limit-php.ini"
CMD ["cron -f"]
