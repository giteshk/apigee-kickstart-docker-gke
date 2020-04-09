# Copyright 2020 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

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

ENV DRUPAL_FILE_PUBLIC_PATH "sites/default/files"
ENV DRUPAL_FILE_PRIVATE_PATH "/app/drupal-files/private"
ENV DRUPAL_FILE_TEMP_PATH "/app/drupal-files/temp"
ENV DRUPAL_CONFIG_SYNC_DIR "/app/drupal-files/config"

WORKDIR /app

COPY --chown=www-data:www-data code code
COPY drupal-files drupal-files
COPY container-assets container-assets
COPY container-assets/nginx-app.conf nginx-app.conf
COPY container-assets/php.ini php.ini

# Volumes for public, private and temp files
VOLUME /app/code/web/sites/default/files
VOLUME /app/drupal-files/private
VOLUME /app/drupal-files/temp
VOLUME /app/drupal-files/config


RUN /app/container-assets/setup-distribution.sh

CMD ["/app/container-assets/startup.sh"]