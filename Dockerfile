FROM lnikell/rails-pack-helphub:latest

WORKDIR /app

RUN apt-get update && apt-get install yarn

COPY ./Gemfile ./Gemfile
COPY ./Gemfile.lock ./Gemfile.lock
RUN bundle install

COPY . .

RUN rm -rf /app/public/reports
RUN ln -s /reports /app/public/reports
