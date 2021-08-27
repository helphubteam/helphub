ARG RUBY_VERSION
# See explanation below
FROM ruby:$RUBY_VERSION-slim-buster

ARG PG_MAJOR
ARG NODE_MAJOR
ARG BUNDLER_VERSION
ARG YARN_VERSION
ARG NODE_ENV
ENV NODE_ENV=$NODE_ENV
ARG RAILS_ENV
ENV RAILS_ENV=$RAILS_ENV
ARG SECRET_KEY_BASE
ENV SECRET_KEY_BASE=$SECRET_KEY_BASE

RUN apt-get update -qq \
    && DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
    build-essential \
    gnupg2 \
    curl \
    less \
    git \
    pkg-config \
    shared-mime-info \
    && apt-get clean \
    && rm -rf /var/cache/apt/archives/* \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && truncate -s 0 /var/log/*log

RUN curl -sSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
    && echo 'deb http://apt.postgresql.org/pub/repos/apt/ buster-pgdg main' $PG_MAJOR > /etc/apt/sources.list.d/pgdg.list

RUN curl -sL https://deb.nodesource.com/setup_$NODE_MAJOR.x | bash -

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo 'deb http://dl.yarnpkg.com/debian/ stable main' > /etc/apt/sources.list.d/yarn.list

RUN apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get -yq dist-upgrade && \
  DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
    libpq-dev \
    libcurl4-openssl-dev \
    postgresql-client-$PG_MAJOR \
    nodejs \
    yarn=$YARN_VERSION-1 \
    $(cat /tmp/Aptfile | xargs) && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    truncate -s 0 /var/log/*log

ENV TZ=Europe/Moscow
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Configure bundler and PATH
ENV LANG=C.UTF-8 \
    BUNDLE_JOBS=4 \
    BUNDLE_RETRY=3

RUN gem update --system && \
    rm /usr/local/lib/ruby/gems/*/specifications/default/bundler-*.gemspec && \
    gem uninstall bundler && \
    gem install bundler -v $BUNDLER_VERSION

#### Chromedriver dependencies & Chrome
ENV PATH="/root/.webdrivers:${PATH}"
ENV CHROME_VERSION="92.0.4515.107"
RUN apt-get update && apt-get install -y wget curl unzip xvfb libxi6 libgconf-2-4 libnss3 wget \
    && TEMP_DEB="$(mktemp)" \
    && wget -O "$TEMP_DEB" 'http://dl.google.com/linux/chrome/deb/pool/main/g/google-chrome-stable/google-chrome-stable_92.0.4515.107-1_amd64.deb' \
    && dpkg -i "$TEMP_DEB" \
    ; apt-get -f -y install \
    && rm -f "$TEMP_DEB";
#####


WORKDIR /app

COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN bundle config set without 'development test' && bundle install
COPY . .

RUN yarn --check-files
# RUN bundle exec rails assets:precompile
