#!/bin/bash

set -xe

if [ ! "${LOCAL_SETUP}" = "true" ]; then
  chown -R www-data:www-data /app/drupal-files /app/code/web/sites/default/files
fi

chmod -R 775 /app/drupal-files /app/code/web/sites/default/files

# chmod 770 /app/code/web/sites/default/settings.php

/usr/bin/supervisord -c /etc/supervisor/supervisord.conf