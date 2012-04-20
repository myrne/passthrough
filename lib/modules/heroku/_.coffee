System = require '../system/_'

Herokutools = {}
Herokutools.getAppConfig = (callbacks) ->
  System.run 
    command: 'heroku'
    task: 'config'
    callbacks:
      error: callbacks.error
      success: (output) ->
        outputLines = output.split "\n"
        settings = {}
        pattern = /^(\w+)\s+\=\> (.*)$/
        for line in outputLines
          settings[result[1]] = result[2] if result = line.match pattern
        callbacks.success settings

Herokutools.getAppSetting = (options) ->
  Herokutools.getAppConfig
    error: options.callbacks.error
    success: (config) ->
      return options.callbacks.error "Cannot find #{options.name}" unless config[options.name]
      options.callbacks.success config[options.name]

module.exports = Herokutools