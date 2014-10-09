{renderable} = require 'teacup'

require 'sugar'
{time} = require 'teacup'

exports.date = renderable (file, {format}={}) ->
  format ?= '{Month} {ord}, {year}'
  date = file.date
  return unless date
  formatted = date.format format

  time datetime: date.utc(true).toISOString(), formatted


{meta} = require 'teacup'
string = require 'string'
exports.openGraph = renderable (file) ->
  {site} = file
  if file.title
    meta property: 'og:title', content: file.title
  if file.thumbnail
    meta property: 'og:image', content: site.url + file.thumbnail
  if file.less
    meta property: 'og:description', content: string(file.less).stripTags().s
  meta property: 'og:site_name', content: site.title
  meta property: 'og:url', content: site.url + file.path


{div, script} = require 'teacup'
exports.disqus = renderable ({shortname, url}) ->
  div '#disqus_thread'
  script [
    "window.disqus_shortname = '#{shortname}'"
    "window.disqus_url = '#{url}'" if url
  ].join '; '
  script async: true, src: "//#{shortname}.disqus.com/embed.js", ''


{script} = require 'teacup'
exports.googleAnalytics = renderable (analyticsId) ->
  script """
    var _gaq = _gaq || [];
    _gaq.push(['_setAccount', '#{analyticsId}']);
    _gaq.push(['_trackPageview']);

    (function() {
      var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
      ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
      var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
    })();
  """

{render, renderable} = require 'teacup'
exports.nest = (parent, layout) ->
  renderable (file) ->
    file = Object.create(file)
    file.contents = render layout, file
    parent file


