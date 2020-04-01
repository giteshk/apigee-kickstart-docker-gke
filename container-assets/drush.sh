#!/bin/bash
php -d disable_functions='' -d memory_limit=-1 /app/code/vendor/bin/drush --root='/app/code' $@
