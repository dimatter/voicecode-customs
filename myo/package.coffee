return
m = require('myo')
_ = require('lodash')
pack = Packages.register
  name: 'myo'
  description: 'myo armband integration'

pack.settings
  sensitivity: 115
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
    pack.createCommands()

pack.initializeDevice = ->
  pack.resetToDefault()
  m.onError = ->
    error 'myo', 'myo-error', aguments

  m.on 'disconnected', (data, timestamp) ->
    pack.device = null
    log 'myo', 'myo-disconnected', null, "MYO '#{data.name}' disconnected!"

  m.on 'connected', (data, timestamp) ->
    m.setLockingPolicy 'none'
    log 'myo', 'myo-connected', data, "MYO '#{data.name}' connected!"
    pack.device = @
    @unlock true
    @streamEMG true
    process.on 'exit', =>
      @streamEMG false
      @lock()

  m.on 'emg', (data, timestamp) ->
    data = _.map data, (d, i) ->
      if d >= 0 and d <= pack.settings().sensitivity
        return null
      else if d <= 0 and d > -pack.settings().sensitivity
        return null
      d * 1
    data = _.compact(data)
    if !_.isEmpty(data)
      pack.actionWrapper()

  m.connect 'io.voicecode.myo'


conditionalAction1 = ({link}) ->
  if link.command isnt 'application:next.window'
    pack.resetToDefault()
    Events.removeListener 'commandDidExecute', conditionalAction1



pack.createCommands = ->
  Chain.preprocess {name: 'myo-unsnooze'}, (chain) ->
    if pack.settings().enabled and pack.device?.snoozing
      if chain.length is 1 and chain[0].command in
        ['scrolling:down', 'scrolling:up']
          return chain
      pack.device?.unlock true
      pack.device?.streamEMG true
      pack.device?.snoozing = false
    chain

  pack.after
    'dragon_darwin:microphone-sleep': ->
      pack.device?.streamEMG false
      pack.device?.lock()
      pack.device?.snoozing = true
    'application:previous.application': ->
      Events.removeListener 'commandDidExecute', conditionalAction1
      pack.action = 'application:next.window'
      Events.once 'chainDidExecute', ->
        Events.on 'commandDidExecute', conditionalAction1

  pack.commands
    'toggle-on-off':
      spoken: 'bandit'
      description: 'Toggle myo on and off'
      enabled: true
      action: ->
        if not pack.device.locked
          pack.device?.streamEMG false
          pack.device?.lock()
        else
          pack.device?.streamEMG true
          pack.device?.unlock()
    'set-action':
      spoken: 'clutch'
      description: 'Set last chain as myo action'
      enabled: true
      bypassHistory: (context) -> true
      action: (input, context) ->
        action = {}
        action.command = HistoryController.getChain(1)
        action.timestamp = Date.now()
        pack.action = action
    'do-action':
      description: 'Execute action'
      needsCommand: false
      needsParsing: false
      enabled: true
      locked: true
      bypassHistory: (context) -> true
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
      action: (input, contexthello) ->
        resetToDefault()
