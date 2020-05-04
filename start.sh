#!/bin/bash
set -e
until psql -h postgres -U postgres -c '\l'; do
  echo "Postgres is unavailable - sleeping for 5 seconds"
  sleep 5
done
echo "Postgres is up - executing command"
rm -f tmp/pids/server.pid
RUBYOPT='-W0' bundle install
RUBYOPT='-W0' bundle exec rake db:create db:migrate db:seed
RUBYOPT='-W0' bundle exec rails s -p 3000 -b 0.0.0.0