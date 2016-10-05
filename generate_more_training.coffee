fs = require 'fs'
writeFile = (type, data) ->
  file = path.resolve(AssetsController.assetsPath, "generated/#{type}.txt")
  fs.writeFileSync file, data, 'utf8'

_delete = Commands.get('common:delete').spoken
delete_ = Commands.get('common:forward-delete').spoken
letters = Packages.get('alphabet')._settings.letters
data = []
_.each letters, (letter) ->
  data.push letter, _delete, letter, delete_
writeFile 'delete-letters', data.join ' '

space = Commands.get('common:forward-delete').spoken
data = []
_.each letters, (letter) ->
  data.push space, letter, space
writeFile 'space-letters', data.join ' '

_deleteWord = Commands.get('delete:word').spoken
deleteWord_ = Commands.get('delete:word-forward').spoken
jumpWordRight = Commands.get('cursor:word-right').spoken
jumpWordLeft = Commands.get('cursor:word-left').spoken
data = []
data.push jumpWordLeft, _deleteWord
data.push jumpWordRight, _deleteWord
data.push jumpWordLeft, deleteWord_
data.push jumpWordRight, deleteWord_
writeFile 'delete-words-movement', data.join ' '
