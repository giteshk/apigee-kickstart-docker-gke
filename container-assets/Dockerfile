FROM gcr.io/google-appengine/php:latest

RUN apt-get update -y
RUN apt-get install zip curl patch git mysql-client -y

# set the document root to web/ folder
ENV DOCUMENT_ROOT /app/code/web
ENV FRONT_CONTROLLER_FILE index.php

# Database environment variables
ENV DRUPAL_DATABASE_NAME ""
ENV DRUPAL_DATABASE_USER ""
ENV DRUPAL_DATABASE_PASSWORD ""
ENV DRUPAL_DATABASE_HOST "127.0.0.1"
ENV DRUPAL_DATABASE_PORT "3306"
ENV DRUPAL_DATABASE_DRIVER "mysql"

WORKDIR /app

COPY code code
COPY drupal-files drupal-files
COPY container-assets container-assets
COPY container-assets/nginx-app.conf nginx-app.conf
COPY container-assets/php.ini php.ini

# Volumes for public, private and temp files
VOLUME /app/code/web/sites/default/files
VOLUME /app/drupal-files/private
VOLUME /app/drupal-files/temp



RUN /app/container-assets/setup-distribution.sh
