FROM ruby:3.1.1
# railsに必要な必要なnodejsとpostgeqsqlをインストール
RUN apt-get update -qq && apt-get install -y build-essential postgresql-client libpq-dev
RUN apt-get install -y nodejs npm && npm install n -g && n 16.14.2
# yarnパッケージ管理ツールをインストール
RUN apt-get update && apt-get install -y curl apt-transport-https wget && \
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
apt-get update && apt-get install -y yarn

RUN mkdir /railsapp
WORKDIR /railsapp
COPY Gemfile /railsapp/Gemfile
COPY Gemfile.lock /railsapp/Gemfile.lock
RUN bundle install
COPY . /railsapp
# コンテナが起動するたびに実行されるスクリプトを追加
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000
# イメージ内部のソフトウェア実行(railsのこと)
CMD ["rails", "server", "-b", "0.0.0.0"]