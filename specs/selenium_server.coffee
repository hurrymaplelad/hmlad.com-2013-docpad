# extracted from web-chauffeur
{spawn} = require 'child_process'
request = require 'request'
async = require 'async'
{EventEmitter2} = require 'eventemitter2'

class SeleniumServer extends EventEmitter2

  _process: null

  constructor: (@url) ->
    @url ?= 'http://localhost:4444/wd/hub'
    super(wildcard: true)

  log: (level, message) ->
    @emit "log.#{level}", "[selenium-server] #{message}"

  _serverIsUp: (cb) ->
    request.get "#{@url}/status", json: true, timeout: 2000, (err, res) ->
      return cb(err) if err? and err.code isnt 'ECONNREFUSED'
      cb null, (res?.statusCode is 200)

  start: (cb) ->
    @_serverIsUp (err, up) =>
      if up
        @log 'info', 'already running'
        cb()
      else
        @_startServer cb

  # no-op if never started
  stop: (cb) ->
    if not @_process?
      process.nextTick cb
    else
      @_exitCb = ->
        @log 'info', 'stopped'
        cb()
      @log 'info', 'stopping...'
      @_process.kill()

  _startServer: (cb) ->
    @log 'info', 'starting...'
    @_process = spawn 'selenium-server'

    # ensure selenium shuts down if we exit unexpectedly
    process.once 'exit', =>
      @_process?.kill "SIGTERM"

    @_process.on 'exit', @_onExit.bind(@)

    @_process.stderr.on 'data', (data) =>
      @log 'debug', "[stderr] #{data.toString()}"

    @_process.stdout.on 'data', (data) =>
      @log 'debug', "[stdout] #{data.toString()}"

    # wait for it to boot
    remainingTries = 10
    async.forever (next) =>
      @_serverIsUp (err, up) =>
        return cb(err) if err?
        if up
          @_started = true
          @log 'info', 'started'
          cb()
        else
          if --remainingTries
            setTimeout(next, 1000) # sleep 1
          else
            cb new Error('timeout waiting for selenium-server to start')

  _onExit: (code) ->
    @_process = null
    return @_exitCb() if code in [0, 143] and @_exitCb? # happy path exit 0 or SIGTERM
    error = new Error("selenium-server exited unexpectedly with code #{code}")
    @_exitCb?(error)
    @emit 'error', error

module.exports = SeleniumServer
