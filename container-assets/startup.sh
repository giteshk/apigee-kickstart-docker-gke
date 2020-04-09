#!/bin/bash

set -xe

chown -R www-data:www-data /app/drupal-files /app/code/web/sites/default/files
chmod -R 770 /app/drupal-files /app/code/web/sites/default/files

# chmod 770 /app/code/web/sites/default/settings.php

/usr/bin/supervisord -c /etc/supervisor/supervisord.conf