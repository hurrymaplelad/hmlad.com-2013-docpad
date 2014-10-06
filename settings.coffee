convict = require 'convict'

settings = convict
  env:
    doc: 'The applicaton environment.'
    format: ['production', 'development', 'test']
    default: 'development'
    env: 'NODE_ENV'

  # Dev Server Settings
  port:
    format: 'port'
    default: 8000
    env: 'PORT'

  # Build Settings
  optimizeAssets:
    format: Boolean
    default: false
.validate()
.get()

settings.devServerUrl = ->
  "http://localhost:#{@port}"

module.exports = settings
