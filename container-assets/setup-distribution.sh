#!/bin/bash

if [ ! -d /app/code/vendor ]; then
    composer install --working-dir=/app/code
    # remove embeded git repositories
    find /app/code -mindepth 2 -type d -name .git | xargs rm -rf
fi

cp /app/container-assets/drush.sh /usr/local/bin/drush && chmod 755 /usr/local/bin/drush

#create the file system for public, private, temp files
mkdir -p /app/code/web/sites/default/files \
    && mkdir -p /app/drupal-files/private \
    && mkdir -p /app/drupal-files/config \
    && mkdir -p /app/drupal-files/temp

# fix permissions
if [ "${LOCAL_SETUP}" = "true" ]; then
  chmod -R 777 /app/
else
  chown -R www-data:www-data /app/ \
      && chmod -R 550 /app/
fi
