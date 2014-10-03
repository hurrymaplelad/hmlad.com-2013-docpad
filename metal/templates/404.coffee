{a, h1, header, p} = require 'teacup'
{chain} = require './helpers'
page = require './page'

module.exports = chain page, (file) ->
  header ->
    h1 '.entry-title.status-code', '404'

  p ->
    a href: '/', 'start over'
