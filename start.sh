#!/bin/bash
set -e
rm -f tmp/pids/server.pid
RUBYOPT='-W0' bundle exec rake db:create
RUBYOPT='-W0' bundle exec rake db:migrate
RUBYOPT='-W0' bundle exec rake db:seed
RUBYOPT='-W0' bundle exec rails s -p 3000 -b 0.0.0.0 