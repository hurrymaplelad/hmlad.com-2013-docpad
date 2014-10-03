{
  doctype, html, head, title, meta, link,
  body, header, footer, h1, br, div, p, a, raw,
  script, text
} = require 'teacup'
{openGraph, googleAnalytics} = require './helpers'


module.exports = (file) ->
  {site} = file
  doctype 5

  html '.no-js', lang: 'en', ->
    head ->
      meta charset: 'utf-8'
      title file.title or site.title

      meta name: 'author', content: site.author

      if file.description
        meta name: 'description', content: file.description
      if file.keywords
        meta name: 'keywords', content: file.keywords
      if file.canonical
        link rel: 'canonical', href: file.canonical

      meta name: 'viewport', content: 'width=device-width, initial-scale=1'
      openGraph file

      link rel: 'icon', type: 'image/png', href: '/favicon.png'
      link rel: 'stylesheet', href: '/styles/main.css'
      link rel: 'alternate', title: site.title, type: 'application/rss+xml', href: '/rss.xml'

      googleAnalytics site.googleAnalytics.id

    body ->
      header ->
        h1 ->
          a href: '/', ->
            raw 'Hurry <br>Maple <br> Lad'

      div '#main', ->
        div '#content', ->
          raw file.contents

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
