---
layout: default
---
{article, h1, header, div, raw} = require 'teacup'

module.exports = ({document, content}) ->
  div ->
    article ->
      if document.title
        header ->
          h1 '.entry-title', document.title
      div ->
        raw content
