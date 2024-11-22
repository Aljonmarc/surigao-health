# Use an official PHP image with Composer
FROM php:8.3-fpm

# Install system dependencies, including PostgreSQL client and extensions
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    curl \
    libpq-dev \
    libonig-dev \
    libzip-dev \
    zip \
    libpng-dev \
    && docker-php-ext-install pdo pdo_pgsql mbstring zip gd

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Set working directory
WORKDIR /var/www/html

# Copy project files
COPY . .

# Install PHP dependencies
RUN composer install --no-dev --optimize-autoloader

# Install Node.js dependencies and build assets
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && apt-get install -y nodejs
RUN npm install && npm run build

EXPOSE 4000


# Start the Laravel server
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=4000"]
