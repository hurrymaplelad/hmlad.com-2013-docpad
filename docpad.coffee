require 'sugar'

module.exports =
  env: 'static'

  templateData:
    site:
      title: 'HurryMapleLad'
      author: 'Adam Hull'
      url: 'http://hurrymaplelad.com'

      googleAnalytics:
        id: 'UA-35976996-1'


  collections:
    posts: (database) ->
      database.findAllLive({post: true}, [date: -1])

  plugins:
    datefromfilename:
      removeDate: true
    cleanurls:
      trailingSlashes: true
    rss:
      collection: 'posts'