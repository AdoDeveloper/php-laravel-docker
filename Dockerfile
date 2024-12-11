# Imagen base con Nginx y PHP-FPM
FROM richarvey/nginx-php-fpm:3.1.6

# Establecer directorio de trabajo
WORKDIR /var/www/html

# Copiar el contenido del proyecto al contenedor
COPY . .

# Configuración de la imagen
ENV SKIP_COMPOSER 1
ENV WEBROOT /var/www/html/public
ENV PHP_ERRORS_STDERR 1
ENV RUN_SCRIPTS 1
ENV REAL_IP_HEADER 1

# Configuración de Laravel
ENV APP_ENV production
ENV APP_DEBUG false
ENV LOG_CHANNEL stderr

# Permitir que Composer se ejecute como superusuario
ENV COMPOSER_ALLOW_SUPERUSER 1

# Instalar dependencias necesarias para Laravel y PHP
RUN apk update && apk add --no-cache \
    libzip-dev libpng-dev libjpeg-turbo-dev libwebp-dev zlib-dev libxpm-dev \
    && docker-php-ext-install zip gd pdo pdo_mysql bcmath \
    && docker-php-ext-enable zip gd

# Instalar Composer globalmente
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Configurar permisos para Laravel
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# Instalar dependencias de Composer
RUN composer install --optimize-autoloader --no-dev

# Limpiar caché de APK para reducir el tamaño de la imagen
RUN rm -rf /var/cache/apk/*

# Compilar configuración de Laravel
RUN php artisan config:cache \
    && php artisan route:cache \
    && php artisan view:cache

# Ejecutar el script de inicio (inicia Nginx y PHP-FPM)
CMD ["/start.sh"]
