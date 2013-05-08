require 'sugar'
{time} = require 'teacup'

module.exports = 

  excerpt: (content) ->
    return unless content?
    [above, below] = content.split(/<!--\s*more\s*-->/i)
    if below? then above else content

  date: (document) ->
    date = document.date
    return unless date
    formatted = date.format '{Month} {ord}, {year}'

    time datetime: date.utc(true).toISOString(), formatted


