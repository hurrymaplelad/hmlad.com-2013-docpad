convict = require 'convict'
path = require 'path'

settings = convict

  # Dev Server Settings
  port:
    format: 'port'
    default: 8000
    env: 'PORT'

  # Test Settings
  verbose:
    doc: "Dial the console logging up to 11"
    format: Boolean
    default: false
    env: 'VERBOSE'

  bugLike:
    doc: "Helpful pupetteer debug configurations with icky names"
    format: [
      'creeper', # walk slowly through browser tests with window open
      'spider',  # test quickly, but leave window open when it fails
    ]
    default: undefined
    env: 'BUG_LIKE'

  testTimeout:
    doc: "Timeout in milliseconds before failing a test"
    format: 'duration'
    default: '5 seconds'
    env: 'TEST_TIMEOUT'

  chromePath:
    doc: "Path of the (potentially-headless) chrome binary"
    format: String
    default: "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
    env: 'CHROME_PATH'

  # Build Settings
  optimizeAssets:
    format: Boolean
    default: false
.validate()
.get()

settings.devServerUrl = ->
  "http://localhost:#{@port}"

module.exports = settings
