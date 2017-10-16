#!/usr/bin/env bash
bundle check || bundle install

ruby listen.rb &

ruby main.rb -p 3000