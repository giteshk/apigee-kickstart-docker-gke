FROM giteshk/drupal8-gcp-docker:latest

WORKDIR /app

COPY . .


RUN composer update -n --no-dev --no-suggest

