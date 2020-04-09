#!/bin/bash

composer update --working-dir=/app/code --with-dependencies
find /app/code -mindepth 2 -type d -name .git | xargs rm -rf

./setup-distribution.sh