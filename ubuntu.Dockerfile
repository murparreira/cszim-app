FROM phusion/baseimage:latest

ENV APP_HOME /cszim
WORKDIR $APP_HOME

ENV TZ=America/Sao_Paulo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y software-properties-common && \
    apt-add-repository -y ppa:brightbox/ruby-ng

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl \
                                               build-essential \
                                               openssl \
                                               libreadline6 \
                                               libreadline6-dev \
                                               curl \
                                               git-core \
                                               zlib1g \
                                               zlib1g-dev \
                                               libssl-dev \
                                               libyaml-dev \
                                               libsqlite3-dev \
                                               libmysqlclient-dev \
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

RUN gpg --keyserver hkp://pool.sks-keyservers.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB && \
    curl -sSL https://get.rvm.io | bash -s stable

ENV PATH /usr/local/rvm/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

RUN /bin/bash -l -c "rvm requirements" && \
    /bin/bash -l -c "rvm install 2.4"

COPY Gemfile $APP_HOME/Gemfile

RUN /bin/bash -l -c "gem install bundler --no-document"
RUN /bin/bash -l -c "gem install mysql2 -v '0.3.21' --source 'https://rubygems.org/'"
RUN /bin/bash -l -c "bundle install"

COPY . $APP_HOME

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

#ENV RAILS_ENV=development

RUN /bin/bash -l -c "rake db:drop" && \
    /bin/bash -l -c "rake db:create" && \
    /bin/bash -l -c "rake db:migrate" && \
    /bin/bash -l -c "rake db:seed"

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]