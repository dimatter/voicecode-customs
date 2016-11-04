return {
  getSelection: (args, callback) ->
    editor = global.voicecode.currentEditor()
    return callback 'no editor' unless editor
    result = editor.getSelections()[0].getText()
    callback null, result
}
