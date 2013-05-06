require 'sugar'

module.exports = 
  plugins:
    datefromfilename:
      removeDate: true

  templateData:
    site:
      title: 'Hurry Maple Lad'
      author: 'Adam Hull'

  collections:
    posts: (database) ->
      database.findAllLive({post: true}, [date: -1])