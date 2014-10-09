{a, h1, header, p} = require 'teacup'
{nest} = require './helpers'
page = require './page'

module.exports = nest page, (file) ->
  header ->
    h1 '.entry-title.status-code', '404'

  p ->
    a href: '/', 'start over'
