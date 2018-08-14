FROM php:7.1-apache

RUN docker-php-ext-install mysqli && docker-php-ext-configure mysqli && docker-php-ext-enable mysqli

RUN sudo a2enmod rewrite
