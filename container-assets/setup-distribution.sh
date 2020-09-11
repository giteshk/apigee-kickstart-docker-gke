#!/bin/bash
  alias composer="php -d disable_functions='' -d memory_limit=-1 /usr/local/bin/composer"

  rm -rf /app/code/*

  git clone -b $GIT_CODE_BRANCH $GIT_CODE_REPO /app/code

  if [ ! -d /app/code/vendor ]; then
      composer install --working-dir=/app/code -o
  fi
  if [ ! -d /app/code/vendor/bin/drush ]; then
        #make sure drush is installed
        composer require drush/drush
  fi
  # remove embeded git repositories
  find /app/code -mindepth 2 -type d -name .git | xargs rm -rf

  cp /app/container-assets/drush.sh /usr/local/bin/drush && chmod 755 /usr/local/bin/drush

  #create the file system for public, private, temp files
  mkdir -p /app/drupal-files/public \
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

  # Use the settings file which has been parameterized using Environment variables
  cp -f /app/container-assets/parameterized.settings.php /app/code/web/sites/default/settings.php

  if [ "${LOCAL_SETUP}" = "true" ]; then
    chmod -R 777 /app/drupal-files /app/code/web/sites/default/files
  else
    ln -s -f /app/code/web/sites/default/files ../../../../../drupal-files/public
    chown -R www-data:www-data /app/drupal-files /app/code/web/sites/default/files /app/code/web/sites/default/settings.php
    chmod -R 770 /app/drupal-files /app/code/web/sites/default/files /app/code/web/sites/default/settings.php
  fi