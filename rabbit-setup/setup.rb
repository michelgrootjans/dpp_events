#!/usr/bin/env ruby
# encoding: utf-8

require 'bunny'

connection = Bunny.new(hostname: 'queue')
connection.start

channel = connection.create_channel

# articles_written => dispatcher
articles_written = channel.fanout('articles_written')
dispatcher = channel.queue('dispatcher', durable: true)
dispatcher.bind(articles_written)

# articles_published => quick_news
articles_published = channel.topic('articles_published')
quick_news = channel.queue('quick_news', durable: true)
quick_news.bind(articles_published, routing_key: 'quick_news')

# articles_published => quick_news
super_news = channel.queue('super_news', durable: true)
super_news.bind(articles_published, routing_key: 'super_news')

connection.close