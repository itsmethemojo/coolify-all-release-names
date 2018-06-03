FROM ruby:2.5

RUN apt-get update && apt-get install -y nodejs

COPY Gemfile* /tmp/

RUN cd /tmp/ && \
    ls Gemfile* && \
    bundle install --system && \
    gem list

WORKDIR /app
