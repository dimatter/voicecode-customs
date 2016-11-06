module.exports =
  'symbols:dot': ['format:camel']
  'cursor:down': ['cursor:way-left', 'cursor:way-right'
  , 'cursor:down', 'delete:word', 'delete:word-forward']
  'cursor:up': ['cursor:way-left', 'cursor:way-right'
  , 'cursor:up', 'delete:word', 'delete:word-forward']
  'selection:block': ['mouse:shift-click']
  'selection:all': ['common:delete']
  'common:delete': ['common:enter']
  'common:forward-delete': ['common:enter']
  'symbols:slash': ['repetition:command-2']
  'symbols:hashtag': ['repetition:command-2']
  'atom:select-scope': ['repetition:command-2']
  'delete:word': ['common:enter', 'clipboard:paste']
  'delete:word-forward': ['common:enter', 'clipboard:paste']
  'cursor:way-left': ['cursor:new-line-above', 'delete:word-forward']
  'cursor:way-right': ['delete:word']
