Package.command 'slate hint',
  spoken: 'slate hint'
  kind: 'action'
  grammarType: 'individual'
  description: ''
  aliases: []
  tags: ['my','Window manipulation']
  action: (input) ->
    @key 'keypad9', ['control']

Package.command 'slate throw window left',
  spoken: 'slate roll window left'
  kind: 'action'
  grammarType: 'individual'
  description: ''
  aliases: []
  tags: ['my','Window manipulation']
  action: (input) ->
    @key 'keypad1', ['control']

Package.command 'slate throw window right',
  spoken: 'slate throw window right'
  kind: 'action'
  grammarType: 'individual'
  description: ''
  aliases: []
  tags: ['my','Window manipulation']
  action: (input) ->
    @key 'keypad2', ['control']

Package.command 'slate resize wider',
  spoken: 'slate resize wider'
  kind: 'action'
  grammarType: 'individual'
  description: ''
  aliases: []
  tags: ['my','Window manipulation']
  action: (input) ->
    @key 'keypad2', ['option']

Package.command 'slate resize thinner',
  spoken: 'slate resize thinner'
  kind: 'action'
  grammarType: 'individual'
  description: ''
  aliases: []
  tags: ['my','Window manipulation']
  action: (input) ->
    @key 'keypad1', ['option']

Package.command 'slate resize taller',
  spoken: 'slate resize taller'
  kind: 'action'
  grammarType: 'individual'
  description: ''
  aliases: []
  tags: ['my','Window manipulation']
  action: (input) ->
    @key 'keypad3', ['option']

Package.command 'slate resize shorter',
  spoken: 'slate resize shorter'
  kind: 'action'
  grammarType: 'individual'
  description: ''
  aliases: []
  tags: ['my','Window manipulation']
  action: (input) ->
    @key 'keypad4', ['option']

Package.command 'slate maximize',
  spoken: 'slate maximize'
  kind: 'action'
  grammarType: 'individual'
  description: ''
  aliases: []
  tags: ['my','Window manipulation']
  action: (input) ->
    switch @currentApplication()
      when 'VLC'
        @key 'F', ['command']
      else
        @key 'keypad5', ['option']

Package.command 'slate relaunch',
  spoken: 'slate relaunch'
  kind: 'action'
  grammarType: 'individuarelaunchl'
  description: ''
  aliases: []
  tags: ['my','Window manipulation']
  action: (input) ->
    @key 'keypad0', ['control']

Package.command 'slate',
  spoken: 'slate'
  kind: 'action'
  grammarType: 'custom'
  description: ''
  rule: '<spoken> (slateNumbers)'
  variables:
    slateNumbers: ['1 2', '2 2', '1 3', '3 3', '2 3', '1 4', '2 4', '3 4', '4 4']
  aliases: []
  tags: ['my','Window manipulation']
  action: ({slateNumbers}) ->
    debug slateNumbers
    switch slateNumbers
      when '1 2'
        @key 'keypad6', 'option'
      when '2 2'
        @key 'keypad7', 'option'
      when '1 3'
        @key 'keypad8', 'option'
      when '3 3'
        @key 'keypad9', 'option'
      when '2 3'
        @key 'keypad0', 'option'
      when '1 4'
        @key 'keypad3', 'control'
      when '2 4'
        @key 'keypad4', 'control'
      when '3 4'
        @key 'keypad5', 'control'
      when '4 4'
        @key 'keypad6', 'control'
