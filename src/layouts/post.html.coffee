---
layout: default
---
{h1, div, raw} = require 'teacup'

module.exports = ({document, content}) ->
  h1 document.title
  div ->
    raw content
