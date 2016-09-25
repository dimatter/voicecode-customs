pack = Packages.get 'chrome'
pack.before
  'os:undo': ->
    history = _.flattenDeep _.union _.map [1..3],
    _.ary HistoryController.getChain.bind(HistoryController), 1
    history = _.map history, 'command'
    if 'window:close' in history
      @key 't', 'shift command'
      return false
    return true
