bundle install
bundle exec rake db:create db:migrate &
rm tmp/pids/server.pid
bundle exec rails server -p 3000 -b '0.0.0.0'