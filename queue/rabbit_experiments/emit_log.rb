#!/usr/bin/env ruby
# encoding: utf-8

require "bunny"

conn = Bunny.new(hostname: 'queue')
conn.start

ch   = conn.create_channel
x    = ch.fanout("logs")

msg  = ARGV.empty? ? "Hello World!" : ARGV.join(" ")

10.times do
  x.publish(msg)
  puts " [x] Sent #{msg}"
  sleep 2
end

conn.close