{article, h1, header, div, raw} = require 'teacup'
{chain} = require './helpers'
base = require './base'

module.exports = chain base, (file) ->
  div ->
    article ->
      if file.title
        header ->
          h1 '.entry-title', file.title
      div ->
        raw file.contents
