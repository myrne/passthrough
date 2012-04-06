Passthrough =
  Router: require './modules/router'
  Request: require './modules/request'
  Response: require './modules/response'
  ParamExtractor: require './modules/param_extractor'

module.exports = Passthrough

Passthrough.requireSetting = (name) ->
  throw new Error("process.env['#{name}'] is undefined.") if not process.env[name]?
  return process.env[name]