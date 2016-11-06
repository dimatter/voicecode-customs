random = Packages.register
  name: 'random'
  description: 'a bunch of random commands'



singleWords = []
for word in singleWords
  random.command word,
    spoken: word
    grammarType: "none"
    description: "insert the word '#{word}'"
    tags: ["user", "words"]
    needsParsing: false

conditionalAction1 = ({link}) ->
  if link.command isnt 'application:next.window'
    Packages.get('myo').resetToDefault()
    Events.removeListener 'commandDidExecute', conditionalAction1

Events.on 'willParsePhrase', (container) ->
  container.phrase = container.phrase.replace 's wipe', ' swipe'
  container


random.command 'open-developer-tools',
    spoken: "dev tools"
    enabled: true
    action: ->
      @key 'i', 'command option'

random.command 'open-dash',
    spoken: "dasher"
    enabled: true
    action: ->
      @key '0', 'control option'

random.command 'put-system-to-sleep',
  spoken: "put system to sleep"
  kind : "action"
  continuous: false
  grammarType : "individual"
  needsCommand: false
  aliases : []
  tags : ["my", "System"]
  action : (input) ->
    @exec "sleep 1500&&pmset sleepnow"

random.command "playlist",
  spoken: 'playlistify'
  kind: "action"
  continuous: false
  grammarType: "individual"
  description: "Focus Atom"
  aliases: []
  tags: ["my"]
  action: () ->
    tracklist = @getSelectedText().split "\n"
    _.each tracklist, (element, list) =>
      element = encodeURIComponent(element)
      @openURL "http://vk.com/search?c%5Bq%5D=#{element}&c%5Bsection%5D=audio"

random.commands
  enabled: true
,
  'hide-window':
    spoken: 'cassie' # Esperanto: kaŝi, english: can't see
    action: ->
      @key 'h', 'command'
  'random-keyboard-shortcut':
    continuous: false
    spoken: 'key binder'
    action: ->
      {modifierPrefixes, modifierSuffixes} = Packages.get('modifiers').settings()
      modifierPrefixes = _.values modifierPrefixes
      modifierSuffixes = _.keys modifierSuffixes
      modifierSuffixes = _.union modifierSuffixes
      , _.keys Packages.get('alphabet').settings().letters
      modifiers = modifierPrefixes[_.random(modifierPrefixes.length)]
      key = modifierSuffixes[_.random(modifierSuffixes.length)]
      @key key, modifiers
  'flip-the-table-smily':
    spoken: 'table flip'
    action: ->
      switch _.random 1, 4
        when 1
          @paste '(╯°□°）╯︵ ┻━┻'
        when 2
          @paste '(ﾉಥ益ಥ）ﾉ﻿ ┻━┻'
        when 3
          @paste '(ノಠ益ಠ)ノ彡┻━┻'
        when 4
          @paste '(ﾉ≧∇≦)ﾉ ﾐ ┸━┸'
  'put-the-table-back':
    spoken: 'table set'
    action: ->
      @paste '┬─┬ノ( º _ ºノ)'
  'who-knows-smily':
    spoken: 'smug shrug'
    action: ->
      @paste '¯\\_(ツ)_/¯'
  'delete-symmetrical':
    spoken: 'slurp'
    action: ->
      @do 'common:delete'
      @do 'common:forward-delete'
  'take-a-screenshot':
    spoken: 'headshot'
    action: ->
      @key '4', 'shift command'
  'quit-application':
    spoken: 'mortigi' # esperanto
    action: ->
      @key 'q', 'command'
  'force-quit-application':
    spoken: 'forto mortigi' # esperanto
    action: ->
      @key 'escape', 'command option shift'
  'minimize-window':
    spoken: 'mini me'
    enabled: true
    action: ->
      @key 'm', 'command'
  'double-quotes-paded-left':
    spoken: "pre-coif"
    tags : ["my", "symbols"]
    action : (input) ->
      if @currentApplication().name is "Atom" and Settings.atom.bracketMatcher
        @string ' "'
      else
        @string ' ""'
        @left()
  'single-quotes-padded-left':
    spoken: "pre-posh"
    tags : ["my", "symbols"]
    action : (input) ->
      if @currentApplication().name is "Atom" and Settings.atom.bracketMatcher
        @string " '"
      else
        @string " ''"
        @left()
  'camel-case-padded-left':
    spoken: 'pre-cram'
    grammarType: 'textCapture'
    description: 'space cram'
    misspellings: ['pre-crime']
    tags: ['text', 'combo']
    action: (input) ->
      if input
        @string ' ' + Transforms.camel(input)
  'studley-case-padded-left':
    spoken: 'pre-criffed'
    grammarType: 'textCapture'
    description: 'space criffed'
    tags: ['text', 'combo']
    action: (input) ->
      if input
        @string ' ' + Transforms.stud(input)
  'stem-the-word':
    spoken: 'stemmify'
    kind: "action"
    grammarType: 'oneArgument'
    action: (input) ->
      @string input.replace /ing$/, ''
  'div-and-class-name':
    spoken: 'david'
    needsCommand: false
    enabled: true
    action: ->
      @string '<div className=\'\'></div>'
      @left(8)
  'wake-up':
    spoken: 'wake up'
    misspellings: ['wakeup']
    enabled: true
    action: ->
      @sleeping = false

Chain.preprocess random, (chain) ->
  return chain unless Actions.sleeping
  _.dropWhile chain, _.negate _.iteratee ['command','random:wake-up']

random.implement {weight: -10},
  'dragon_darwin:microphone-sleep': ->
    @sleeping = true


Commands.mapping['audio:set-volume'].continuous = true
Commands.mapping['audio:decrease-volume'].continuous = true
Commands.mapping['audio:increase-volume'].continuous = true

Events.on 'shouldStringBePasted', (shouldPaste) ->
  if Actions.currentApplication().name in ['Screen Sharing', 'Microsoft Remote Desktop', 'Royal TSX']
    shouldPaste.yesNo = no
    shouldPaste.continue = no
  shouldPaste


Settings.darwin.applicationsThatNeedLaunchingWithApplescript = []
Settings.darwin =
  applicationsThatNeedExplicitModifierPresses: ['Microsoft Remote Desktop', 'Royal TSX']
