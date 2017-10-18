#!/usr/bin/env bash
bundle check || bundle install

ruby listen.rb
