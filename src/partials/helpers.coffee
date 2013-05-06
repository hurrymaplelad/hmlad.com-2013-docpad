module.exports = 

  excerpt: (content) ->
    return unless content?
    [above, below] = content.split(/<!--\s*more\s*-->/i)
    if below? then above else content
