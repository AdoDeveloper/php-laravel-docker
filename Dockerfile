FROM richarvey/nginx-php-fpm:3.1.6

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

# Instalar el módulo zip y otras extensiones necesarias para Laravel
RUN apk update && apk add --no-cache libzip-dev \
    && docker-php-ext-install zip \
    && docker-php-ext-enable zip

# Ejecutar el script de inicio
CMD ["/start.sh"]
