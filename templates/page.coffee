{article, h1, header, div, raw} = require 'teacup'
{nest} = require './helpers'
base = require './base'

module.exports = nest base, (file) ->
  div ->
    article ->
      if file.title
        header ->
          h1 '.entry-title', file.title
      div ->
        raw file.contents
