{a, article, footer, div, h1, header, p, raw, text, tag} = require 'teacup'
{nest, date} = require './helpers'
base = require './base'

module.exports = nest base, (file) ->

  div '.blog-index', ->
    for post in file.pagination.files
      article ->
        if post.style
          tag 'style', scoped: true, ->
            raw post.style
        unless post.noHeader
          header ->
            h1 '.entry-title', ->
              a {href: post.path}, post.title
            p '.meta', ->
              date post
        div ".entry-content.#{post.slug}", ->
          raw post.less or post.contentsWithoutLayout
        if post.less
          footer ->
            a rel: 'full-article', href: post.path, '▨ More'

    div '.pagination', ->
      if file.pagination.next
        a '.prev', href: file.pagination.next.path, '← Older'
      a {href: '/archives/'}, 'Archives'
      if file.pagination.previous
        a '.next', href: file.pagination.previous.path, '→ Newer'
