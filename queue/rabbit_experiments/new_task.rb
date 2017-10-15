#!/usr/bin/env ruby
# encoding: utf-8

require "bunny"

conn = Bunny.new(hostname: 'queue')
conn.start

ch   = conn.create_channel

q    = ch.queue("task_queue", durable: true)

msg  = ARGV.empty? ? "Hello World!" : ARGV.join(" ")
q.publish(msg, persitent: true)

puts " [x] Sent '#{msg}'"

conn.close
