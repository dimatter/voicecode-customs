# robot = require 'robotjs'
#
# Package.command 'testicle',
#   spoken: 'testicles'
#   needsCommand: false
#   action: ->
#     @keyDown 'tab', 'command'
#     @delay(250)
#     @keyUp 'tab', 'command'
#
# _normalizeModifiers = (modifiers) ->
#   return [] unless modifiers?
#   return modifiers if _.isArray modifiers
#   return modifiers.split(' ')
#
# pack = Packages.register
#   name: 'bbbabb'
#   description: 'what the hell'
#
# pack.implement {weight: 12},
#   'os:key': ({key, modifiers}) ->
#     modifiers = _normalizeModifiers modifiers
#     robot.keyTap key, modifiers
#   'os:keyDown': ({key, modifiers}) ->
#     modifiers = _normalizeModifiers modifiers
#     robot.keyToggle key, 'down', modifiers
#   'os:keyUp': ({key, modifiers}) ->
#     modifiers = _normalizeModifiers modifiers
#     robot.keyToggle key, 'up', modifiers

Packages.get('auto-spacing').settings
  enabled: ->
    switch @currentApplication().name
      when 'iTerm2'
        false
      when 'Atom'
        false
      else
        true
