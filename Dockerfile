FROM ruby:2.5

RUN apt-get update && apt-get install -y nodejs

RUN gem install rails

RUN ruby --version && rails --version
