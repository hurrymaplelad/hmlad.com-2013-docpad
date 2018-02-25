assets = require 'metalsmith-assets'
collections = require 'metalsmith-collections'
feed = require 'metalsmith-feed'
jekyllDates = require 'metalsmith-jekyll-dates'
markdown = require 'metalsmith-markdown'
metallic = require 'metalsmith-metallic'
metalsmith = require 'metalsmith'
more = require 'metalsmith-more'
pagination = require 'metalsmith-pagination'
permalinks = require 'metalsmith-permalinks'
teacup = require 'metalsmith-teacup'

module.exports = (done) ->
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

  .use pagination
    'collections.posts':
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
  .build done
