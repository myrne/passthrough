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
  
  pathContains: (searchString) ->
    new RegExp(searchString,"g").test @path
    
  toString: ->
    @path