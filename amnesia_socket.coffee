net = require 'net'
fs = require 'fs'
amnesia = Packages.register
  name: 'amnesia_socket'
  description: 'Listens on a file socket for
   programmatically triggered commands(execution bypasses history)'

amnesia.listenOnSocket = (socketPath, callback) ->
  fs.stat socketPath, (error) =>
    unless error
      fs.unlinkSync socketPath
    unixServer = net.createServer (connection) =>
      connection.on 'data', callback.bind(@)
    unixServer.listen socketPath

amnesia.executeChain = (phrase) ->
  emit 'historyControllerAmnesia', yes
  emit 'chainShouldExecute', phrase
  emit 'historyControllerAmnesia', no

amnesia.listenOnSocket "/tmp/voicecode_amnesia.sock"
, amnesia.executeChain
