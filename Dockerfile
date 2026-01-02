FROM php:8.3-apache

RUN apt-get update && apt-get install -y wget \
    && sed -i 's/Listen 127.0.0.1:80/Listen 80/' /etc/apache2/ports.conf \
    && a2enmod rewrite \
    && echo "ServerName localhost" >> /etc/apache2/apache2.conf

COPY . /var/www/html/
RUN mkdir -p /var/www/html/content \
    && chown -R www-data:www-data /var/www/html/ \
    && chmod -R 755 /var/www/html/content

EXPOSE 80

# Built-in healthcheck (no wget needed)
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost/ || wget --no-verbose --tries=1 --spider http://localhost/ || exit 1
