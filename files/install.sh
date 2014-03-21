#!/bin/bash

[[ -z "$PORT" ]] && PORT=8080

export PORT

apt-get install -qqyy git curl libmagickwand-dev libmagickcore-dev libmagickcore5-extra libgraphviz-dev libgvc5 build-essential libxslt-dev libxml2-dev libmysql-ruby libmysqlclient-dev libpq-dev libsqlite3-dev libyaml-0-2

source /usr/local/rvm/scripts/rvm

rvm install $RUBY
rvm use --default $RUBY

cd /home/openproject/openproject

bundle

echo '
require "rubygems"
require "erb"
template = ERB.new File.read "config/configuration.yml.erb"
File.open("config/configuration.yml", "w") { |f| f.write template.result }
' > /home/openproject/configure.rb

bundle exec ruby /home/openproject/configure.rb

if bundle exec rake db:create; then
  bundle exec rake db:migrate db:test:prepare
  bundle exec rake generate_secret_token
  bundle exec rake db:seed
else
  bundle exec rake db:migrate db:test:prepare
fi

[[ "$RAILS_ENV" = "development" ]] || bundle exec rake assets:precompile:all

bundle exec foreman start -f Procfile.$RAILS_ENV

