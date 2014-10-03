gulp = require 'gulp'

gulp.task 'generate', (next) ->
  assets = require 'metalsmith-assets'
  collections = require 'metalsmith-collections'
  jekyllDates = require 'metalsmith-jekyll-dates'
  markdown = require 'metalsmith-markdown'
  metallic = require 'metalsmith-metallic'
  metalsmith = require 'metalsmith'
  more = require 'metalsmith-more'
  paginate = require 'metalsmith-collections-paginate'
  permalinks = require 'metalsmith-permalinks'
  teacup = require 'metalsmith-teacup'

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
  .use metallic()
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
  .clean false # handled by gulp
  .build next

gulp.task 'styles', ->
  nib = require 'nib'
  stylus = require 'gulp-stylus'
  rename = require 'gulp-rename'

  gulp.src 'styles/rollup.styl'
  .pipe stylus use: nib()
  .pipe rename 'main.css'
  .pipe gulp.dest 'build/styles'

gulp.task 'clean', ->
  del = require 'del'
  del.sync [
    'build'
  ]

gulp.task 'serve', (next) ->
  connect = require 'connect'
  serveStatic = require 'serve-static'

  connect()
    .use serveStatic 'build'
    .listen 8000, next

gulp.task 'open', ['dev'], (next) ->
  open = require 'open'
  open "http://localhost:8000"

gulp.task 'dev', ['generate', 'styles', 'serve']

gulp.task 'default', ['dev']
