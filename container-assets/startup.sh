#!/bin/bash

set -xe

# Use the settings file which has been parameterized using Environment variables
cp -f /app/container-assets/parameterized.settings.php /app/code/web/sites/default/settings.php

if [ "${LOCAL_SETUP}" = "true" ]; then
  chmod -R 777 /app/drupal-files /app/code/web/sites/default/files
else
  chown -R www-data:www-data /app/drupal-files /app/code/web/sites/default/files /app/code/web/sites/default/settings.php
  chmod -R 770 /app/drupal-files /app/code/web/sites/default/files /app/code/web/sites/default/settings.php
fi


/usr/bin/supervisord -c /etc/supervisor/supervisord.conf