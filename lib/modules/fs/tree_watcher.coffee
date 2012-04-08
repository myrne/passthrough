_ = require 'underscore'
watch = require 'watch'

Event = require './event'
Entry = require './entry'

Core = require '../core'

functionGenerators =
  treeWalkFilter: require './entry_filter'
  eventFilter: require './event_filter'

module.exports = class TreeWatcher
  constructor: (options) ->
    @monitor = null
    @options = _.defaults options, root: process.cwd()
    @options = Core.makeFunctional @options, functionGenerators
    watchOptions = {}
    if options.treeWalkFilter?
      watchOptions.filter = (path, stat) => @options.treeWalkFilter(new Entry(path,stat))
    watch.createMonitor options.root, watchOptions, (monitor) =>
      @monitor = monitor
      @monitor.on "created", (entryPath, currStat) => @handle 'creation', entryPath, currStat
      @monitor.on "changed", (entryPath, currStat, prevStat) => @handle 'change', entryPath, currStat, prevStat
      @monitor.on "removed", (entryPath, currStat) => @handle 'removal', entryPath, currStat

  filter: (event) ->
    return true if @options.entryFilter? and @options.entryFilter event.file
    return true if @options.eventFilter? and @options.eventFilter event
    
  handle: (eventType, entryPath, currStat, prevStat) ->
    event = new Event(eventType, new Entry(entryPath, currStat), prevStat)
    if @filter event
      Core.log "Rejected #{event}"
    else
      @options.action event