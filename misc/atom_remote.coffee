return {
  nextCharacterAfterCursor: (__, callback) ->
    editor = @_editor()
    unless editor?
      callback 'no editor'
      returnt
    position = editor.getCursorBufferPosition()
    result = editor.getTextInBufferRange([position, [position.row, position.column+1]])
    callback(null, result)

  placeCursorInsideParameters: ({direction}, callback) ->
    distance = 1
    editor = @_editor()
    unless editor?
      callback 'no editor'
      return false

    for cursor in editor.getCursorBufferPositions()
      index = 0
      found = null
      range = if direction > 0
        method = "scanInBufferRange"
        [cursor, editor.getEofBufferPosition()]
      else
        method = "backwardsScanInBufferRange"
        [[0, 0], cursor]

      editor[method] /\(.*(\))+/g, range, (result) ->
        if result.match
          found = result
          if index++ is (distance - 1)
            result.stop()
      if found?
        editor.setCursorBufferPosition(
          [found.range.end.row,
          found.range.end.column-1]
        )

  wrapWord: ({distance, direction, wrapper}, callback) ->
    editor = @_editor()
    unless editor?
      callback 'no editor'
      return false

    for cursor in editor.getCursorBufferPositions()
      index = 0
      found = null
      range = if direction > 0
        method = "scanInBufferRange"
        [cursor, editor.getEofBufferPosition()]
      else
        method = "backwardsScanInBufferRange"
        [[0, 0], cursor]

      editor[method] /[\w]+/g, range, (result) ->
        if result.match
          found = result
          if index++ is (distance - 1)
            result.stop()
      if found?
        found.replace("#{wrapper}#{found.matchText}#{wrapper}")

  getSelection: (args, callback) ->
    editor = global.voicecode.currentEditor()
    return callback 'no editor' unless editor
    result = editor.getSelections()[0].getText()
    callback null, result
}
