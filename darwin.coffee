darwin = Packages.get 'darwin'
darwin.commands
  'navigate-spaces':
    spoken: 'space'
    grammarType: 'custom'
    rule: '<spoken> (targetSpace)?'
    description: 'Navigate spaces'
    variables:
      targetSpace: [
        'one'
        'two'
        'three'
        'four'
        'left'
        'right'
      ]
    action: ({targetSpace})->
      switch targetSpace
        when 'one'
          @key '1', 'control'
        when 'two' or 'to'
          @key '2', 'control'
        when 'three'
          @key '3', 'control'
        when 'four'
          @key '4', 'control'
        when 'left'
          @key 'left', 'control'
        when 'right'
          @key 'right', 'control'
        else
          @key 'up', 'control'
