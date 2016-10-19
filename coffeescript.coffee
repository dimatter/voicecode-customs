Scope.register
  name: 'atom-coffeescript-file'
  condition: ->
    editor = _.find(@currentApplication().editors, {focused: true})
    return false unless editor?
    result = _.difference ['source.coffee'], editor.scopes
    result.length isnt 1
Chain.preprocess {
  name: 'coffeescript magic replacements!'
  scope: 'atom-coffeescript-file'
  }, (chain) ->
    _.reduce chain, (newChain, link, index) ->
      newChain.push link
      link = _.last newChain
      if link.command is 'core:literal'
        link.arguments = _.map link.arguments, (arg) ->
          if arg is "isn't"
            return 'isnt'
          # else if arg is 'constance'
          #   return 'const '
          # else if arg is 'constant'
          #   return 'const '
          # else if arg is 'letter'
          #   return 'let '
          else
            return arg
      # if link.command is 'symbols:single-right-arrow'
      #   link.command = 'core:literal'
      #   link.arguments = ['function']

      newChain
    , []
