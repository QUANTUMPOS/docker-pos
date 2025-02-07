FROM php:8.1-apache

ENV APACHE_DOCUMENT_ROOT=/var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# Install required PHP extensions
RUN apt-get update && apt-get install -y \
    libpng-dev libjpeg-dev libfreetype6-dev zip unzip git curl \
    build-essential libssl-dev libzip-dev supervisor && \
    docker-php-ext-install pdo pdo_mysql gd zip mysqli && \
    docker-php-ext-enable mysqli

# Install Node.js (for NexoPOS frontend assets)
RUN curl -sL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs

# Install Yarn (optional, if your app uses Yarn)
RUN npm install -g yarn

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
# WORKDIR /var/www/html

# Copy application files
# RUN git config --global --add safe.directory /var/www/html
# ARG GITHUB_TOKEN

RUN git clone https://GITHUB_TOKEN@github.com/QUANTUMPOS/quantum-pos.git /var/www/html
# COPY . .


# Install dependencies
RUN composer install --no-dev --optimize-autoloader

RUN npm install && npm run prod

# Set correct permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# Create Supervisor config directory
RUN mkdir -p /etc/supervisor/conf.d

# Expose port 80
EXPOSE 80

# Add Supervisor configuration file
COPY supervisor.conf /etc/supervisor/conf.d/supervisord.conf
