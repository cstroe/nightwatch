FROM ubuntu:16.04

# ----------------
# Prevent a lot of complaining from apt
# ----------------
ENV DEBIAN_FRONTEND noninteractive

# ----------------
# Get everything up to date
# ----------------
RUN apt-get -qq update
RUN apt-get -yqq upgrade

# ----------------
# Prevent more complaining from apt
# ----------------
RUN apt-get install -yqq apt-utils
RUN apt-get install -yqq apt-transport-https

# ----------------
# Allow us to download and unpack things
# ----------------
RUN apt-get install -yqq curl
RUN apt-get install -yqq wget
RUN apt-get install -yqq unzip
RUN apt-get install -yqq bzip2
RUN apt-get install -yqq xz-utils

# ----------------
# ?? I forget which thing needs this one
# ----------------
RUN apt-get install -yqq ca-certificates

# ----------------
# Install Java 8 (needed by selenium)
# ----------------
RUN apt-get install -yqq openjdk-8-jre-headless

# ----------------
# Allow us to parse json and xml data
# ----------------
RUN apt-get install -yqq jq
RUN apt-get install -yqq libxml-xpath-perl

# ----------------
# Install Node 8 (LTS)
# ----------------
ENV NODE_VERSION=8.11.3
RUN wget -q -O node-v$NODE_VERSION-linux-x64.tar.xz https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.xz
RUN tar -xJf node-v$NODE_VERSION-linux-x64.tar.xz -C /usr/local --strip-components=1
RUN rm node-v$NODE_VERSION-linux-x64.tar.xz
RUN ln -s /usr/local/bin/node /usr/local/bin/nodejs

# ----------------
# Install Chrome ... and add about 600 MB to our image :-(
# ----------------
RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN echo "deb https://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list
RUN apt-get update -yq
RUN apt-get -yqq install google-chrome-stable

# ----------------
# Set up our nodejs packages to allow our Nightwatch E2E tests to be run from the GitLab CI job.
# ----------------
WORKDIR /app
COPY package.json /app/
RUN npm install

# The end
