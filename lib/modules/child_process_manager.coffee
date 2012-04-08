ChildProcess = require 'child_process'

module.exports = class ChildProcessManager
  constructor: (options) ->
    @options = options
    @process = null
    @startProcess() if @options.start
    
  startProcess: ->
    return @options.listener.error "Already running" if @process?
    @options.listeners.start() if @options.listeners.start?
    @process = ChildProcess.spawn(@options.command, @options.arguments)
    @process.stdout.on('data', @options.listeners.stdOut) if @options.listeners.stdOut?
    @process.stderr.on('data', @options.listeners.stdErr) if @options.listeners.stdErr?
    @process.on "exit", (code, signal) =>
      if signal is "SIGUSR2"
        @process = null
        @options.listeners.restart() if @options.listeners.restart?
        @startProcess()
      else if code is 0
        @process = null
        @options.listeners.exit(0, signal) if @options.listeners.exit
        @options.listeners.finish signal
      else
        @process = null
        @options.listeners.crash signal
        @options.listeners.exit(code, signal) if @options.listeners.exit
  
  stopProcess: ->
    if @process?
      @options.listeners.stop() if @options.listeners.stop?
      @process.kill()
  
  restartProcess: ->
    if @process? then @process.kill 'SIGUSR2' else @startProcess()