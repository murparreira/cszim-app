# Use the Ruby 2.2.6 image from Docker Hub
# as the base image (https://hub.docker.com/_/ruby)
FROM ruby:2.7.7-alpine

RUN apk update && apk add --no-cache --virtual build-dependencies build-base gcc wget git \
  mariadb-dev gcompat nodejs bash curl postgresql-dev \
  zlib-dev libxml2-dev libxslt-dev readline-dev tzdata

# Use a directory called /code in which to store
# this application's files. (The directory name
# is arbitrary and could have been anything.)
WORKDIR /code

# Copy all the application's files into the /code
# directory.
COPY . /code

# Run bundle install to install the Ruby dependencies.
RUN bundle install

# Set "rails server -b 0.0.0.0" as the command to
# run when this container starts.
CMD ["rails", "server", "-b", "0.0.0.0"]