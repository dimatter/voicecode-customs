pack = Packages.get 'atom'

# smarter-delete-line package
pack.implement
  scope: 'atom-editor-focused'
,
  'clipboard:copy': ->
    @atomBuffer = @runAtomCommand 'getSelection', {}, true
  'clipboard:paste': ->
    @string @atomBuffer
  'delete:way-left': ->
    isMini = _.find(@currentApplication().editors, {focused: true, mini: true})?
    if not isMini
      @runAtomCommand "trigger", {selector: 'atom-text-editor.is-focused',
      command: 'smarter-delete-line:delete-to-first-character'}, true
    else
      @runAtomCommand 'deleteToBeginningOfLine', null, true

# toggle quotes package
pack.command 'toggle-quotes',
  scope: 'atom-editor-focused'
  spoken: 'quotely'
  enabled: true
  tags : ["my", "atom"]
  action: ->
    @runAtomCommand "trigger",
      command: 'toggle-quotes:toggle'
      selector: 'atom-text-editor'
    , true

pack.command "add-project-folder",
  spoken: 'add project folder'
  needsCommand: false
  tags : ["my", "atom"]
  enabled: true
  action: ->
    @runAtomCommand 'trigger',
      command: 'application:add-project-folder'
      selector: 'body'
    , true


pack.command "command",
  spoken: 'commander'
  needsCommand: false
  tags : ["my", "atom"]
  continuous: false
  action : (input) ->
    @runAtomCommand 'trigger',
      command: 'command-palette:toggle'
      selector: 'atom-workspace'
    , true

pack.command "beautify",
  spoken: 'beautify'
  scope: 'atom-editor-focused'
  needsCommand: false
  tags : ["my", "atom"]
  action : (input) ->
    @runAtomCommand 'trigger',
      command: 'atom-beautify:beautify-editor'
      selector: 'atom-workspace'
    , false

pack.command 'atom-pane-control',
  grammarType: 'custom'
  tags : ["my", "atom"]
  rule: '(paneAction) (whichPane) (whichPane)?'
  variables:
    paneAction: ['fog', 'split']
    whichPane: ['left', 'right', 'up', 'down']
  action: ({paneAction, whichPane, whichPane1}) ->
    times = if whichPane1?  then 2 else 1
    which = [whichPane, whichPane1]
    _.times times, (index) =>
      w = which[index]
      switch paneAction
        when 'fog'
          @key "K", ["command"]
          @key w, ["command"]
        when 'split'
          @key "K", ["command"]
          @key w

pack.command 'kill-pane',
  spoken: "kill pane"
  tags : ["my", "atom"]
  action : (input) ->
    @key "K", ["command"]
    @key "W", ["command"]

pack.command "atom-tab-control",
  spoken: 'fog'
  grammarType : "custom"
  tags : ["my", "atom"]
  rule: '<spoken> (numbers)'
  variables:
    numbers: _.take (_.values Settings.modifiers.modifierSuffixes), 9
  action : ({numbers: number}) ->
    @key _.findKey(Settings.modifiers.modifierSuffixes
    , _.matches(number)), ["command"]

global.Commands.mapping['common:find'].grammarType = 'custom'
global.Commands.mapping['common:find'].rule = '<spoken> (findAction)?'
global.Commands.mapping['common:find'].variables = {
  findAction: ["next", "reg", "case", "selection", "replace all", "project"]
}
pack.implement
  'common:find': ({findAction}, context) ->
    unless findAction?
      @key "f", ["command"]
    else
      action = @fuzzyMatch(["next", "reg", "case",
       "selection", "replace all", "project"], findAction)
      switch action
        when "next"
          @key "g", "command"
        when "reg"
          @key "/", ["option", "command"]
        when "case"
          @key "c", ["option", "command"]
        when "selection"
          @key "s", ["option", "command"]
        when "replace all"
          @key "return", ["command"]
        when "project"
          @key "f", ["command", "shift"]
  'object:duplicate': (input, context) ->
    @runAtomCommand "trigger", {selector: 'atom-workspace',
    command: 'duplicate-line-or-selection:duplicate'}, true

# last cursor position package
pack.command "travel-previous",
  enabled: true
  spoken: 'travel'
  grammarType: 'integerCapture'
  tags : ["my", "atom"]
  action : (input) ->
    input ?= 1
    _.times input, (index) =>
      @runAtomCommand "trigger", {
        selector: 'atom-workspace'
        command: "last-cursor-position:previous"
      }, true
pack.command "travel-next",
  enabled: true
  spoken: 'trevor'
  grammarType: 'integerCapture'
  tags : ["my", "atom"]
  action : (input) ->
    input ?= 1
    _.times input, =>
      @runAtomCommand "trigger", {
        selector: 'atom-workspace'
        command: "last-cursor-position:next"
      }, true

# expand selection package
pack.command "select-scope",
  spoken: 'cell scope'
  tags : ["my", "atom"]
  misspellings: ['sell scope']
  action : (input) ->
    @runAtomCommand "trigger", {
      selector: 'atom-workspace'
      command: "expand-selection:expand"
    }, true
pack.command 'delete-scope',
  spoken: 'drainer'
  tags : ["my", "atom"]
  misspellings: ['trainer']
  action: ->
    @do 'atom:select-scope'
    @do 'common:delete'

pack.command "before-next-occurrence",
  spoken: "pre-#{Commands.mapping['selection:next-occurrence'].spoken}"
  tags : ["my", "atom"]
  grammarType: "singleSearch"
  action: (findable) ->
    @right()
    @do 'selection:next-occurrence', findable
    @left()
