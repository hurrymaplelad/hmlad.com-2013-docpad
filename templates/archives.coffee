Sugar = require 'sugar'
{a, div, h1, h2, article, time} = require 'teacup'
{nest} = require './helpers'
page = require './page'

module.exports = nest page, (file) ->
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
        time Sugar.Date.format(post.date, '{Mon} {dd}').toUpperCase()
