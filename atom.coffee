pack = Packages.get 'atom'

pack.implement
  scope: 'atom-editor-focused'
,
  'delete:way-left': ->
    isMini = _.find(@currentApplication().editors, {focused: true, mini: true})?
    if not isMini
      @runAtomCommand "trigger", {selector: 'atom-text-editor.is-focused',
      command: 'smarter-delete-line:delete-to-first-character'}, true
    else
      @runAtomCommand 'deleteToBeginningOfLine', null, true

# pack.command 'toggle-quotes',
#   spoken: 'quotely'
#   action: ->
#     @runAtomCommand "trigger",
#       command: 'toggle-quotes:toggle'
#       selector: 'atom-workspace'
#     , true

pack.command "add-project-folder",
  spoken: 'add project folder'
  needsCommand: false
  enabled: true
  action: ->
    @key 'O', 'shift command'

pack.command "command",
  spoken: 'commander'
  needsCommand: false
  description : ""
  aliases : []
  tags : ["my", "atom"]
  continuous: false
  action : (input) ->
    @key 'p', 'command shift'

pack.command "beautify",
  spoken: 'beautify'
  needsCommand: false
  description : ""
  aliases : []
  tags : ["my", "atom"]
  action : (input) ->
    @runAtomCommand 'trigger',
      command: 'atom-beautify:beautify-editor'
      selector: 'atom-text-editor'
    , false

pack.command 'atom-pane-control',
  grammarType: 'custom'
  description : ''
  tags : ["my", "atom"]
  rule: '(paneAction) (pane) (whichPane)'
  variables:
    paneAction: ['fog', 'split']
    pane:
      'pane': 'pane'
      '_pain': 'pane'
    whichPane: ['left', 'right', 'up', 'down']
  action: ({paneAction, whichPane}) ->
    switch paneAction
      when 'fog'
        @key "K", ["command"]
        @key whichPane, ["command"]
      when 'split'
        @key "K", ["command"]
        @key whichPane

pack.command 'kill-pane',
  spoken: "kill pane"
  description : ""
  aliases : []
  tags : ["my", "atom"]
  action : (input) ->
    @key "K", ["command"]
    @key "W", ["command"]

pack.command "atom-tab-control",
  spoken: 'fog tab'
  grammarType : "custom"
  description : ""
  tags : ["my", "atom"]
  rule: '<spoken> (digits)'
  variables:
    digits: _.keys Settings.digits
  action : ({digits}) ->
    @key Settings.digits[digits], ["command"]

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
      console.log "action: #{action}"
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


pack.command "select-scope",
  spoken: 'cell scope'
  scope: 'atom'
  grammarType : "individual"
  description : ""
  aliases : []
  tags : ["my", "atom"]
  misspellings: ['sell scope']
  action : (input) ->
    @runAtomCommand "trigger", {
      selector: 'atom-workspace'
      command: "expand-selection:expand"
    }, true


pack.command "before-next-occurrence",
  spoken: "pre-#{Commands.mapping['selection:next-occurrence'].spoken}"
  grammarType: "singleSearch"
  action: (findable) ->
    @do 'selection:next-occurrence', findable
    @left()
pack.command "after-next-occurrence",
  enabled: true
  spoken: "post #{Commands.mapping['selection:next-occurrence'].spoken}"
  grammarType: "singleSearch"
  action: (findable) ->
    @do 'selection:next-occurrence', findable
    @right()

pack.command "before-previous-occurrence",
  spoken: "pre-#{Commands
  .mapping['selection:previous-occurrence'].spoken}"
  grammarType: "singleSearch"
  action: (findable) ->
    @do 'selection:previous-occurrence', findable
    @left()
pack.command "after-previous-occurrence",
  spoken: "post #{Commands
  .mapping['selection:previous-occurrence'].spoken}"
  grammarType: "singleSearch"
  action: (findable) ->
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
  action: ->
    @runAtomCommand "trigger", {
      selector: '.platform-darwin atom-text-editor.is-focused'
      command: 'bracket-matcher:select-inside-brackets'
    }, true
