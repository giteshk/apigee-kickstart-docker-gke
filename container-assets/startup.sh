#!/bin/bash

set -xe

chown -R www-data:www-data /app && chmod -R 775 /app/drupal-files /app/code/web/sites/default/files

/usr/bin/supervisord -c /etc/supervisor/supervisord.conf