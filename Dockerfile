# keep ruby version in sync with gemfile
FROM ruby:2.7.4-buster

# https://docs.microsoft.com/en-us/azure/app-service/configure-custom-container?pivots=container-linux#enable-ssh
ENV SSH_PASSWD "root:Docker!"
RUN apt-get update \
        && apt-get install -y --no-install-recommends dialog \
        && apt-get update \
  && apt-get install -y --no-install-recommends openssh-server \
  && echo "$SSH_PASSWD" | chpasswd 
COPY sshd_config /etc/ssh/

ADD https://nodejs.org/dist/v16.17.0/node-v16.17.0-linux-x64.tar.xz /tmp/node/node.tar.xz

WORKDIR /tmp/node

RUN tar -xf node.tar.xz --strip-components=1

RUN cp -r bin/* /usr/bin/

RUN cp -r lib/* /usr/lib/

RUN npm i -g yarn

WORKDIR /app

COPY Gemfile Gemfile.lock ./

RUN bundle install

COPY package.json yarn.lock ./

RUN yarn install

COPY . .

RUN rails webpacker:install

VOLUME /app/db/sqllite

EXPOSE 8080 2222

ENV PORT=8080

ENTRYPOINT bash entrypoint.sh
