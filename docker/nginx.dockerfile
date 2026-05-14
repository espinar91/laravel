FROM public.ecr.aws/nginx/nginx:latest

# Copiar configuración personalizada
COPY docker/nginx.conf /etc/nginx/conf.d/default.conf

# Nginx necesita tener acceso a los archivos estáticos de la carpeta public de Laravel
WORKDIR /var/www
COPY public ./public

EXPOSE 80
