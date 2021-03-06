environ = require 'environ'

Passthrough =
  debug: false
  ParamExtractor: require './modules/param_extractor'
  Router: require './modules/router'
  Request: require './modules/request'
  Response: require './modules/response'
  Core: require './modules/core'

if environ.node()
  ptModules =
    System: "system/_"
    Heroku: "heroku/_"
    MongoDB: "mongodb/_"
    Process: "process/_"
    FS: "fs/_"
  Passthrough[moduleName] = require "./modules/#{filePath}" for moduleName, filePath of ptModules

module.exports = Passthrough

Passthrough.requireSetting = (name) ->
  throw new Error "process.env['#{name}'] is undefined." if not process.env[name]?
  return process.env[name]

Passthrough.limitCallRate = (maxRate, action, throttleAction) ->
  throw new Error "No action function supplied." unless action? and typeof action == 'function'
  lastCallTime = undefined
  maxRate = maxRate / 1000 # given in calls per second, but internally calls per milisecond
  minWait = 1 / maxRate
  doAction = ->
    lastCallTime = new Date
    action()
  dontDoAction = (timeBetween, minWait) ->
    throttleAction? timeBetween, minWait
  return ->
    return doAction() unless lastCallTime?
    timeBetween = new Date - lastCallTime
    return doAction() if timeBetween > minWait
    return dontDoAction timeBetween, minWait