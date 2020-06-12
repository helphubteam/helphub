#!/bin/bash
set -e

until psql -h postgres -U postgres -c '\l'; do
  echo "Postgres is unavailable - sleeping for 5 seconds"
  sleep 5
done
echo "Postgres is up - executing command"

rm -f tmp/pids/server.pid
bundle install

if [ $RAILS_ENV = 'production' ]
then
  bundle exec rake db:create db:migrate 
else
  bundle exec rake db:create db:migrate db:seed 
fi

bundle exec rails s -p 3000 -b 0.0.0.0