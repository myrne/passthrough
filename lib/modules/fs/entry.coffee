fs = require 'fs'

module.exports = class FSEntry
  constructor: (path, stat) ->
    @path = path
    @stat = if stat? then stat else fs.statSync path

  isDirectory: ->
    @stat.isDirectory()
  
  isFile: ->
    @stat.isfile()
  
  isSocket: ->
    @stat.isSocket()
  
  isSymbolicLink: ->
    @stat.isSymbolicLink()

  isDotfile: ->
    new RegExp("/\\..+$").test @path
  
  hasExtension: (ext) ->
    new RegExp("\\.#{ext}$").test @path
  
  hasName: (name) ->
    new RegExp("#{name}$").test @path
  
  hasPath: (path) ->
    @path is path
    
  entryNames: ->
    throw new Error "#{@path} is not a directory." unless @isDirectory()
    fs.readdirSync @path
    
  getEntry: (entryName) ->
    new FSEntry "#{@path}/#{entryName}"
  
  pathContains: (searchString) ->
    new RegExp(searchString,"g").test @path
    
  toString: ->
    @path