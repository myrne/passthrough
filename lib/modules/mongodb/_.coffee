url = require 'url'
System = require '../system/_'

MongoDB = {}
MongoDB.parseConnectionString = (connString) ->
  parsed = url.parse connString
  info = {}
  info.hostname = parsed.hostname
  info.port = parsed.port
  info.host = if info.port then "#{info.hostname}:#{info.port}" else info.hostname
  info.database = info.db = parsed.pathname && parsed.pathname.replace(/\//g, '')
  [info.username,info.password] = parsed.auth.split(':') if parsed.auth
  info

MongoDB.dumpDatabase = (options) ->
  connInfo = MongoDB.parseConnectionString options.connectionString
  commandOptions = makeCommandOptions connInfo
  commandOptions.out = options.dumpDirectory
  System.run
    command: 'mongodump'
    options: commandOptions
    callbacks: options.callbacks

MongoDB.restoreDatabase = (options) ->
  connInfo = MongoDB.parseConnectionString options.connectionString
  commandOptions = makeCommandOptions connInfo
  commandOptions.drop = true
  console.log commandOptions
  System.run
    command: 'mongorestore'
    object: options.dumpDirectory
    options: commandOptions
    callbacks: options.callbacks

module.exports = MongoDB

makeCommandOptions = (connInfo) ->
  options = {}
  options.db = connInfo.db
  options.host = connInfo.host unless connInfo.host is "localhost"
  options.password = connInfo.password if connInfo.password
  options.username = connInfo.username if connInfo.username
  options