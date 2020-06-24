FROM lnikell/rails-pack-helphub:latest

RUN mkdir -p /app
WORKDIR /app
COPY ./Gemfile ./Gemfile
COPY ./Gemfile.lock ./Gemfile.lock

COPY . .
RUN bundle install
RUN yarn install --check-files
