gulp = require 'gulp'

gulp.task 'generate', (next) ->
  metalsmith = require 'metalsmith'
  markdown = require 'metalsmith-markdown'
  teacup = require 'metalsmith-teacup'
  collections = require 'metalsmith-collections'
  paginate = require 'metalsmith-collections-paginate'
  permalinks = require 'metalsmith-permalinks'
  jekyllDates = require 'metalsmith-jekyll-dates'
  more = require 'metalsmith-more'
  assets = require 'metalsmith-assets'

  metalsmith __dirname
    .source 'documents'
    .metadata
      site:
        title: 'HurryMapleLad'
        author: 'Adam Hull'
        url: 'http://hurrymaplelad.com'
        googleAnalytics:
          id: 'UA-35976996-1'

    .use jekyllDates()
    .use markdown()
    .use more()
    .use (files, metalsmith, done) ->
      for file in files
        file.contentsWithoutLayout = file.contents
      done()
    .use collections
      posts:
        pattern: 'posts/*'
        sortBy: 'date'
        reverse: true

    .use paginate
      posts:
        perPage: 20
        first: 'index.html'
        path: 'posts/:num/index.html'
        template: 'posts'


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

    .use assets
      source: 'static'
      destination: '.'

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
