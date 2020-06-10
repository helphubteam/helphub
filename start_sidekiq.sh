#!/bin/bash
set -e

if [ $RAILS_ENV != 'production' ]
then
  until psql -h postgres -U postgres -c '\l'; do
    echo "Postgres is unavailable - sleeping for 5 seconds"
    sleep 5
  done
  echo "Postgres is up - executing command"
fi

rm -f tmp/pids/server.pid

bundle exec sidekiq