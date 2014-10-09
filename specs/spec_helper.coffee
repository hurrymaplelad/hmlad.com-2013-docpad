wd = require 'wd'
chai = require 'chai'
asPromsed = require 'chai-as-promised'
settings = require '../settings'

asPromsed.transferPromiseness = wd.transferPromiseness

chai
  .use asPromsed
  .should()

before ->
  @browser = wd.promiseChainRemote()
    # .on 'status', (info) ->
    #   console.log '[INFO]', info
    # .on 'command', (eventType, command, response) ->
    #   console.log ' > ' + eventType, command, (response || '')
    # .on 'http', (meth, path, data) ->
    #   console.log '[HTTP]', meth, path, (data || '')
    .init
      browserName: settings.browser
    .configureHttp
      baseUrl: settings.devServerUrl()

after ->
  @browser.quit()
