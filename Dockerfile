FROM php:8.2-fpm

# 1. Agrega libzip-dev al final de esta lista
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    unzip \
    zip \
    libzip-dev

# Limpiar caché
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# 2. Agrega zip a la lista de extensiones de PHP
RUN docker-php-ext-install pdo pdo_mysql pdo_pgsql mbstring exif pcntl bcmath gd zip xml curl 

# Obtener Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copiar el código del proyecto
WORKDIR /var/www
COPY . .

# Instalar dependencias de Laravel
RUN composer install --optimize-autoloader --no-dev

# Permisos para carpetas de almacenamiento y caché
RUN chown -R www-data:www-data /var/www/storage /var/www/bootstrap/cache

# Comando por defecto usando la variable de Render
CMD php artisan serve --host=0.0.0.0 --port=$PORT