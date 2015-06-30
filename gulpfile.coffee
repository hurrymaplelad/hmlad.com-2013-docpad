gulp = require 'gulp'
gutil = require 'gulp-util'
settings = require './settings'
logProcess = require 'process-logger'

gulp.task 'metalsmith', require './metalsmith'

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

gulp.task 'build', ['metalsmith', 'styles']

servers =
  dev: null
  selenium: null

gulp.task 'serve:dev', (done) ->
  connect = require 'connect'
  serveStatic = require 'serve-static'
  http = require 'http'
  port = settings.port

  app = connect()
    .use serveStatic('build')

  server = http.createServer app
    .on 'error', (err) ->
      if err.code is 'EADDRINUSE'
        fallbackPort = port + Math.floor(Math.random() * 1000)
        gutil.log "#{port} is busy, trying #{fallbackPort}"
        setImmediate -> server.listen fallbackPort
      else
        throw err
    .on 'listening', ->
      settings.port = server.address().port
      server.unref()
      done()
  server.listen port
  servers.dev = server

gulp.task 'serve:selenium', ->
  selenium = require 'selenium-standalone'
  tcpPort = require 'tcp-port-used'

  server = selenium
    stdio: settings.verbose and 'pipe' or 'ignore'
    ['-port', settings.seleniumServer.port]

  server.unref()
  if settings.verbose
    logProcess server, prefix: '[selenium-server]'

  servers.selenium = server
  return tcpPort.waitUntilUsed(settings.seleniumServer.port, 200, settings.testTimeout)

gulp.task 'crawl', ['build', 'serve:dev'], (done) ->
  Crawler = require 'simplecrawler'
  referrers = {}
  crawler = Crawler.crawl settings.devServerUrl()
    .on 'discoverycomplete', (item, urls) ->
      referrers[url] = item.url for url in urls
    .on 'fetchheaders', (item, res) ->
      unless res.statusCode is 200
        message = "Bad link #{res.statusCode} #{item.url} from #{referrers[item.url]}"
        gutil.log gutil.colors.red message
        throw new Error message
    .on 'complete', done
  crawler.timeout = settings.testTimeout

gulp.task 'mocha', ['build', 'serve:dev', 'serve:selenium'], (done) ->
  {spawn} = require 'child_process'
  extend = require 'extend'
  specFiles = 'specs/*.spec.coffee'

  mocha = spawn 'mocha', [
    '--compilers', 'coffee:coffee-script/register'
    '--reporter', 'spec'
    '--bail'
    '--timeout', settings.testTimeout
    specFiles
  ], env: extend({}, process.env, PORT: settings.port)
  .on 'exit', (code) ->
    done code or null

  logProcess mocha, prefix: settings.verbose and '[mocha]' or ''
  return null # don't return a stream

gulp.task 'spec', ['crawl', 'mocha']

gulp.task 'watch', ->
  watch = require 'este-watch'
  watch ['documents', 'templates', 'styles', 'static'], (e) ->
    gutil.log 'Changed', gutil.colors.cyan e.filepath
    switch e.extension
      when 'styl'
        gulp.start 'styles'
      else
        gulp.start 'metalsmith'
  .start()

gulp.task 'dev', ['build', 'serve:dev', 'watch']

gulp.task 'open', ['dev'], ->
  open = require 'open'
  open settings.devServerUrl()

gulp.task 'new:post', (done) ->
  template = require 'gulp-template'
  conflict = require 'gulp-conflict'
  rename = require 'gulp-rename'
  inquirer = require 'inquirer'
  string = require 'string'
  extend = require 'extend'
  end = require 'stream-end'

  inquirer.prompt [name: 'title', message: 'Title'], (answers) ->
    date = gutil.date new Date(), 'isoDate'
    slug = string(answers.title).slugify().s
    data = extend answers, {date, slug}

    gulp.src 'generators/post.ld'
      .pipe template(data)
      .pipe rename "#{date}-#{slug}.md"
      .pipe conflict 'documents/posts'
      .pipe gulp.dest 'documents/posts'
      .pipe end done

# Fails if there are uncommitted changes
gulp.task 'nochanges', (done) ->
  git = require 'gift'

  git('.').status (err, status) ->
    unless status?.clean
      for filename, status of status.files
        gutil.log gutil.colors.red "#{status.type} #{filename}"
      done new Error 'There are uncommitted changes'
    else
      done()

release = ({push}={}) ->
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

gulp.task 'stage', ['build'], release push: false

# Humans run this task to release
gulp.task 'publish', ['clean', 'nochanges', 'build', 'spec'], release push: true

# Machines like travis run this task after specs to release
gulp.task 'deploy', release push: true

gulp.task 'default', ['spec']