pack.command "after-next-occurrence",
  enabled: true
  spoken: "post #{Commands.mapping['selection:next-occurrence'].spoken}"
  tags : ["my", "atom"]
  grammarType: "singleSearch"
  action: (findable) ->
    @do 'selection:next-occurrence', findable
    @right()

pack.command "before-previous-occurrence",
  spoken: "pre-#{Commands
  .mapping['selection:previous-occurrence'].spoken}"
  tags : ["my", "atom"]
  grammarType: "singleSearch"
  action: (findable) ->
    @do 'selection:previous-occurrence', findable
    @left()
pack.command "after-previous-occurrence",
  spoken: "post #{Commands
  .mapping['selection:previous-occurrence'].spoken}"
  tags : ["my", "atom"]
  grammarType: "singleSearch"
  action: (findable) ->
    @left()
    @do 'selection:previous-occurrence', findable
    @right()

pack.command 'go-to-matching-bracket',
  spoken: 'brax match'
  enabled: true
  action: ->
    @runAtomCommand "trigger", {
      selector: '.platform-darwin atom-text-editor.is-focused'
      command: 'bracket-matcher:go-to-matching-bracket'
    }, true
pack.command 'select-inside-brackets',
  spoken: 'grab brax'
  enabled: true
  tags : ["my", "atom"]
  action: ->
    @runAtomCommand "trigger", {
      selector: '.platform-darwin atom-text-editor.is-focused'
      command: 'bracket-matcher:select-inside-brackets'
    }, true

pack.command 'single-quotes-around-next-word',
  spoken: 'posh neck'
  enabled: true
  tags : ["my", "atom"]
  action: ->
    @do 'selection:next-word'
    @string "'"
pack.command 'double-quotes-around-next-word',
  spoken: 'coyf neck'
  enabled: true
  tags : ["my", "atom"]
  action: ->
    @do 'selection:next-word'
    @string '"'
pack.command 'single-quotes-around-previous-word',
  spoken: 'posh preev'
  enabled: true
  tags : ["my", "atom"]
  action: ->
    @do 'selection:previous-word'
    @string "'"
pack.command 'double-quotes-around-previous-word',
  spoken: 'coyf preev'
  enabled: true
  tags : ["my", "atom"]
  action: ->
    @do 'selection:previous-word'
    @string '"'

# coffee paste package
pack.command 'coffee-paste-package',
  tags : ["my", "atom"]
  grammarType: 'custom'
  enabled: true
  rule: '(coffeePasteAction) as (coffeePasteLanguage)'
  variables:
    coffeePasteAction: ['copy', 'paste']
    coffeePasteLanguage: ['coffee', 'java']
  action: ({coffeePasteAction, coffeePasteLanguage})->
    if coffeePasteAction is 'copy' and coffeePasteLanguage is 'coffee'
      action = 'js2Coffee'
    if coffeePasteAction is 'copy' and coffeePasteLanguage is 'java'
      action = 'coffee2Js'
    if coffeePasteAction is 'paste' and coffeePasteLanguage is 'coffee'
      action = 'asCoffee'
    if coffeePasteAction is 'paste' and coffeePasteLanguage is 'java'
      action = 'asJs'
    @runAtomCommand "trigger", {
      selector: 'atom-workspace'
      command: "coffee-paste:#{action}"
    }, false

Events.on 'currentApplicationWillChange', ({from, to}) ->
  ourBundle = pack.options.applications[0]
  if to.bundleId is ourBundle and from.bundleId isnt ourBundle
    Actions.atomBuffer = Actions.getClipboard()
  if from.bundleId is ourBundle and to.bundleId isnt ourBundle
    if Actions.atomBuffer?
      Actions.setClipboard Actions.atomBuffer
      Actions.atomBuffer = null
  arguments[0]
pack.implement
  # project find navigation package
  'common:find-next': ->
    @runAtomCommand 'trigger', {
      selector: '.preview-pane.project-find-navigation'
      command: 'project-find-navigation:show-next'
    }, false
  # project find navigation package
  'common:find-previous': ->
    @runAtomCommand 'trigger', {
      selector: '.preview-pane.project-find-navigation'
      command: 'project-find-navigation:show-prev'
    }, false
  'window:close': ->
    @runAtomCommand 'trigger', {
      command: 'core:close'
      selector: 'body'
    }, false
  'object:next': ->
    @runAtomCommand 'trigger', {
      command: 'pane:show-next-item'
      selector: 'body'
    }, true
  'object:previous': ->
    @runAtomCommand 'trigger', {
      command: 'pane:show-previous-item'
      selector: 'body'
    }, true
  'selection:all': ->
    @runAtomCommand 'trigger', {
      command: 'core:select-all'
      selector: 'atom-text-editor.is-focused'
    }, true
  'delete:partial-word': ->
    @runAtomCommand 'trigger', {
      command: 'editor:delete-to-beginning-of-subword'
      selector: 'atom-text-editor.is-focused'
    }, true
  'delete:partial-word-forward': ->
    @runAtomCommand 'trigger', {
      command: 'editor:delete-to-end-of-subword'
      selector: 'atom-text-editor.is-focused'
    }, true
  'cursor:partial-word-right': ->
    @runAtomCommand 'trigger', {
      command: 'editor:move-to-next-subword-boundary'
      selector: 'atom-text-editor.is-focused'
    }, true
  'cursor:partial-word-left': ->
    @runAtomCommand 'trigger', {
      command: 'editor:move-to-previous-subword-boundary'
      selector: 'atom-text-editor.is-focused'
    }, true
