pack = Packages.get 'atom'

# smarter-delete-line package
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

# toggle quotes package, does not work for some reason
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
  description : ""
  aliases : []
  tags : ["my", "atom"]
  action : (input) ->
    @key "K", ["command"]
    @key "W", ["command"]

pack.command "atom-tab-control",
  spoken: 'fog'
  grammarType : "custom"
  description : ""
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

# expense selection package
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

pack.implement
  'common:find-next': ->
    @runAtomCommand 'trigger', {
      selector: '.preview-pane.project-find-navigation'
      command: 'project-find-navigation:show-next'
    }
  'common:find-previous': ->
    @runAtomCommand 'trigger', {
      selector: '.preview-pane.project-find-navigation'
      command: 'project-find-navigation:show-prev'
    }
