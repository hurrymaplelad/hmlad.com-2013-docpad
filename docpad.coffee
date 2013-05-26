require 'sugar'

module.exports = 
  env: 'static'
  
  templateData:
    site:
      title: 'Hurry Maple Lad'
      author: 'Adam Hull'

  collections:
    posts: (database) ->
      database.findAllLive({post: true}, [date: -1])

  plugins:
    datefromfilename:
      removeDate: true