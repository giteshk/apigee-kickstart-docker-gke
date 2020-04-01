#!/bin/bash

if [ ! -d /app/code/vendor ]; then
    composer install --working-dir=/app/code
    # remove embeded git repositories
    find /app/code -mindepth 2 -type d -name .git | xargs rm -rf
fi

cp /app/container-assets/drush.sh /usr/local/bin/drush && chmod 775 /usr/local/bin/drush

# Use the settings file which has been parameterized using Environment variables
cp -f /app/container-assets/parameterized.settings.php /app/code/web/sites/default/settings.php

# fix permissions
chown -R www-data.www-data /app/code/web/sites/default/settings.php \
    && chmod -R 755 /app/code/web/sites/default/settings.php

ln -sf drupal-files/public code/web/sites/default/files

#create the file system for public, private, temp files
mkdir -p /app/drupal-files/public \
    && mkdir -p /app/drupal-files/private \
    && mkdir -p /app/drupal-files/temp

chown -R www-data.www-data  /app/drupal-files/public \
    && chmod -R 755  /app/drupal-files/public \
    && chown -R www-data.www-data /app/drupal-files/private \
    && chmod -R 755 /app/drupal-files/private \
    && chown -R www-data.www-data /app/drupal-files/temp \
    && chmod -R 755 /app/drupal-files/temp
