{
  doctype, html, head, title, meta, link,
  body, header, footer, h1, br, div, p, a, raw,
  script, text
} = require 'teacup'

module.exports = ({site, document, content}) ->
  doctype 5
  throw new Error() unless {}.constructor is Object
  html '.no-js', lang: 'en', ->
    head ->
      meta charset: 'utf-8'
      title document.title or site.title

      meta name: 'author', content: site.author

      if document.description
        meta name: 'description', content: document.description
      if document.keywords
        meta name: 'keywords', content: document.keywords
      if document.canonical
        link rel: 'canonical', href: document.canonical

      meta name: 'viewport', content: 'width=device-width, initial-scale=1'

      link rel: 'icon', type: 'image/png', href: '/favicon.png'
      link rel: 'stylesheet', href: '/styles/main.css'

      # TODO: Add this. See https://github.com/docpad/twitter-bootstrap.docpad/blob/master/src/documents/atom.xml.eco
      # link rel: 'alternate', title: site.title, type: 'application/atom+xml', href: '/atom.xml'

      script """
        var _gaq = _gaq || [];
        _gaq.push(['_setAccount', '#{site.googleAnalytics.id}']);
        _gaq.push(['_trackPageview']);

        (function() {
          var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
          ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
          var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
        })();
      """

    body ->
      header ->
        h1 ->
          a href: '/', ->
            raw 'Hurry <br>Maple <br> Lad' 

      div '#main', ->
        div '#content', ->
          raw content

      footer ->
        p ->
          text "by #{site.author}"

          a '.linkedin.icon',
            href: 'http://www.linkedin.com/in/hurrymaplelad'
            target: '_blank'
          a '.goodreads.icon',
            href: 'http://www.goodreads.com/hurrymaplelad'
            target: '_blank'
          a '.stackoverflow.icon',
            href: 'http://stackoverflow.com/users/407845/hurrymaplelad'
            target: '_blank'
          a '.github.icon',
            href: 'https://github.com/hurrymaplelad'
            target: '_blank'
