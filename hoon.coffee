return
hoon = Packages.register
  name: 'hoon'
  description: 'Hoon language'
  condition: ->
    editor = _.find(@currentApplication().editors, {focused: true})
    return false unless editor?
    result = _.difference ['source.hoon'], editor.scopes
    result.length isnt 1

# Chain.preprocess hoon, (chain) ->
#   _.reduce chain, (newChain, link, index) ->
#     newChain.push link
#     link = _.last newChain
#     if link.command is 'core:literal'
#       link.arguments = _.map link.arguments, (arg) ->
#         if arg is 'comment'
#           return '::'
#         else if arg is 'constance'
#           return 'const '
#         else if arg is 'constant'
#           return 'const '
#         else if arg is 'letter'
#           return 'let '
#         else
#           return arg
#     if link.command is 'symbols:single-right-arrow'
#       link.command = 'core:literal'
#       link.arguments = ['function']
#
#     newChain
#   , []

# map =
#   gap: 'common:enter'
#   ace: 'symbols:space'
#   gal: 'symbols:left-angle'             # <
#   gar: 'symbols:right-angle'            # >
#   pal: 'symbols:left-parentheses'       # (
#   par: 'symbols:right-parentheses'      # )
#   bar: 'symbols:vertical-bar'           # |
#   bas: 'symbols:backslash'              # \
#   sel: 'symbols:left-bracket'           # [
#   ser: 'symbols:right-bracket'          # ]
#   buc: 'symbols:dollar'                 # $
#   hax: 'symbols:hashtag'                # #
#   sem: 'symbols:semicolon'              # ;
#   cab: 'symbols:underscore'             # _
#   hep: 'symbols:minus'                  # -
#   cen: 'symbols:percent'                # %
#   kel: 'symbols:left-brace'             # {
#   ker: 'symbols:right-brace'            # }
#   soq: 'symbols:double-quote'           # '
#   com: 'symbols:comma'                  # ,
#   ket: 'symbols:caret'                  # ^
#   tar: 'symbols:star'                   # *
#   doq: 'symbols:double-quote'           # "
#   lus: 'symbols:plus'                   # +
#   tec: 'symbols:backtick'               # `
#   dot: 'symbols:dot'                    # .
#   pam: 'symbols:ampersand'              # &
#   tis: 'symbols:equal'                  # =
#   fas: 'symbols:slash'                  # /
#   pat: 'symbols:at'                     # @
#   wut: 'symbols:question-mark'          # ?
#   zap: 'symbols:exclamation'            # !
#
# sigils = _.keys map
#
# hoon.command 'runes',
#   rule: '(sigils)(sigils)'
#   grammarType: 'custom'
#   enabled: false
#   variables:
#     sigils: sigils
#   action: ({sigils, sigils1})->
#     @do map[sigils]
#     @do map[sigils1]
