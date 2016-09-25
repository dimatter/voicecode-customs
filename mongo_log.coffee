mongoose = require('mongoose')

commandSkeleton =
  chain: String
  date: Date
  command: String
  spoken: String
  bundle: String
  application: String
  additional: Object
  arguments: Object

commandSchema = mongoose.Schema(commandSkeleton)
# commandSchema.path('date').set (value) ->
#   Date.now()
try
  commandModel = mongoose.model('Command', commandSchema)
catch error

#####

eventSkeleton =
  date: Date
  event: String
  arguments: Object


retry = 3
db = mongoose.connection
db.on 'connecting', ->
  console.log 'connecting to MongoDB...'

db.on 'error', (error) ->
  console.error 'Error in MongoDB connection: ' + error
  mongoose.disconnect()

db.on 'connected', ->
  console.log 'MongoDB connected!'

db.on 'reconnected', ->
  console.log 'MongoDB reconnected!'

db.on 'disconnected', ->
  console.log 'MongoDB disconnected!'
  if --retry
    setTimeout connect, 10000

unless developmentMode
  do connect = -> mongoose.connect 'mongodb://utility/voicecode'



getId = ->
  s4() + s4() + '-' + s4() + '-' + s4() + '-' + s4() + '-' + s4() + s4() + s4()

s4 = ->
  Math.floor((1 + Math.random()) * 0x10000).toString(16).substring 1


db.once 'open', ->
  currentChain = null
  Events.on 'chainWillExecute', ->
    currentChain = getId()
  Events.on 'commandWillExecute', ({link}) ->
    cmd = link
    currentApplication = Actions.currentApplication()
    {name: application, bundleId: bundle} = currentApplication
    additional = _.reduce currentApplication, ((additional, v, k) ->
      unless k in ['name', 'bundleId']
        additional[k] = v
      additional
      ), {}
    Command = new commandModel
      chain: currentChain
      date: Date.now()
      command: cmd.command
      spoken: Commands.get(cmd.command).spoken
      application: application
      additional: additional
      arguments: cmd.arguments
      bundle: bundle
    process.nextTick ->
      Command.save()
