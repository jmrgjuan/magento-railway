FROM php:8.3-fpm

# Install system packages needed for Magento + composer
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    unzip \
    libzip-dev \
    libicu-dev \
    libonig-dev \
    libxml2-dev \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    zlib1g-dev \
    libxslt1-dev \
    libjpeg62-turbo-dev \
    libwebp-dev \
    libssl-dev \
    libcurl4-openssl-dev \
    && rm -rf /var/lib/apt/lists/*

# Install PHP extensions required by Magento
RUN docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-install -j$(nproc) \
        bcmath \
        ctype \
        curl \
        dom \
        fileinfo \
        gd \
        intl \
        mbstring \
        opcache \
        pdo_mysql \
        soap \
        xsl \
        zip

# Install Composer (stable) and set path
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Create working directory
WORKDIR /var/www/html

# Copy helper scripts into image (Unix/bash versions)
COPY scripts/unix /usr/local/bin/scripts
RUN chmod +x /usr/local/bin/scripts/*.sh

# Ensure www-data owns the project files
RUN chown -R www-data:www-data /var/www/html

# Default entrypoint: starts php-fpm
CMD ["php-fpm"]
