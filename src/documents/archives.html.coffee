---
title: Archives
layout: page
---
{a, div, h1, h2, article, time} = require 'teacup'

module.exports = (docpad) ->
  div '#blog-archives', ->
    posts = docpad.getCollection('posts').toArray().map('toJSON')
    prevYear = null
    for post in posts.reverse()
      year = post.date?.getFullYear()
      unless prevYear == year
        prevYear = year
        h2 year
      article ->
        h1 ->
          a href: post.url, post.title
        time post.date.format('{MON} {dd}').toUpperCase()
