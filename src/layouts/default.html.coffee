{html, head, title, raw, body} = require 'teacup'

module.exports = ({document, content, getBlock}) ->
  block = (name) ->
    raw getBlock(name).toHTML()

  html ->
    head ->
      title document.title
      block 'meta'
      block 'styles'
    body ->
      raw content
      block 'scripts'
