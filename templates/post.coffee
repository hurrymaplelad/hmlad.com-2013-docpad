url = require 'url'
base = require './base'
{a, article, div, footer, h1, header, p, script, style, tag, text, raw} = require 'teacup'
{date, disqus, nest} = require './helpers'

module.exports = nest base, (file) ->
  {site} = file

  div ->
    article '.hentry', role: 'article', ->
      if file.style
        tag 'style', scoped: true, ->
          raw file.style

      unless file.noHeader
        header ->
          h1 '.entry-title', file.title
          p '.meta', ->
            date file
          if file.canonical?
            p '.meta.canonical', ->
              text
              a href: file.canonical, target: '_blank', ->
                text 'Crossposted from '
                text url.parse(file.canonical, false, true).host

      div ".entry-content.#{file.basename}", ->
        raw file.contents

      footer ->
        p '.meta', ->
          if next = file.next
            a '.basic-alignment.left', href: next.path, ->
              raw '&laquo; '
              text next.title

          if previous = file.previous
            a '.basic-alignment.right', href: previous.path, ->
              text previous.title
              raw ' &raquo;'

        if file.disqus
          disqus
            shortname: file.disqus.shortname
            url: file.disqus.url or file.canonical or site.url + file.path
