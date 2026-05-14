FROM public.ecr.aws/docker/library/php:8.3-fpm-alpine

# Instalar dependencias del sistema y extensiones de PHP requeridas por Laravel
RUN apk add --no-cache libpng-dev libjpeg-turbo-dev freetype-dev zip unzip git bash \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install pdo_mysql gd bcmath opcache

# Copiar Composer desde ECR Public
COPY --from=public.ecr.aws/docker/library/composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www

# Copiar el código fuente de Laravel
COPY . .

# Instalar dependencias de producción y optimizar
#RUN composer install --no-dev --optimize-autoloader
RUN composer install --no-dev --no-scripts --no-autoloader --ignore-platform-reqs

RUN composer dump-autoload --optimize

# Configurar permisos para almacenamiento y caché
RUN chown -R www-data:www-data /var/www/storage /var/www/bootstrap/cache

EXPOSE 9000
CMD ["php-fpm"]
