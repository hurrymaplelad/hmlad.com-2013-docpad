wd = require 'wd'
chai = require 'chai'
asPromsed = require 'chai-as-promised'
settings = require '../settings'
{parallel} = require 'async'

asPromsed.transferPromiseness = wd.transferPromiseness

chai
  .use asPromsed
  .should()

before ->
  @devServer = require '../dev_server'

before ->
  SeleniumServer = require './selenium_server'
  @seleniumServer = new SeleniumServer()
  @seleniumServer.on 'log.info', (message) -> console.log message

before (done) ->
  parallel [
    (done) => @seleniumServer.start done
    (done) => @devServer.listen settings.port, done
  ], done

before ->
  @browser = wd.promiseChainRemote()
    # .on 'status', (info) ->
    #   console.log '[INFO]', info
    # .on 'command', (eventType, command, response) ->
    #   console.log ' > ' + eventType, command, (response || '')
    # .on 'http', (meth, path, data) ->
    #   console.log '[HTTP]', meth, path, (data || '')
    .init
      browserName: 'chrome'
    .configureHttp
      baseUrl: settings.devServerUrl()

after ->
  @browser.quit()

after (done) ->
  parallel [
    (done) => @devServer.close(done)
    (done) => @seleniumServer.stop(done)
  ], (err) -> done() # squash errors
