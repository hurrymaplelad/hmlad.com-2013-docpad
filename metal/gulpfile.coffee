gulp = require 'gulp'

gulp.task 'generate', (next) ->
  metalsmith = require 'metalsmith'
  markdown = require 'metalsmith-markdown'
  teacup = require 'metalsmith-teacup'
  collections = require 'metalsmith-collections'
  paginate = require 'metalsmith-collections-paginate'
  permalinks = require 'metalsmith-permalinks'
  jekyllDates = require 'metalsmith-jekyll-dates'

  metalsmith __dirname

    .use markdown()
    .use collections
      posts:
        pattern: 'posts/*'
        sortBy: 'date'
        reverse: true

    .use paginate
      posts:
        perPage: 10
        first: 'index.html'
        path: 'posts/:num/index.html'
        template: 'posts'


    .use jekyllDates()
    .use permalinks
      relative: false
      pattern: ':slug'

    # Absolute paths, trailing slashes
    .use (files, metalsmith, done) ->
      for filename, file of files
        file.path = '/' + file.path
        if file.path.length > 1
          file.path += '/'
      done()

    # Teacup
    .use teacup()

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
