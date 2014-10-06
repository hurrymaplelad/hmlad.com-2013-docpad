connect = require 'connect'
serveStatic = require 'serve-static'
http = require 'http'

app = connect().use serveStatic('build')
server = http.createServer(app)
module.exports = server
