renameList =
  'symbols:left-brace': 'kirk ling'
  'symbols:right-brace': 'kirk ring'
  'symbols:left-bracket': 'brack ling'
  'symbols:right-bracket': 'brack ring'
  'symbols:left-parentheses': 'prex ling'
  'symbols:right-parentheses': 'prex ring'
  'symbols:single-quote': 'posh ling'
  'symbols:double-quote': 'coyf ling'
  'symbols:right-angle': 'gray ling'
  'symbols:left-angle': 'less ling'
  'symbols:parentheses': 'prex way'
  'symbols:space': 'prank'
  'symbols:surround-spaces': 'skoosh'
  'cursor:left': 'licky'
  'cursor:way-right': 'rex'
  'cursor:right': 'ricky'
  'selection:left': 'shlicky'
  'selection:right': 'shricky'
  'cursor:word-left': 'locky'
  'cursor:word-right': 'rocky'
  'selection:word-left': 'shlocky'
  'selection:word-right': 'shrocky'
  'cursor:way-left': 'lex'
  'selection:way-left': 'shlex'
  'selection:way-right': 'shrex'
  'cursor:way-up': 'jeep way'
  'cursor:way-down': 'doom way'
  'format:dots': 'dot way'
  'selection:way-down': 'shroom way'
  'selection:way-up': 'shreep way'
  'scrolling:way-up': 'scroop way'
  'scrolling:way-down': 'scrodge way'
  'object:next': 'go neck'
  'object:previous': 'go preev'
  'selection:next-word': 'word neck'
  'selection:previous-word': 'word preev'
  'selection:previous-word-by-surrounding-characters': 'trap preev'
  'selection:next-word-by-surrounding-characters': 'trap neck'
  'selection:range-on-current-line': 'kerr lack'
  'selection:range-upward': 'jeep lack'
  'selection:range-downward': 'doom lack'
  'selection:extend-to-next-occurrence': 'sell crew'
  'selection:extend-to-previous-occurrence': 'sell trail'
  'editor:extend-selection-to-line-number': 'sell till'
  'symbols:colon-space': 'call gap'
  'clipboard:select-all-copy': 'all stoosh'
  'clipboard:select-all-paste': 'all spark'
  'editor:insert-from-line-number': 'clone cert'
  'window:new-tab': 'tabby'
  'window:close': 'torch'
  'symbols:at': 'pluto'
  'cursor:new-line-below': 'slap'
  'symbols:surround-double-quotes': 'coyf'
  'symbols:ampersand': 'pam'
  'symbols:hashtag': 'pound'
  'symbols:exclamation': 'claymore'
  'symbols:comma-space': 'swipe'
  'text-manipulation:move-line-down': 'swoom'
  'text-manipulation:move-line-up': 'sweep'
_.each renameList, (value, key, list) ->
  Commands.changeSpoken key, value

Commands.addMisspellings 'text-manipulation:move-line-up', ['sweeple', 'weep', 'weap']
Commands.addMisspellings 'symbols:at', ['ludo']
Commands.addMisspellings 'symbols:comma-space', ['swype']
Commands.addMisspellings 'symbols:surround-double-quotes', ['coif']
Commands.addMisspellings 'common:escape', ['rendell', 'randel']
Commands.addMisspellings 'symbols:dot', ['doug']
Commands.addMisspellings 'format:capitalize-next-word', ['cham', 'champs']
Commands.addMisspellings 'selection:all', ['ali', 'olie']
Commands.addMisspellings 'common:enter', ['chuck', 'shop']
Commands.addMisspellings 'core:delimiter', ['shannon']
Commands.addMisspellings 'symbols:double-vertical-bar-padded', ['goalposts']
Commands.addMisspellings 'format:camel', ['graham', 'crime', 'creme']
Commands.addMisspellings 'selection:extend-to-next-occurrence', ['cell crew']
Commands.addMisspellings 'selection:extend-to-previous-occurrence', ['cell trail']
Commands.addMisspellings 'format:dots', ['dotsway', 'dots way']
Commands.addMisspellings 'symbols:double-quote', ['coif ring', 'coyf ring']
Commands.addMisspellings 'symbols:single-quote', ['posh ring']
Commands.addMisspellings 'symbols:single-right-arrow', ['lembo']
Commands.addMisspellings 'symbols:space', ['frank', 'pranks', 'prick', 'brink']
Commands.addMisspellings 'symbols:right-angle', ['grayling']
Commands.addMisspellings 'symbols:colon', ['colin']
Commands.addMisspellings 'symbols:surround-single-quotes', ['plush', 'bosch']
Commands.addMisspellings 'common:delete', ['john']
Commands.addMisspellings 'delete:way-left', ['nipple']
Commands.addMisspellings 'repetition:command-2', ['snoop']
Packages.get('alphabet').settings {letters: {r: 'rush', m: 'mish'}}
