FROM php:8.1-apache

# Install required PHP extensions for Yellow CMS
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libgd-dev \
    libzip-dev \
    libonig-dev \
    && docker-php-ext-install curl gd mbstring zip \
    && rm -rf /var/lib/apt/lists/*

# Enable Apache rewrite module
RUN a2enmod rewrite

# CRITICAL: Enable .htaccess files (AllowOverride All)
RUN sed -i '/<Directory \/var\/www\/>/,/<\/Directory>/ s/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf

COPY . /var/www/html/

# Set proper permissions
RUN chown -R www-data:www-data /var/www/html/ \
    && chmod -R 755 /var/www/html/ \
    && chmod -R a+rw /var/www/html/content \
    && chmod -R a+rw /var/www/html/system

EXPOSE 80