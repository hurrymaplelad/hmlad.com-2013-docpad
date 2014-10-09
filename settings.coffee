convict = require 'convict'

settings = convict
  verbose:
    doc: "Dial the console logging up to 11"
    format: Boolean
    default: false

  # Dev Server Settings
  port:
    format: 'port'
    default: 8000
    env: 'PORT'

  # Test Settings
  seleniumServer:
    port:
      format: 'port'
      default: 4444
      env: 'SELENIUM_SERVER_PORT'

  browser:
    format: ['chrome', 'firefox', 'phantomjs']
    default: 'chrome'
    env: 'BROWSER'

  # Build Settings
  optimizeAssets:
    format: Boolean
    default: false
.validate()
.get()

settings.devServerUrl = ->
  "http://localhost:#{@port}"

module.exports = settings
