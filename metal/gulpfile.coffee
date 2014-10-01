gulp = require 'gulp'

gulp.task 'generate', (next) ->
  metalsmith = require 'metalsmith'

  metalsmith __dirname
    .use require('metalsmith-markdown')()
    .destination 'build'
    .build next

gulp.task 'clean', ->
  del = require 'del'
  del.sync [
    'build'
  ]

gulp.task 'dev', ['generate'], (next) ->
  connect = require 'connect'
  serveStatic = require 'serve-static'

  connect()
    .use serveStatic 'build'
    .listen 8000, next

gulp.task 'default', ['dev']
