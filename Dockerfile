# keep ruby version in sync with gemfile
FROM ruby:2.7.4-buster

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

EXPOSE 3000/tcp

ENTRYPOINT bash entrypoint.sh
