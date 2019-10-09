FROM ruby:2.4

ENV APP_HOME /cszim
WORKDIR $APP_HOME

ENV TZ=America/Sao_Paulo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y software-properties-common

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl \
                                               build-essential \
                                               openssl \
                                               libreadline7 \
                                               libreadline-dev \
                                               curl \
                                               git-core \
                                               zlib1g \
                                               zlib1g-dev \
                                               libssl-dev \
                                               libyaml-dev \
                                               libsqlite3-dev \
                                               default-libmysqlclient-dev \
                                               sqlite3 \
                                               libxml2-dev \
                                               libxslt-dev \
                                               libgmp-dev \
                                               autoconf \
                                               libc6-dev \
                                               ncurses-dev \
                                               automake \
                                               libtool \
                                               bison \
                                               subversion \
                                               libpq-dev

COPY Gemfile $APP_HOME/Gemfile
RUN bundle install

COPY . $APP_HOME

RUN rake db:drop && rake db:create && rake db:migrate && rake db:seed

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]