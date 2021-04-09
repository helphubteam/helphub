#!/bin/bash
set -e

rm -f tmp/pids/server.pid

if [ "$RAILS_ENV" = 'production' ] || [ "$RAILS_ENV" = 'staging' ]
then
  bundle exec rails db:create db:migrate assets:precompile
else
  bundle exec rails db:create db:migrate db:seed
fi

bundle exec rails s -p 3000 -b 0.0.0.0
