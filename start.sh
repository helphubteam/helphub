#!/bin/bash
set -e
rm -f tmp/pids/server.pid
RUBYOPT='-W0' bundle exec rake db:create db:migrate db:seed
RUBYOPT='-W0' bundle exec rails s -p 3000 -b 0.0.0.0