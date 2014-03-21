#!/bin/bash

RAILS_ENV=${RAILS_ENV:-development}

# config
rails_env=$RAILS_ENV
ruby_version=${RUBY:-2.1.0}
cache_store=memcache
workers=${WORKERS:-1}

data_folder=${DATA_FOLDER:-$HOME/data}

pg_user=super
pg_pass="$(cat sensitive/pg_pass)"

ex_port=${PORT:-8080}


