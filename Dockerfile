FROM php:8.3-apache

# Listen on all interfaces (0.0.0.0)
RUN sed -i 's/Listen 127.0.0.1:80/Listen 80/' /etc/apache2/ports.conf \
    && sed -i 's/Listen 127.0.0.1:443/Listen 443/' /etc/apache2/ports.conf \
    && a2enmod rewrite \
    && echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Copy files
COPY . /var/www/html/

# Permissions for Yellow CMS
RUN mkdir -p /var/www/html/content \
    && chown -R www-data:www-data /var/www/html/ \
    && chmod -R 755 /var/www/html/content

EXPOSE 80
