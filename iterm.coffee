pack = Packages.get 'iterm'
pack.offset ?= 0

pack.implement
  'object:backward': ->
    @key 'left', 'option'
  'object:forward': ->
    @key 'right', 'option'

Scope.register
  name: 'fancy-iterm'
  condition: ->
    pack.state? and Scope.active('iterm')
pack.after {
  scope: 'fancy-iterm'
},
  'cursor:left': ->
    pack.offset = pack.offset - 1
  'cursor:right': ->
    pack.offset = pack.offset + 1
  'common:delete': ->
    pack.offset = pack.offset - 1
  'cursor:up': ->
    pack.state = Actions.getCurrentItermState()
    pack.offset = pack.state.length
  'cursor:down': ->
    pack.state = Actions.getCurrentItermState()
    pack.offset = pack.state.length
  'window:previous': ->
    pack.state = Actions.getCurrentItermState()
    pack.offset = pack.state.length
  'window:next': ->
    pack.state = Actions.getCurrentItermState()
    pack.offset = pack.state.length
  'common:enter': ->
    pack.offset = 0
    pack.state = ''
  'os:undo': ->
    pack.offset = 0
  'cursor:way-left': ->
    pack.offset = 0
  'cursor:way-right': ->
    pack.offset = pack.state.length

pack.implement {
  scope: 'fancy-iterm'
},
  'cursor:word-right': ->
    state = pack.state
    offset = pack.offset
    head = state.substring 0, offset
    tail = state.replace head, ''
    tail = tail.replace /^ /, ''
    tail = _.dropWhile tail.split(''), (char) -> char isnt ' '
    times = state.length - tail.join('').length
    pack.offset = pack.offset + times
    _.times (times), => @right()

  'cursor:word-left': ->
    state = pack.state
    offset = pack.offset
    tail = state.substring offset, state.length
    head = state.replace tail, ''
    head = head.replace /\s$/, ''
    head = _.dropRightWhile head.split(''), (char) -> char isnt ' '
    times = state.length - head.join('').length
    pack.offset = pack.offset - times
    _.times (times), => @left()

  'delete:word': ->
    state = pack.state
    offset = pack.offset
    tail = state.substring offset, state.length
    head = state.replace tail, ''
    head = head.replace /\s$/, ''
    head = _.dropRightWhile head.split(''), (char) -> char isnt ' '
    state = head.join('') + tail
    @key 'u', 'control'
    @setItermString state
    pack.state = state
    pack.offset = state.length
    if tail? and tail isnt ''
      _.times tail.length, => @left()

  'delete:word-forward': ->
    state = pack.state
    offset = pack.offset
    head = state.substring 0, offset
    tail = state.replace head, ''
    tail = tail.replace /^ /, ''
    tail = _.dropWhile tail.split(''), (char) -> char isnt ' '
    state = head + tail.join('')
    @key 'u', 'control'
    @setItermString state
    pack.state = state
    pack.offset = state.length
    if tail? and tail isnt ''
      _.times tail.length, => @left()

Events.on [
  'chainDidExecute'
, 'currentApplicationChanged'], ->
  if Actions.currentApplication().bundleId in pack.applications()
    pack.state = Actions.getCurrentItermState()

Events.on 'charactersTyped', (string) ->
  if Actions.currentApplication().bundleId in pack.applications()
    pack.state = Actions.getCurrentItermState()
    pack.offset = pack.state?.length || 0

pack.actions
  'setItermString': (state) ->
    @applescript """
    tell application "iTerm"
        tell current session of current window
          if (is at shell prompt) then
            write text "#{state}" newline NO
          end if
        end tell
    end tell
    """
  'getCurrentItermState': ->
    result = @applescript '''
    tell application "iTerm"
      tell current session of current window
        if (is at shell prompt) then
          contents
        else
          null
        end if
      end tell
    end tell
    '''
    unless result?
      pack.offset = 0
      return result
    result = result.split '\n'
    result = _.filter result, (line) ->
      return false if line in [' ', '']
      return true
    unless _.isEmpty result
      result = _.last(result)
      result = result.replace /^.*\»\W/, ''
    _.trim result
