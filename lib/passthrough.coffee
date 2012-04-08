environ = require 'environ'

Passthrough =
  debug: false
  ParamExtractor: require './modules/param_extractor'
  Router: require './modules/router'
  Request: require './modules/request'
  Response: require './modules/response'
  Core: require './modules/core'

if environ.node()
  currentDir = "."
  Passthrough.ChildProcessManager = require "#{currentDir}/modules/child_process_manager"
  Passthrough.FS = require "#{currentDir}/modules/fs/_"

module.exports = Passthrough

Passthrough.requireSetting = (name) ->
  throw new Error("process.env['#{name}'] is undefined.") if not process.env[name]?
  return process.env[name]

Passthrough.limitCallRate = (maxRate, action) ->
  throw new Error "No action function supplied." unless action? and typeof action == 'function'
  lastCall = undefined
  maxRate = maxRate / 1000 # given in calls per second, but internally calls per milisecond
  minWait = 1 / maxRate
  doAction = ->
    lastCall = new Date
    action()
  dontDoAction = ->
    console.log "Call rate limit in effect." if Passthrough.debug
  return ->
    return doAction() unless lastCall?
    timeBetween = new Date - lastCall
    Passthrough.Core.log "Time between: #{timeBetween}. Min wait: #{minWait}"
    return doAction() if timeBetween > minWait
    return dontDoAction()