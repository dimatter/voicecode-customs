pack = Packages.register
  name: 'myo'
  description: 'myo armband integration'

pack.settings
  sensitivity: 25
  enabled: true
  defaultAction: 'repetition:command-1'
  repetitionSpeed: 200

pack.actionWrapper = _.debounce((->
  pack.device?.vibrate 'short'
  Actions.do 'myo:do-action'
), pack.settings().repetitionSpeed,
  leading: true
  trailing: false)

pack.resetToDefault = ->
  pack.action = pack.settings().defaultAction

pack.defer ->
  if pack.settings().enabled
    pack.initializeDevice()

pack.initializeDevice = ->
  pack.resetToDefault()
  pack.device = new MYO()

  pack.device.on 'emg', (data, timestamp) ->
    data = _.map data, (d, i) ->
      if d >= 0 and d <= pack.settings().sensitivity
        return null
      else if d <= 0 and d > -pack.settings().sensitivity
        return null
      d * 1
    data = _.compact(data)
    if !_.isEmpty(data)
      pack.actionWrapper()

conditionalAction1 = ({link}) ->
  if link.command isnt 'window:next'
    pack.resetToDefault()
    Events.removeListener 'commandDidExecute', conditionalAction1

_.every Packages.get('application')?.settings().firstNameBasis,
      (app, spoken) ->
        pack.after
          "application:open-#{spoken}": ->
            Events.removeListener 'commandDidExecute', conditionalAction1
            pack.action = 'window:next'
            Events.once 'chainDidExecute', ->
              Events.on 'commandDidExecute', conditionalAction1

pack.after
  'dragon_darwin:microphone-sleep': ->
    pack.device?.streamEmg false
  'application:previous.application': ->
    Events.removeListener 'commandDidExecute', conditionalAction1
    pack.action = 'application:next.window'
    Events.once 'chainDidExecute', ->
      Events.on 'commandDidExecute', conditionalAction1

pack.commands
    bypassHistory: (context) -> true
    enabled: true
,
  'toggle-on-off':
    spoken: 'bandit'
    description: 'Toggle myo on and off'
    action: ->
      state = pack.device?.streamingEmg
      pack.device?.streamEmg !state
  'set-action':
    spoken: 'clutch'
    description: 'Set last chain as myo action'
    grammarType: 'commandCapture'
    bypassHistory: (context) -> true
    action: (command, context) ->
      action = {}
      if not command?
        action.command = HistoryController.getChain(1)
      else
        action.command = [{command}]
      action.timestamp = Date.now()
      pack.action = action

  'do-action':
    description: 'Execute myo action'
    needsCommand: false
    needsParsing: false
    locked: true
    action: (input, context) ->
      action = pack.action
      if action.timestamp?
        if Date.now() - action.timestamp < (1000 * 60)
          pack.action.timestamp = Date.now()
          action = pack.action.command
        else
          action = pack.resetToDefault()
      if _.isString pack.action
        action = [{command: pack.action, arguments: null}]
      Fiber(->
        HistoryController.hasAmnesia yes
        new Chain().execute action, false
        HistoryController.hasAmnesia no
        ).run()
  'reset-default':
    spoken: 'jettison'
    description: 'Release saved command'
    action: (input, context) ->
      pack.resetToDefault()




##########
noble = require 'noble'
{EventEmitter} = require 'events'
myoID = 'd5060001a904deb947482c7f4a124842'
commandCharacteristic = 'd5060401a904deb947482c7f4a124842'
emgs = [
  'd5060105a904deb947482c7f4a124842'
  'd5060205a904deb947482c7f4a124842'
  'd5060305a904deb947482c7f4a124842'
  'd5060405a904deb947482c7f4a124842'
]
commandMap = {
  vibrateShort: Buffer.from([
            0x03, 0x01, 0x01
          ])
  vibrateMedium: Buffer.from([
            0x03, 0x01, 0x02
          ])
  vibrateLong: Buffer.from([
            0x03, 0x01, 0x03
          ])
  setModeEmgOnly: Buffer.from([
            0x01, 0x03, 0x02, 0x00, 0x00
          ])
  disableSleep: Buffer.from([
            0x09, 0x01, 0x1
          ])
  setModeNothing: Buffer.from([
            0x01, 0x03, 0x00, 0x00, 0x00
          ])
}
class MYO extends EventEmitter
  instance = null
  constructor: ->
    return instance if instance?
    instance = @
    @streamingEmg = false
    noble.on 'stateChange', (state) =>
      switch state
        when 'poweredOn'
          @startScanning()
    noble.on 'discover', (@peripheral) =>
      @stopScanning()
      @peripheral.once 'connect', _.bind @onConnect, @
      @peripheral.once 'disconnect', _.bind @onDisconnect, @
      @peripheral.connect _.bind @errorHandler, @, 'peripheral connect'

  errorHandler: (action, err) ->
    if err?
      return console.error action, err
    console.log action

  startScanning: ->
    noble.startScanning [myoID]
    , false, _.bind @errorHandler, @, 'scanning start'

  stopScanning: ->
    noble.stopScanning()

  onConnect: ->
    @peripheral.discoverAllServicesAndCharacteristics _.bind @onDiscovered, @
    @emit 'connected', @peripheral

  onDisconnect: ->
    @emit 'disconnected', @peripheral
    @peripheral = null
    @startScanning()

  onDiscovered: (error, services, characteristics) ->
    if error
      return @errorHandler 'discover services and characteristics', error
    @emit 'discoveredServicesAndCharacteristics', _.toArray(arguments)[1..]
    _.each characteristics, (c) =>
      if c.uuid is commandCharacteristic
        @commandCharacteristic = c
        @disableSleep()
        @streamEmg false
        @vibrate 'long'

      if c.uuid in emgs
        c.on 'data', _.bind @handleData, @, _.findIndex emgs, _.matches c.uuid
        c.subscribe _.bind @errorHandler, @, "subscribe #{c.uuid}"

  handleData: (sensor, data) ->
    first = data.readInt8(0)
    second = data.readInt8(8)
    @emit 'emg', [first, second], sensor

  send: (characteristic, payload) ->
    characteristic.write commandMap[payload]
    , true, _.bind @errorHandler, @, "write #{payload}"

  disableSleep: ->
    @send @commandCharacteristic, 'disableSleep'

  vibrate: (length) ->
    length ?= 'short'
    @send @commandCharacteristic, _.camelCase "vibrate #{length}"

  streamEmg: (yesNo) ->
    @streamingEmg = yesNo
    if yesNo is yes
      @send @commandCharacteristic, 'setModeEmgOnly'
    else
      @send @commandCharacteristic, 'setModeNothing'
