sockets = require 'json-sockets'
tty = require 'tty'

socket = sockets.connect 'andrew12.net:3000'
row = 0
col = 0

setpos = (row, col) ->
  process.stdout.write "\033[#{row + 1};#{col + 1}H"

update = ->
  if col >= 80
    col = 0
    row++
  if row >= 25
    row = 0
  col += 80
  col %= 80
  row += 25
  row %= 25
  setpos row, col

process.stdin.resume()
tty.setRawMode true
process.stdin.on 'keypress', (chr, key) ->
  if key?.ctrl and key?.name is 'c'
    process.exit()
  unless key?.ctrl or key?.meta
    switch key?.name
      when 'down'
        row++
        update()
      when 'up'
        row--
        update()
      when 'right'
        col++
        update()
      when 'left'
        col--
        update()
      when 'backspace'
        if col is 0
          row--
        col--
        update()
        socket.send { row: row, col: col, chr: ' ' }
      when 'enter'
        col = 0
        row++
        update()
      else
        socket.send { row: row, col: col, chr: chr }
        col++
        update()

socket.on 'message', (msg) ->
  setpos msg.row, msg.col
  process.stdout.write msg.chr
  update()
