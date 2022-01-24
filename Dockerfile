FROM alpine/git:latest as clone
LABEL maintainer="Ztj <ztj1993@gmail.com>"
RUN git clone --branch 0.6 https://github.com/Rarst/release-belt.git /srv

FROM composer:1.6 as install
LABEL maintainer="Ztj <ztj1993@gmail.com>"
COPY --from=clone /srv /srv
WORKDIR /srv
RUN composer belt-update
RUN rm -rf /srv/.git

FROM php:7.3-apache
LABEL maintainer="Ztj <ztj1993@gmail.com>"
COPY --from=install /srv /srv
RUN a2enmod rewrite
RUN rm -rf /var/www/html && ln -s /srv/public /var/www/html
COPY .htaccess /srv/public/
WORKDIR /srv/releases
