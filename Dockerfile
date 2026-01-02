FROM php:8.3-apache

RUN apt-get update && apt-get install -y \
    libgd-dev \
    libzip-dev \
    && docker-php-ext-install gd zip \
    && a2enmod rewrite \
    && echo "ServerName localhost" >> /etc/apache2/apache2.conf \
    && rm -rf /var/lib/apt/lists/*

# Ensure Apache listens on all interfaces (not just localhost)
RUN sed -i 's/Listen 80/Listen 0.0.0.0:80/' /etc/apache2/ports.conf

COPY . /var/www/html/

# Create index.php that loads Yellow CMS if it doesn't exist
RUN if [ ! -f /var/www/html/index.php ]; then \
    echo '<?php require "yellow.php"; ?>' > /var/www/html/index.php; \
    fi

RUN chown -R www-data:www-data /var/www/html/ \
    && chmod -R 755 /var/www/html/

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=10s --start-period=10s --retries=3 \
    CMD php -r "exit(file_get_contents('http://localhost/') ? 0 : 1);" || exit 1