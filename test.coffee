tty = require 'tty'
process.stdin.resume()
tty.setRawMode true
process.stdin.on 'keypress', (chr, key) ->
  process.exit() if key?.ctrl and key?.name is 'c'
  console.log { chr: chr, key: key }
