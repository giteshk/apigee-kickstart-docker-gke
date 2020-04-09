#!/bin/bash

set -xe

if [ "${LOCAL_SETUP}" = "true" ]; then
  chmod -R 777 /app/drupal-files /app/code/web/sites/default/files
else
  chown -R www-data:www-data /app/drupal-files /app/code/web/sites/default/files
  chmod -R 770 /app/drupal-files /app/code/web/sites/default/files
fi

# Use the settings file which has been parameterized using Environment variables
cp -f /app/container-assets/parameterized.settings.php /app/code/web/sites/default/settings.php

/usr/bin/supervisord -c /etc/supervisor/supervisord.conf