
pack = Packages.register
  name: 'pathfinder'
  applications: ['com.cocoatech.PathFinder']
  description: 'Path Finder integration'

pack.commands
  'copy-or-move-left-right':
    rule: '(pfCopyOrMove) (pfLeftOrRight)'
    variables:
      pfCopyOrMove: ['copy', 'move']
      pfLeftOrRight: ['right', 'left']
    action: ({pfCopyOrMove, pfLeftOrRight})->
      if pfCopyOrMove is 'copy'
        @key 'F5'
      else
        @key 'F6'
