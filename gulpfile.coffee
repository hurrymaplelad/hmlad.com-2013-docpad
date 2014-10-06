gulp = require 'gulp'
gutil = require 'gulp-util'
settings = require './settings'

gutil.log 'Settings:'
for key, value of settings when typeof value isnt 'function'
  gutil.log gutil.colors.cyan(key), gutil.colors.magenta(value)
settings

gulp.task 'generate', (done) ->
  metalsmith = require './metalsmith'
  metalsmith done

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

gulp.task 'new:post', (done) ->
  template = require 'gulp-template'
  conflict = require 'gulp-conflict'
  rename = require 'gulp-rename'
  inquirer = require 'inquirer'
  slugify = require 'slug'
  extend = require 'extend'
  end = require 'stream-end'

  inquirer.prompt [name: 'title', message: 'Title'], (answers) ->
    date = gutil.date new Date(), 'isoDate'
    slug = slugify answers.title.toLowerCase()
    data = extend answers, {date, slug}

    gulp.src 'generators/post.ld'
      .pipe template(data)
      .pipe rename "#{date}-#{slug}.md"
      .pipe conflict 'documents/posts'
      .pipe gulp.dest 'documents/posts'
      .pipe end done

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

gulp.task 'release', ['clean', 'assert:clean', 'build', 'spec'], publish push: true

gulp.task 'default', ['spec']
