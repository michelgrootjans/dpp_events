#!/usr/bin/env bash
bundle install
WORKERS=ArticlesWorker bundle exec rake sneakers:run