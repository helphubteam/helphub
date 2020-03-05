# Use ruby version for docker image same as on production
FROM ruby:2.6.1-slim-stretch

# Explictly set versions
ENV RUBYGEMS_VERSION=2.7.10
ENV BUNDLER_VERSION=2.1.2
ENV YARN_VERSION=1.21.1
ENV PG_MAJOR_VERSION=10
ENV NODE_MAJOR_VERSION=13

# Set other environment variables
ENV RAILS_ROOT=/jiffyshirts
ENV LANG=C.UTF-8 \
    BUNDLE_JOBS=4 \
    BUNDLE_RETRY=3

# Set path
ENV PATH /root/.cargo/bin:$RAILS_ROOT/bin:$BUNDLE_PATH/bin:$PATH

# Install common dependencies
RUN apt-get update -qq \
  && DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
    build-essential \
    gnupg2 \
    curl \
    less \
    git \
    zip \
    unzip \
    vim \
  && apt-get clean \
  && rm -rf /var/cache/apt/archives/* \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && truncate -s 0 /var/log/*log

# Add PostgreSQL to sources list
RUN curl -sSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
  && echo 'deb http://apt.postgresql.org/pub/repos/apt/ stretch-pgdg main' $PG_MAJOR_VERSION > /etc/apt/sources.list.d/pgdg.list

# Add NodeJS to sources list
RUN curl -sL https://deb.nodesource.com/setup_$NODE_MAJOR_VERSION.x | bash -

# Add Yarn to the sources list
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo 'deb http://dl.yarnpkg.com/debian/ stable main' > /etc/apt/sources.list.d/yarn.list

# Install dependencies
RUN apt-get update -qq \
  && DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
    libpq-dev \
    postgresql-client-$PG_MAJOR_VERSION \
    nodejs \
    yarn=$YARN_VERSION-1 \
    x11vnc \
    xvfb \
  # with usefull recommended packages
  && DEBIAN_FRONTEND=noninteractive apt-get install -yq python-pip \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && truncate -s 0 /var/log/*log

# Set our working directory inside the image
WORKDIR $RAILS_ROOT

# Update bundler to latest available version
RUN gem update --system $RUBYGEMS_VERSION \
  && gem install bundler:$BUNDLER_VERSION
