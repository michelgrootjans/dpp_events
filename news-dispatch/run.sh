#!/usr/bin/env bash
bundle check || bundle install

ruby main.rb -p 3000