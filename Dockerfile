FROM lnikell/rails-pack-helphub:latest

RUN mkdir -p /app
WORKDIR /app
COPY ./Gemfile ./Gemfile
COPY ./Gemfile.lock ./Gemfile.lock

COPY . .

RUN rm -rf /app/public/reports
RUN ln -s /reports /app/public/reports

RUN bundle install
RUN apt-get update && apt-get install yarn
