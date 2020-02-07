FROM giteshk/drupal8-gcp-docker:latest

WORKDIR /app

COPY . .

RUN composer require apigee/apigee_devportal_kickstart


