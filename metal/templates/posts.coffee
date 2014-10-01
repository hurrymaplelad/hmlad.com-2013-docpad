{a, article, footer, div, h1, header, p, raw, text, tag} = require 'teacup'
# {excerpt, hasExcerpt, date} = require '../partials/helpers'

module.exports = (file) ->

  # # TODO: and this
  # page = document.page
  # page.docs = docpad.getCollection(document.pagedCollection)
  #   .slice(page.startIdx, page.endIdx)
  #   .map((doc) -> doc.toJSON())
  # page.hasNextPage = -> documentModel.hasNextPage()
  # page.hasPrevPage = -> documentModel.hasPrevPage()
  # page.getNextPage = -> documentModel.getNextPage()
  # page.getPrevPage = -> documentModel.getPrevPage()

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
              # date post
        content = post.contentRenderedWithoutLayouts
        div ".entry-content.#{post.basename}", ->
        #   raw excerpt content
        # if hasExcerpt content
        #   footer ->
        #     a rel: 'full-article', href: post.url, '▨ More'

    div '.pagination', ->
      if file.paginate.next
        a '.prev', href: file.paginate.next.path, '← Older'
      a {href: '/archives/'}, 'Archives'
      if file.paginate.previous
        a '.next', href: file.paginate.previous.path, '→ Newer'
