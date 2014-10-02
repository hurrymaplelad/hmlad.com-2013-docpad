{a, article, footer, div, h1, header, p, raw, renderable, text, tag} = require 'teacup'
{extendLayout, date} = require './helpers'
defaultLayout = require './default'

module.exports = extendLayout defaultLayout, renderable (file) ->

  div '.blog-index', ->
    for post in file.paginate.files
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
        div ".entry-content.#{post.basename}", ->
          raw post.less or post.contentsWithoutLayout
        if post.less
          footer ->
            a rel: 'full-article', href: post.path, '▨ More'

    div '.pagination', ->
      if file.paginate.next
        a '.prev', href: file.paginate.next.path, '← Older'
      a {href: '/archives/'}, 'Archives'
      if file.paginate.previous
        a '.next', href: file.paginate.previous.path, '→ Newer'
