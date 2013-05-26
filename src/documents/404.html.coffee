---
layout: page
---
{a, h1, header, p} = require 'teacup'

module.exports = (docpad) ->
  header ->
    h1 '.entry-title.status-code', '404'

  p ->
    a href: '/', 'start over'
