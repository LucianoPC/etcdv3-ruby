FROM ruby:3.0.0-slim

ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

RUN apt update && \
    apt install -y --no-install-recommends \
    git \
    wget \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app/

COPY lib/etcdv3/version.rb ./lib/etcdv3/
COPY Gemfile etcdv3.gemspec Rakefile ./

RUN bundle config --global jobs 4 && \
    bundle config --global set clean 'true' \
    bundle config --global git.allow_insecure true && \
    bundle install

ENV ETCD_DIR=/downloads
ENV ETCD_VERSION_TO_TEST=v3.2.0
RUN mkdir /downloads
RUN echo "export PATH=\"/downloads/etcd-v3.2.0-linux-amd64:$PATH\"" >> ~/.bashrc
RUN rake download-etcd

COPY . .