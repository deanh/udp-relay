coffee  = require "coffee-script"
argv    = process.argv.slice(2)

osc     = require 'osc-min'
dgram   = require "dgram"

inports = [9001..9010]
tohosts = {}
servers = []

register =  dgram.createSocket "udp4"
register.on "message", (msg, rinfo) ->
  console.log "Registering #{rinfo.address}"
  tohosts[rinfo.address] = 1

for port in inports
  do ->
    p = port
    udp = dgram.createSocket "udp4"
    udp.on "message", (msg, rinfo) ->
      console.dir rinfo
      for host of tohosts
        console.log host, p, p + 1000
        udp.send msg, 0, msg.length, p + 1000, host 
    udp.bind p
    servers.push udp

register.bind 9000

console.log "Starting server on port: #{inports} sending packets to +1000"
