#!/usr/bin/env ruby
# encoding: utf-8

require "bunny"

conn = Bunny.new(hostname: 'queue', automatically_recover: false)
conn.start

ch   = conn.create_channel
q    = ch.queue("hello")

ch.prefetch(1)
puts " [*] Waiting for messages. To exit press CTRL+C"

begin
  q.subscribe(manual_ack: true, block: true) do |delivery_info, properties, body|
    puts " [x] Received #{body}"
    # imitate some work
    sleep body.count(".").to_i
    puts " [x] Done"
    ch.ack(delivery_info.delivery_tag)
  end
rescue Interrupt => _
  conn.close

  exit(0)
end

