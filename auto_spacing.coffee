Packages.get('auto-spacing').settings
  enabled: ->
    switch @currentApplication().name
      when 'iTerm2'
        false
      when 'Atom'
        false
      else
        true
