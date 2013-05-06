---
layout: default
isPaged: true
pagedCollection: posts
pageSize: 2
---
{a, article, footer, div, h1, header, p, raw, text} = require 'teacup'
{excerpt} = require '../partials/helpers'

module.exports = (docpad) ->
  # TODO: extract this
  document = docpad.document
  documentModel = docpad.getDocument()

  # TODO: and this
  page = document.page
  page.docs = docpad.getCollection(document.pagedCollection)
    .slice(page.startIdx, page.endIdx)
    .map((doc) -> doc.toJSON())
  page.hasNextPage = -> documentModel.hasNextPage()
  page.hasPrevPage = -> documentModel.hasPrevPage()
  page.getNextPage = -> documentModel.getNextPage()
  page.getPrevPage = -> documentModel.getPrevPage()

  div '.blog-index', ->
    for post in page.docs
      article ->
        header ->
          h1 '.entry-title', ->
            a href: post.url

        text post.url
        raw excerpt post.contentRenderedWithoutLayouts

  div '.pagination', ->
    if page.hasNextPage()
      a '.prev', href: page.getNextPage(), '← Older'
    a {href: '/archives'}, 'Archives'
    if page.hasPrevPage()
      a '.next', href: page.getPrevPage(), '→ Newer'
