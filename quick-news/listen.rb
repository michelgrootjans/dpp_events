#!/usr/bin/env ruby
# encoding: utf-8

require 'bunny'
require 'mongo'
require 'json'

connection = Bunny.new(hostname: 'queue')
connection.start
channel = connection.create_channel
dispatcher_queue = channel.queue('quick_news', durable: true)

client = Mongo::Client.new([ 'mongo:27017' ], :database => 'quicknews')
article_collection = client[:articles]

begin
  puts " [*] Listening to 'dispatcher'. To exit press CTRL+C"

  dispatcher_queue.subscribe(:block => true) do |delivery_info, properties, body|
    puts " [x] #{delivery_info.routing_key}:#{body}"

    article_collection.insert_one(JSON.parse(body))
  end
rescue Interrupt => _
  channel.close
  connection.close
end