{meta} = require 'teacup'
{excerpt, hasExcerpt, date} = require './helpers'
stripHtml = require 'htmlstrip-native'

module.exports = ({site, document}) ->
  if document.title
    meta property: 'og:title', content: document.title
  if document.thumbnail
    meta property: 'og:image', content: site.url + document.thumbnail
  content = document.contentRenderedWithoutLayouts
  if hasExcerpt content
    meta property: 'og:description', content: stripHtml.html_strip excerpt content
  meta property: 'og:site_name', content: site.title
  meta property: 'og:url', content: site.url + document.url

