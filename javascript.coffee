Scope.register
  name: 'atom-javascript-file'
  condition: ->
    editor = _.find(@currentApplication().editors, {focused: true})
    return false unless editor?
    result = _.difference ['source.js', 'source.js.jsx'], editor.scopes
    result.length isnt 2
Chain.preprocess {
  name: 'Javascript magic replacements!'
  scope: 'atom-javascript-file'
  }, (chain) ->
    _.reduce chain, (newChain, link, index) ->
      newChain.push link
      link = _.last newChain
      if link.command is 'core:literal'
        link.arguments = _.map link.arguments, (arg) ->
          if arg is 'variable'
            return 'var '
          else if arg is 'constance'
            return 'const '
          else if arg is 'constant'
            return 'const '
          else if arg is 'letter'
            return 'let '
          else
            return arg
      if link.command is 'symbols:single-right-arrow'
        link.command = 'core:literal'
        link.arguments = ['function']

      newChain
    , []
