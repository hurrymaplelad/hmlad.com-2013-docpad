convict = require 'convict'

settings = convict
  env:
    doc: 'The applicaton environment.'
    format: ['production', 'development', 'test']
    default: 'development'
    env: 'NODE_ENV'

  verbose:
    doc: "Dial the console logging up to 11"
    format: Boolean
    default: false

  # Dev Server Settings
  port:
    format: 'port'
    default: 8000
    env: 'PORT'

  # Selenium Server Settings
  seleniumServer:
    port:
      format: 'port'
      default: 4444
      env: 'SELENIUM_SERVER_PORT'

  # Build Settings
  optimizeAssets:
    format: Boolean
    default: false
.validate()
.get()

settings.devServerUrl = ->
  "http://localhost:#{@port}"

module.exports = settings
