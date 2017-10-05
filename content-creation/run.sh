rm tmp/pids/server.pid
bundle install --quiet
bundle exec rake db:create db:migrate
bundle exec rails server -p 3000 -b '0.0.0.0'