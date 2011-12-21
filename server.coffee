sockets = require 'json-sockets'

text = (' ' for [0...80] for [0...25])

clients = []

sockets.listen 3000, (socket) ->
  clients.push socket
  for i in [0...25]
    for j in [0...80]
      msg = { row: i, col: j, chr: text[i][j] }
      console.log 'send', msg
      socket.send msg
  console.log "connect; #{clients.length} clients"
  socket.on 'message', (msg) ->
    text[msg.row][msg.col] = msg.chr
    for c in clients
      console.log 'send', msg
      c.send msg
  socket.on 'close', ->
    clients.splice clients.indexOf(socket), 1
    console.log "disconnect; #{clients.length} clients"
