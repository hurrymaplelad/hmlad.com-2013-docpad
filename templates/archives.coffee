require 'sugar'
{a, div, h1, h2, article, time} = require 'teacup'
{chain} = require './helpers'
page = require './page'

module.exports = chain page, (file) ->
  div '#blog-archives', ->
    prevYear = null
    for post in file.collections.posts
      year = post.date?.getFullYear()
      unless prevYear == year
        prevYear = year
        h2 year
      article ->
        h1 ->
          a href: post.path, post.title
        time post.date.format('{MON} {dd}').toUpperCase()
