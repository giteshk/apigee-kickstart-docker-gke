FROM giteshk/drupal8-gcp-docker:latest

WORKDIR /app

COPY . .

RUN composer install --no-dev

