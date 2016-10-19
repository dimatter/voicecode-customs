pack = Packages.get 'command-line'
Events.on 'willParsePhrase', (container) ->
  if Actions.currentApplication().bundleId in Settings.os.terminalApplications
    container.phrase = container.phrase.replace 'note', 'node'
    container.phrase = container.phrase.replace 'to get', 'get'
    container.phrase = container.phrase.replace 'get the', 'get'
    container.phrase = container.phrase.replace 'pseudo-', 'sudo '
    container.phrase = container.phrase.replace 'secure shell', 'ssh '
    container.phrase = container.phrase.replace 'recall', 'history|grep '
  container

pack.implement
  'os:undo': ->
    @key 'c', 'control'
  'cursor:way-left': ->
    @key 'a', 'control'
  'cursor:way-right': ->
    @key 'e', 'control'
  'object:refresh': ->
    @key 'c', 'control'
    @key 'c', 'control'
    @key 'c', 'control'
    @key 'up'
    @enter()
pack.commands {enabled: true},
  'npm-install':
    spoken: 'npm install'
    action: ->
      @string 'npm install '
  'npm-install-save':
    spoken: 'npm install save'
    action: ->
      @string 'npm install --save'
  'npm-install-development':
    spoken: 'npm install development'
    action: ->
      @string 'npm install --only=dev'
  'clear':
    spoken: 'clear'
    action: ->
      @key 'k', 'command'
  'web-get':
    spoken: 'web get'
    action: ->
      @string 'wget '
  '1-directory-up':
    spoken: 'one up'
    action: ->
      @string '../'
  # 'scan-all-parts':
  #   spoken: 'shell scan all ports'
  #   action: ->
  #     @string 'nmap -sS -sU -PN -p 1-65535 '
  # 'identify-hosts':
  #   spoken: 'shell identify hosts'
  #   action: ->
  #     @string 'nmap -sL /24'
  #     _.times 3, => @left()
  # 'aggressive scan':
  #   spoken: 'shell aggressive scan'
  #   action: ->
  #     @string 'nmap -T4 -A /24'
  #     _.times 3, => @left()
  'list-jails':
    enabled: true
    spoken: 'jail list'
    action: ->
      @string 'jls'
      @do 'common:enter'
      @string 'jexec '
  'switch-to-superuser':
    spoken: 'I am root'
    action: ->
      @string 'sudo su'
      @do 'common:enter'
