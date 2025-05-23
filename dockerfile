# Use official PHP image with Apache
FROM php:8.1-apache

# Install required dependencies (including Tesseract OCR)
RUN apt-get update && apt-get install -y \
    tesseract-ocr \
    libtesseract-dev \
    libleptonica-dev \
    pkg-config \
    git \
    unzip \
    && docker-php-ext-install pdo pdo_mysql

# Enable Apache mod_rewrite (optional, useful if you use pretty URLs)
RUN a2enmod rewrite

# Copy your PHP app source code into the container
COPY . /var/www/html/

# Set working directory
WORKDIR /var/www/html

# Install Composer and dependencies
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
RUN composer install --no-dev --optimize-autoloader

# Expose port 80 for the web server
EXPOSE 80

# Start Apache in foreground
CMD ["apache2-foreground"]
