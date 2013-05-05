---
layout: default
isPaged: true
pagedCollection: html
pageSize: 2
---
{div, article, a, text} = require 'teacup'
utils = require 'util'

module.exports = (docpad) ->
  # TODO: extract this
  document = docpad.document
  documentModel = docpad.getDocument()

  # TODO: and this
  page = document.page
  page.docs = docpad.getCollection(document.pagedCollection)[page.startIdx...page.endIdx]
  page.hasNextPage = -> documentModel.hasNextPage()
  page.hasPrevPage = -> documentModel.hasPrevPage()
  page.getNextPage = -> documentModel.getNextPage()
  page.getPrevPage = -> documentModel.getPrevPage()

  div '.blog-index', ->
    for post in page.docs
      article ->
        text post.get('title')
        # index=true; {% include post_listing.html %}

  div '.pagination', ->
    if page.hasNextPage()
      a '.prev', href: page.getNextPage(), '← Older'
    a {href: '/archives'}, 'Archives'
    if page.hasPrevPage()
      a '.next', href: page.getPrevPage(), '→ Newer'
