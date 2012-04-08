module.exports = class Event
  constructor: (type, entry, prevStat) ->
    @type = type
    @entry = entry
    @prevStat = prevStat
  
  isChange: ->
    @type == 'change'
    
  isCreation: ->
    @type == 'creation'

  isDeletion: ->
    @type == 'deletion'
    
  toString: ->
    "#{@type} of #{@entry}"