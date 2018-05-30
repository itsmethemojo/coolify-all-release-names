FROM ruby

RUN gem install rails rails-api

RUN apt-get update && apt-get install -y nodejs
