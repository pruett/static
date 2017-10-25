module.exports =

  makeStartCase: (str) ->
    str = if str then "#{str}" else ''
    str = str.replace /\b\w/g, (letter) -> letter.toUpperCase()
    str.replace /\b(A|An|And|By|For|From|Of|Or|With)\b/g, (word) -> word.toLowerCase()

