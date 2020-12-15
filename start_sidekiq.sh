#!/bin/bash
set -e

# until psql -h postgres -U postgres -c '\l'; do
#   echo "Postgres is unavailable - sleeping for 5 seconds"
#   sleep 5
# done
# echo "Postgres is up - executing command"

# bundle install
bundle exec sidekiq -C config/sidekiq.yml
