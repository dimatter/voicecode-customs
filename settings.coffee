Events.suppressedLogEntries.push /^mouse.leftClick$/
Events.suppressedLogEntries.push /^keyboard.keyUp$/
Events.suppressedLogEntries.push /^systemEventHandler$/

# _.merge Settings,
#     codeSnippets:
#       'component did mount': 'cdm'
#       'component did update': 'cdup'
#       'component will mount': 'cwm'
#       'component will receive props': 'cwr'
#       'component will update': 'cwu'
#       'component will unmount': 'cwun'
#       'get initial state': 'gis'
#       'get default props': 'gnp'
#       'force update': 'fup'
#       'props': 'props'
#       'prop types': 'pt'
#       'prop type array': 'pta'
#       'prop type any': 'ptany'
#       'prop type bull': 'ptb'
#       'prop type element': 'pte'
#       'prop type function': 'ptf'
#       'prop type number': 'ptn'
#       'prop type node': 'ptnode'
#       'prop type object': 'pto'
#       'prop type string': 'pts'
#       'prop type shape': 'ptshape'
#       'react class': 'rcd'
#       'react component': 'rcc'
#       'react render': 'ren'
#       'react render component': 'rrc'
#       'should component update': 'scu'


ensureRepeatable = [
  'cursor:up'
  'cursor:down'
  'cursor:left'
  'cursor:right'
  'common:delete'
  'delete:word'
  'delete:word-forward'
]
_.each ensureRepeatable, (cmd) ->
  Commands.get(cmd).repeatable = true


_.extend Settings,
    core:
      slaves:
        development: ["localhost", 31337]
    vocabulary:
      vocabulary: require './vocabulary'
      vocabularyAlternate: require './vocabulary_alternate'
      translations: require './translations'
      sequences: require './common_sequences'
    web:
      websites: require './websites'
    insert:
      emails: require './mails'
      usernames: require './usernames'
      abbreviations: require './abbreviations'
      passwords: require './passwords'
    application:
      applications:
        'vox': 'VOX'
        'table' : 'LightTable' ,
        'fusion' : 'VMware Fusion' ,
        'torrent' : 'Transmission',
        'atomic' : 'Atom'
        'atom' : 'Atom'
        'spotify' : 'Spotify'
        'vlc' : 'VLC'
        'finder' : 'Path Finder'
        'notes' : 'Notes'
        'telegram': 'Telegram'
        'hub': 'MongoHub'
        'slack': 'Slack'
      firstNameBasis:
        chromie: "Google Chrome"
        termite: "iTerm"
        atom: "Atom"
        canary: 'Google Chrome Canary'
        telegram: 'Telegram'
        finder: 'Path Finder'
        vivi: 'Vivaldi'
        foxy: 'FirefoxDeveloperEdition'
        slacker: 'Slack'
        sorcerer: 'SourceTree'
    darwin:
      applicationsThatNeedExplicitModifierPresses: [
        'Screen Sharing'
      ]
    os:
      applicationsThatCanNotHandleBlankSelections: [
        'Mancy'
        'LightTable'
      ]
    'strict-mode':
      modes:
        default: ['scrolling:up', 'scrolling:down']
