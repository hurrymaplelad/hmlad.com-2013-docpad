gulp = require 'gulp'
gutil = require 'gulp-util'
settings = require './settings'

gutil.log 'Settings:'
for key, value of settings when typeof value isnt 'function'
  gutil.log gutil.colors.cyan(key), gutil.colors.magenta(value)
settings

gulp.task 'generate', (next) ->
  assets = require 'metalsmith-assets'
  collections = require 'metalsmith-collections'
  feed = require 'metalsmith-feed'
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
    # Snapshot contents before rendering
    for name, file of files
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

  .use feed collection: 'posts'

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
  .pipe stylus
    use: nib()
    compress: settings.optimizeAssets
    linenos: !settings.optimizeAssets
  .pipe rename 'main.css'
  .pipe gulp.dest 'build/styles'

gulp.task 'clean', ->
  del = require 'del'
  del.sync ['build', 'release']

gulp.task 'build', ['generate', 'styles']

gulp.task 'serve', (done) ->
  devServer = require './dev_server'
  devServer.listen settings.port, done

gulp.task 'spec', ['build'], (done) ->
  {spawn} = require 'child_process'
  specFiles = 'specs/*.spec.coffee'
  mocha = spawn 'mocha', ['--opts', 'specs/mocha.opts', specFiles], stdio: 'inherit'
  .on 'exit', (code) ->
    done code or null

gulp.task 'watch', ->
  watch = require 'este-watch'
  watch ['documents', 'templates', 'styles', 'static'], (e) ->
    gutil.log 'Changed', gutil.colors.cyan e.filepath
    switch e.extension
      when 'styl'
        gulp.start 'styles'
      else
        gulp.start 'generate'
  .start()

gulp.task 'dev', ['build', 'serve', 'watch']

gulp.task 'open', ['dev'], ->
  open = require 'open'
  open settings.devServerUrl()

gulp.task 'assert:clean', (done) ->
  git = require 'gift'

  git('.').status (err, status) ->
    switch
      when err
        done err
      when not status?.clean
        console.error JSON.stringify status?.files, null, 2
        done new Error 'Cant publish uncommitted changes'
      else
        done()

publish = ({push}={}) ->
  git = require 'gift'
  end = require 'stream-end'
  ghPages = require 'gulp-gh-pages'

  (done) ->
    git('.').current_commit (err, commit) ->
      sourceId = commit.id[...12]
      gulp.src 'build/**/*'
      .pipe ghPages
        cacheDir: './release'
        message: "Publish from #{sourceId}"
        push: push
      .pipe end done

gulp.task 'stage', ['build'], publish push: false

gulp.task 'release', ['clean', 'assert:clean', 'build'], publish push: true

gulp.task 'default', ['build']
